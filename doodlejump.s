#####################################################################
#
# CSCB58 Fall 2020 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Jin Rong Cao, Student 1005043123
#
# Bitmap Display Configuration:
# - Unit width in pixels: 16					     
# - Unit height in pixels: 16
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). 
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
	# Technical Info
	displayAddress:	.word	0x10008000
	screenWidth: 	.word 512
	screenHeight: 	.word 512
	platformWidth: .word  6
	screenSize: .word 1024
	
	# Coordinates
	platforms: .space 24
	doodleStart: .word 3904
	
	# Colours
	backgroundColour: .word 0xf5f5dc
	platformColour: .word 0xdeb887
	doodleColour: .word 0x556b2f
	
	# Animation
	sleepDelay: .word 100
	
	# Testing
	testing: .asciiz "Goes in here "
 	paintingScreen: .asciiz "Painting screen "
 	paintingPlatforms: .asciiz "Painting platforms"
 	paintingDoodle: .asciiz "Painting doodle"
 	startShiftingPlatforms: .asciiz "Start shifting platforms"
 	shiftingPlatforms: .asciiz "Currently shifting platforms"
 	endShiftingPlatforms: .asciiz "Ending shifting platforms"
 	onPlatforms: .asciiz "Currently on platforms"
 	newline: .asciiz "\n"
	
.text
main:
	lw $t1, platformColour			# $t1 stores the brown
	lw $t2, backgroundColour		# $t2 stores the beige colour
	la $s6, platforms 			# Array with 6 int spots for platform locations
	lw $t9, screenSize			# Screen size
	lw $s7, doodleStart 			# $s7 is Doodle's centre/location
	li $s3, 0				# Restart or not
	
### Generate Platforms ##
platformInit:
	lw $t0, displayAddress
	li $s0, 3456				# Offset for platforms
	
baseDoodlePlatform:
	addi $t7, $gp, 4020
	sw $t7, 0($s6)
	addi $t3, $zero, 4			# Counter/Offset for the array - Set to 4 as need base platform
		
generatePlatform:
	add $t5, $s6, $t3 			# Current array location

	# Generate a random platform coordinate
	li $v0, 42
	li $a0, 0
	li $a1, 26
	syscall
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	add $t7, $gp, $t6
	add $t7, $t7, $s0
	
	# Store the platform location
	sw $t7, 0($t5)
	addi $t3, $t3, 4			# Move offset by 4 into next array position
	addi $s0, $s0, -640
	bne $t3, 24, generatePlatform
	
### Fill Background ###
backgroundInit: 
	# Sleep to delay animation
	li $v0, 32		
	lw $a0, sleepDelay
	syscall

	li $t3, 0 				# Counter for filling in background
	lw $t0, displayAddress
	lw $t2, backgroundColour		# $t2 stores the beige colour
	lw $t9, screenSize			# Screen size

backgroundLoop:
	sw $t2, 0($t0)
	add $t0, $t0, 4				 # Move along the screen
	addi $t3, $t3, 1
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, paintingScreen
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 		
	
	bne $t3, $t9, backgroundLoop

	
### Draw the Platforms ###	
drawPlatformInit:
	li $t4, 0				# Counter for loading array in from memory (i.e. offset)
	li $t6, 0				# Counter for number of pixels to draw
	lw $a0, platformWidth			# Width of each platform
	lw $t1, platformColour
	
drawPlatform:	
	add $t5, $s6, $t4
	lw $t7, 0($t5)
	sw $t1, 0($t7)
	sw $t1, 4($t7)
	sw $t1, 8($t7)
	sw $t1, 12($t7)
	sw $t1, 16($t7)
	sw $t1, 20($t7)
	addi $t4, $t4, 4
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, paintingPlatforms
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	
	bne $t4, 24, drawPlatform		# Have not painted all 6 platforms

### Draw Doodle ###
doodledraw:
	lw $a3, doodleColour			# $a3 stores colour of doodle
	add $t5, $gp, $s7
	sw $a3, 0($t5)				# Draw the doodle
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, paintingDoodle
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	

### Check for Keyboard Input ###
initialKeyboardCheck:
	lw $t5, 0xffff0000 
	beq $t5, 1, startGame
	beq $s3, 1, doodleJumpInit
	
startGame:
	lw $t5, 0xffff0004 
	bne $t5, 0x73, initialKeyboardCheck
	
doodleJumpInit:
	li $t6, 0
	move $t3, $t2				# Initial colour
	
doodleJumpUp:	
	addi $s7, $s7, -128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s7			# pixel of the row one up
	sw $t3, 128($t7)			# Colour previous doodle spot with background colour
	
	jal processMovement			# Colour in the new spot
	
	addi $t6, $t6, 1
	
	# Sleep to delay animation
	li $v0, 32		
	lw $a0, sleepDelay
	syscall
	
	jal keyboardCheck			# Check if any of the keys are pressed
	
	jal checkPlatformInit			# Check if the doodle has reached any of the platforms before jumping again	
	
	bne $t6, 10, doodleJumpUp
	
doodleJumpDown:	
	addi $s7, $s7, 128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s7			# pixel of the row one up
	sw $t3, -128($t7)			# Colour previous doodle spot with background colour
	
	jal processMovement			# Colour in the new spot
	
	addi $t6, $t6, -1
	
	# Sleep to delay animation
	li $v0, 32		
	lw $a0, sleepDelay
	syscall
	
	jal keyboardCheck			# Check if any of the keys are pressed
	
	jal checkPlatformInit			# Check if the doodle landed on any of the platforms
	
	addi $t5, $s7, -4068
	bgez $t5, main				# Fell off screen, completely restart the game
	
	bne $t6, 10, doodleJumpDown
	
