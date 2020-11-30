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
	doodleLocation: .asciiz "Doodle location is "
	platformLocation: .asciiz "Platform location is"
	newline: .asciiz "\n"
	
.text
main:
	#lw $t0, displayAddress			# $t0/$gp stores the base address for display
	lw $t1, platformColour			# $t1 stores the brown
	lw $t2, backgroundColour		# $t2 stores the beige colour
	la $s6, platforms 			# Array with 6 int spots for platform locations
	lw $t9, screenSize			# Screen size
	
	
### Fill Background ###
backgroundinit: 
	li $t3, 0 				# Counter for filling in background
	lw $t0, displayAddress

backgroundloop:
	sw $t2, 0($t0)
	add $t0, $t0, 4				 # Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, backgroundloop

### Draw + Generate Platforms ##
platformInit:
	lw $t0, displayAddress
	addi $t3, $zero, 0			# Counter/Offset for the array
	addi $t4, $t4, 0			# Counter for number of platforms to generate
	li $s0, 3968				# Offset for platforms
	
	li $t6, 0 				# Counter for pixel width
	lw $a0, platformWidth			# Width of each platform
	
baseDoodlePlatform:
	addi $t7, $gp, 4020
	sw $t7, 0($s6)
	j drawPlatform

		
generatePlatform:
	add $t5, $s6, $t3 			# Current array location

	# Generate a random platform coordinate
	li $v0, 42
	li $a0, 0
	li $a1, 32
	syscall
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	add $t7, $gp, $t6
	add $t7, $t7, $s0
	
	# Store the platform location
	sw $t7, 0($t5)
	li $t6, 0
	lw $a0, platformWidth	
	
drawPlatform:
	# Draw the platform to be platformWidth pixels wide
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	bne $t6, $a0, drawPlatform
	
	addi $t4, $t4, 1
	addi $s0, $s0, -640
	addi $t3, $t3, 4			# Move offset by 4 into next array position
	bne $t4, 6, generatePlatform
	

### Draw Doodle ###
doodledraw:
	lw $a3, doodleColour			# $a3 stores colour of doodle
	lw $s7, doodleStart 			# $s7 is Doodle's centre/location
	add $t5, $gp, $s7
	
	sw $a3, 0($t5)				# Draw the doodle


### Check for Keyboard Input ###
initialKeyboardCheck:
	lw $t5, 0xffff0000 
	beq $t5, 1, startGame
	
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
	
	bne $t6, 8, doodleJumpUp
	
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
	
	addi $t5, $s7, -3968
	bgez $t5, doodleJumpInit		# TODO: Fix so when reach bottom of screen go to game over or smth
	
	bne $t6, 8, doodleJumpDown
	
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
	sw $t2, 4($t7)				# Colour previous doodle spot with background colour
	
	j processMovement			# Colour in the new spot
	
rightInput:
	addi $s7, $s7, 4			# Move doodle location exactly 1 pixel right
	add $t7, $gp, $s7			# pixel of spot to the right
	sw $t2, -4($t7)				# Colour previous doodle spot with background colour
	
	j processMovement			# Colour in the new spot


processMovement:
	lw $t3, 0($t7)				# save colour at the new location
	sw $a3, 0($t7)				# load doodle colour at new location
	
	jr $ra
	

### Check for jumping onto a platform ###
checkPlatformInit:
	addi $sp, $sp, -4			# Make space on the stack to store $ra to jump back later, otherwise we're lost
	sw $ra, 0($sp)
	li $t4, 0				# Offset for array
	
retrievePlatform:
	add $t5, $s6, $t4			# Array Position
	lw $t8, 0($t5)				# Load platform coordinate from array
	addi $s0, $t8, 24			# 6 pixels down from platform
	
checkDoodleOnPlatform:
	add $t9, $gp, $s7			# Address of doodle
	beq $t9, $t8, doodleOnPlatform		# Doodle is on the platform	
	
	addi $t8, $t8, 4
	
	bne $t8, $s0, checkDoodleOnPlatform	# Haven't finished checking all of the platform
	
	addi $t4, $t4, 4			# Move to next platform in list (a.k.a finishing checking one platform)
	bne $t4, 24, retrievePlatform		# Haven't finished checking all the platforms
	
	j doodleNotOnPlatform

doodleOnPlatform:	
	addi $s7, $s7, -128			# Doodle reached a platform so place it directly above the platform
	
	lw $ra, 0($sp)				# Load back the return address
	addi $sp, $sp, 4			# Shrink the stack back
	
	lw $t3, backgroundColour		# Background colour where doodle was
	
	jr $ra
		
doodleNotOnPlatform:
	#li $t6, 0
	jr $ra

	

Exit:
	li $v0, 10 				# terminate the program gracefully
	syscall