keyboardCheck:
	lw $t5, 0xffff0000 
	beq $t5, 1, keyboardInput
	
	jr $ra					# No keyboard input so jump back to whatever we were doing before
	
keyboardInput:
	lw $t5, 0xffff0004 
	beq $t5, 0x6A, leftInput
	beq $t5, 0x6B, rightInput
	j initialKeyboardCheck			# The key entered wasn't valid, check for valid
	
leftInput:
	addi $s7, $s7, -4			# Move doodle location exactly 1 pixel left
	add $t7, $gp, $s7			# pixel of spot to the left
	lw $t2, backgroundColour		# $t2 stores the beige colour
	sw $t2, 4($t7)				# Colour previous doodle spot with background colour
	
	j processMovement			# Colour in the new spot
	
rightInput:
	addi $s7, $s7, 4			# Move doodle location exactly 1 pixel right
	add $t7, $gp, $s7			# pixel of spot to the right
	lw $t2, backgroundColour		# $t2 stores the beige colour
	sw $t2, -4($t7)				# Colour previous doodle spot with background colour
		
	j processMovement			# Colour in the new spot


processMovement:
	lw $t3, 0($t7)				# save colour at the new location
	sw $a3, 0($t7)				# load doodle colour at new location
	
	jr $ra
	
### Check for jumping onto a platform ###
checkPlatformInit:
	addi $sp, $sp, -4			# Make space on the stack to store $ra to jump back later, otherwise we're lost
	sw $ra, 0($sp)				# Pointer back to either doodleJumpUp/doodleJumpDown
	li $t4, 0				# Offset for array
	
	jal retrievePlatform
	
	lw $ra, 0($sp)
	jr $ra
	
retrievePlatform:
	add $t5, $s6, $t4			# Array Position
	lw $t8, 0($t5)				# Load platform coordinate from array
	addi $s0, $t8, 24			# 6 pixels down from platform
	
checkDoodleOnPlatform:
	add $t9, $gp, $s7			# Address of doodle
	beq $t9, $t8, doodleOnPlatform		# Doodle is on the platform, $t8 is the PLATFORM that was "hit"	
	
	addi $t8, $t8, 4
	
	bne $t8, $s0, checkDoodleOnPlatform	# Haven't finished checking all of the platform
	
	addi $t4, $t4, 4			# Move to next platform in list (a.k.a finishing checking one platform)
	bne $t4, 24, retrievePlatform		# Haven't finished checking all the platforms
	
	j doodleNotOnPlatform

doodleOnPlatform:
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, onPlatforms
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	
	lw $t0, platformColour			# Load platform colour
	sw $t0, 0($t9)				# Store platform colour where doodle hit platform	
	
	addi $s7, $s7, -128			# Doodle reached a platform so place it directly above the platform
	
	lw $ra, 0($sp)				# Load back the return address
	addi $sp, $sp, 4			# Shrink the stack back

	lw $t3, backgroundColour		# Replace previous pixels with background colour
	
	li $t9, 4				# Counter for platforms array
	li $t6, 0				# Reset jumping counter
	
	
	# We only want to shift platforms IFF we are not on a platform at bottom of the screen
	lw $t0, 0($s6)
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	beq $t8, $t0, doodleJumpUp
	add $t0, $t0, 4
	
	add $t9, $zero, $zero
	
	j shiftPlatforms
	j doodleJumpUp
		
doodleNotOnPlatform:
	jr $ra					# Continue back to point in the program


## Scroll the screen ###
shiftPlatforms:
	
	 # Currently Painting Screen
 	li $v0, 4
 	la $a0, startShiftingPlatforms
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	
	lw $a2, 4($s6)
	addi $a2, $a2, 384
	sw $a2, 0($s6)
	
	lw $a2, 8($s6)
	addi $a2, $a2, 384
	sw $a2, 4($s6)
	
	lw $a2, 12($s6)
	addi $a2, $a2, 384
	sw $a2, 8($s6)
	
	lw $a2, 16($s6)
	addi $a2, $a2, 384
	sw $a2, 12($s6)

	lw $a2, 20($s6)
	addi $a2, $a2, 384
	sw $a2, 16($s6)
	
	
	#add $t6, $s6, $t9			# Array offset/position
	#lw $a2, 4($t6)				# Get platform in that array position
	#addi $a2, $a2, 384			# Shift platforms 3 rows downwards
	#sw $a2, 0($t6)				# Store this new platform coordinate in the previous spot i.e. A[i] = A[i + 1]
	#addi $t9, $t9, 4
	#bne $t9, 20, shiftPlatforms
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, shiftingPlatforms
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	
	# Generate a random platform coordinate
	li $v0, 42
	li $a0, 0
	li $a1, 26
	syscall
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	add $t9, $gp, $t6
	
	# Store the platform location
	sw $t9, 20($s6)				# Store this platform as last one in the array
	
	# Sleep to delay animation
	li $v0, 32		
	li $a0, 20
	syscall
	
	# Currently Painting Screen
 	li $v0, 4
 	la $a0, endShiftingPlatforms
 	syscall
 	
 	li $v0, 4 		
 	la $a0, newline 	
 	syscall 
	
	li $s3, 1
	j backgroundInit
	
Exit:
	li $v0, 10 				# terminate the program gracefully
	syscall
