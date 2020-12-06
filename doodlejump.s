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
# 1. Fancier Graphics
# 2. Dynamic on-screen notifications
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). 
#
# Any additional information that the TA needs to know:
# - The random platform generation might require some luck, despite 
#   the fact I tried to make the platforms as "uniform" as possible
# - The game unfortunately isn't as smooth as I would have liked
#   this was due to the fact I simply ran out of time as I had multiple
#   assignments due Dec 7th
#
#####################################################################

.data
	# Technical Info
	displayAddress:	.word	0x10008000
	screenWidth: 	.word 512
	screenHeight: 	.word 512
	platformWidth: .word  28
	screenSize: .word 1024
	
	# Coordinates
	platforms: .space 48
	doodleStart: .word 3904
	
	# Colours
	backgroundColour: .word 0xf5f5dc
	platformColour: .word 0xdeb887
	doodleColour: .word 0x556b2f
	scoreColour: .word 0x228b22
	wordColour: .word 0x3090c7
	darkBrown: .word 0xcd853f
	oliveGreen: .word 0x6b8e23
	olive: .word 0x808000
	goldenRod: .word 0xfffacd
	forestGreen: .word 0x228b22
	lightGreen: .word 0x98fb98
	
	# Animation
	sleepDelay: .word 100
	
	# Pixels of Numbers 0-9
	allNumbers: .word 
	 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1,
	 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1,
	 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1,
	 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1,
	 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1,
	 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1,
	 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1,
	 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1
	 
	 # Pixels for letters
	 letterA: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1
	 letterB: .word 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1
	 letterC: .word 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1
	 letterD: .word 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0
	 letterE: .word 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1
	 letterG: .word 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1
	 letterH: .word 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1
	 letterI: .word 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1
	 letterJ: .word 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1
	 letterL: .word 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1
	 letterM: .word 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1
	 letterO: .word 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0 ,1, 1, 1, 1
	 letterP: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0
	 letterR: .word 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1
	 letterS: .word 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1
	 letterT: .word 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0
	 letterU: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1
	 letterV: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0
	 letterW: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1
	 letterY: .word 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0
	 exclaimMark: .word 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
	 colonMark: .word 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0
	 
.text
main:
	la $s6, platforms 			# Array with 6 int spots for platform locations
	lw $t9, screenSize			# Screen size
	li $s3, 0				# Restart or not
	li $s2, 0				# Score for the player
	la $s4, allNumbers			# Address of the array of all the pixel numbers
	lw $a3, platformWidth			# Platform width
	lw $v1, sleepDelay
			
### Start Screen ###
drawStartInit:
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
  
	li $t3, 0 				# Counter for filling in background
	lw $t0, displayAddress
	lw $t2, goldenRod			
	lw $t9, screenSize			# Screen size

drawStartBackground:
	sw $t2, 0($t0)				# Paint the pixel
	add $t0, $t0, 4				# Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, drawStartBackground

drawStartText:
	lw $a1, doodleColour

	# Draw the word "Doodle"
	la $a0, letterD
	li $a2, 144
	jal drawCharInit
	la $a0, letterO
	li $a2, 160
	jal drawCharInit
	la $a0, letterO
	li $a2, 176
	jal drawCharInit 
	la $a0, letterD
	li $a2, 192
	jal drawCharInit
	la $a0, letterL
	li $a2, 208
	jal drawCharInit
	la $a0, letterE
	li $a2, 224
	jal drawCharInit
	
	# Draw the word "jump"
	la $a0, letterJ
	li $a2, 928
	jal drawCharInit
	la $a0, letterU
	li $a2, 944
	jal drawCharInit
	la $a0, letterM
	li $a2, 960
	jal drawCharInit 
	la $a0, letterP
	li $a2, 976
	jal drawCharInit
	
	lw $a1, darkBrown
	
	# Draw the char "s"
	la $a0, letterS
	li $a2, 2440
	jal drawCharInit
	
	# Draw the word "to"
	la $a0, letterT
	li $a2, 2460
	jal drawCharInit
	la $a0, letterO
	li $a2, 2476
	jal drawCharInit
	
	# Draw the word "start"
	la $a0, letterS
	li $a2, 3208
	jal drawCharInit
	la $a0, letterT
	li $a2, 3224
	jal drawCharInit
	la $a0, letterA
	li $a2, 3240
	jal drawCharInit
	la $a0, letterR
	li $a2, 3256
	jal drawCharInit
	la $a0, letterT
	li $a2, 3272
	jal drawCharInit

drawBouncingDoodleInit:
	lw $t1, oliveGreen
	lw $t2, doodleColour			# Doodle of colour
	li $s1, 3948
	lw $t3, goldenRod 
	li $t6, 0

bounceStaticDoodleUp:
	addi $s1, $s1, -128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s1			# pixel of the row one up
	
	sw $t3, 124($t7)			# Colour previous doodle spot with background colour
	sw $t3, 132($t7)			# Colour previous doodle spot with background colour
	sw $t3, 0($t7)				# Colour previous doodle spot with background colour
	
	jal drawBouncingDoodle
	
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	jal initialKeyboardCheck
	
	addi $t6, $t6, 1
	
	bne $t6, 8, bounceStaticDoodleUp
	
bounceStaticDoodleDown:
	addi $s1, $s1, 128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s1			# pixel of the row one up
	sw $t3, -260($t7)			# Colour previous doodle spot with background colour
	sw $t3, -252($t7)
	sw $t3, -384($t7)
	
	jal drawBouncingDoodle
	
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	jal initialKeyboardCheck
	
	addi $t6, $t6, -1
	
	bne $t6, 0, bounceStaticDoodleDown
	
	j bounceStaticDoodleUp

initialKeyboardCheck:
	lw $t5, 0xffff0000 
	beq $s3, 1, doodleJumpInit
	
startGame:
	lw $t5, 0xffff0004 
	beq $t5, 0x73, platformInit	# the "s" key
	
	jr $ra
	
	
### Generate Platforms ##
platformInit:
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	lw $t0, displayAddress
	li $s0, 3456				# Offset for platforms
	lw $s7, doodleStart 			# $s7 is Doodle's centre/location
	li $s1, 8				# How much the doodle can jump up/down by
	
baseDoodlePlatform:				# Initial platform for the doodle to stand on
	addi $t7, $gp, 4020
	sw $t7, 0($s6)
	addi $t7, $t7, 24			# End point
	sw $t7, 4($s6)
	addi $t3, $zero, 8			# Counter/Offset for the array - Set to 4 as need base platform
		
generatePlatform:
	add $t5, $s6, $t3 			# Current array location

	# Generate a random platform coordinate with range 7-28 on the screen
	li $v0, 42
	li $a0, 0
	li $a1, 18
	syscall
	addi $a0, $a0, 10
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	add $t7, $gp, $t6
	add $t7, $t7, $s0
	
	# Store the platform location AND it's endpoint
	sw $t7, 0($t5)
	add $t7, $t7, $a3
	sw $t7, 4($t5)
	
	addi $t3, $t3, 8			# Move offset by 4 into next array position
	addi $s0, $s0, -640
	bne $t3, 48, generatePlatform
	
### Fill Background ###
backgroundInit:
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
  
	li $t3, 0 				# Counter for filling in background
	lw $t0, displayAddress
	lw $t2, backgroundColour		# $t2 stores the beige colour
	lw $t9, screenSize			# Screen size

backgroundLoop:
	sw $t2, 0($t0)				# Paint the pixel
	add $t0, $t0, 4				# Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, backgroundLoop
	
### Draw Doodle ###
doodledraw:
	lw $t1, oliveGreen
	lw $t2, doodleColour			
	
	# Draw the doodle
	add $t5, $gp, $s7
	
	sw $t2, 4($t5)
	sw $t2, -4($t5)
	sw $t1, -128($t5)
	sw $t1, -124($t5)
	sw $t1, -132($t5)
	sw $t2, -256($t5)
	
### Draw the Platforms ###	
drawPlatformInit:
	li $t4, 0				# Counter for loading array in from memory (i.e. offset)
	li $t6, 0				# Counter for number of pixels to draw
	lw $a0, platformWidth			# Width of each platform
	lw $t1, platformColour			# Colour of the platform
		
drawPlatform:					# Loop through to paint the platforms
	add $t5, $s6, $t4
	lw $t7, 0($t5)				# Platform START point
	lw $t2, 4($t5)				# Platform END point
	jal drawPlatformPixels			# Draw each platform pixel
	addi $t4, $t4, 8
	
	bne $t4, 48, drawPlatform		# Have not painted all 6 platforms
	
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	j drawFirstScoreInit
	
drawPlatformPixels:
	#add $t7, $t7, $t2
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	bne $t7, $t2, drawPlatformPixels
	
	jr $ra
	
	
### Draw score in top left corner ###
drawFirstScoreInit:
	lw $a1, scoreColour
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	# Break score into 2 pieces
	li $t1, 10
	div $s2, $t1
	mflo $a0
	
	# Multiply by 15 for the number
	li $t1, 15
	mult $a0, $t1
	mflo $a0
	
	# Multiply by 4 as word-aligned
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	
	add $a0, $s4, $t1
	
drawFirstPixelRow:
	addi $t5, $zero, 0			# Counter for going through all 5 rows (i.e. j)
	add $t4, $gp, $t3			# Top row position
	jal drawFirstPixelCol
	addi $t3, $t3, 4
	
	bne $t3, 12, drawFirstPixelRow		# Not done drawing the number for the first score
	
	j drawSecondScoreInit			# Done and now paint the second digit of the score
	
drawFirstPixelCol:
	beq $t5, 60, done			# If we're done for that row
	add $t6, $t3, $t5			# i + j
	add $t6, $t6, $a0			# Get offset of A[i + j]
	lw $t7, 0($t6)				# Get value from A[i + j]
	
	addi $t5, $t5, 12			# Increase the column skipping count
	addi $t4, $t4, 128			# Jump to next row of the screen
	beq $t7, 0, drawFirstPixelCol		# If the value was a 0, we DO NOT draw
	
	sw $a1, -128($t4)
	bne $t5, 60, drawFirstPixelCol		# Haven't painted the whole column
	
	jr $ra
	
drawSecondScoreInit:
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	lw $a1, scoreColour
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	# Break score into 2 pieces
	li $t1, 10
	div $s2, $t1
	mfhi $a0
	
	# Multiply by 15 for the number
	li $t1, 15
	mult $a0, $t1
	mflo $a0
	
	# Multiply by 4 as word-aligned
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	
	add $a0, $s4, $t1

drawSecondPixelRow:
	addi $t5, $zero, 0			# Counter for going through all 5 rows (i.e. j)
	add $t4, $gp, $t3			# Top row position
	addi $t4, $t4, 16 			# As second column
	jal drawSecondPixelCol
	addi $t3, $t3, 4
	
	bne $t3, 12, drawSecondPixelRow
	
	j doodleJumpInit
	
drawSecondPixelCol:
	beq $t5, 60, done			# If all rows for this column has been painted
	add $t6, $t3, $t5			# i + j
	add $t6, $t6, $a0			# Get offset of A[i + j]
	lw $t7, 0($t6)				# Get value from A[i + j]
	
	addi $t5, $t5, 12			# Increase the column skipping count
	addi $t4, $t4, 128			# Jump to next row of the screen
	beq $t7, 0, drawSecondPixelCol		# If the value was a 0, we DO NOT draw
	
	sw $a1, -128($t4)
	bne $t5, 60, drawSecondPixelCol		# Haven't painted the whole column
	
done:
	jr $ra
	
doodleJumpInit:
	li $t6, 0
	lw $t3, backgroundColour
	
doodleJumpUp:	
	addi $s7, $s7, -128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s7			# pixel of the row one up
	
	lw $t3, backgroundColour
	sw $t3, 124($t7)			# Colour previous doodle spot with background colour
	sw $t3, 132($t7)			# Colour previous doodle spot with background colour
	sw $t3, 0($t7)				# Colour previous doodle spot with background colour
	
	jal processMovement			# Colour in the new spot
	
	addi $t6, $t6, 1
	
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	jal keyboardCheck			# Check if any of the keys are pressed
	
	jal checkPlatformInit			# Check if the doodle has reached any of the platforms before jumping again	
	
	bne $t6, $s1, doodleJumpUp
	
doodleJumpDown:	
	addi $s7, $s7, 128			# Move doodle location exactly 1 row up
	add $t7, $gp, $s7			# pixel of the row one up
	
	lw $t3, backgroundColour
	sw $t3, -260($t7)			# Colour previous doodle spot with background colour
	sw $t3, -252($t7)			# Colour previous doodle spot with background colour
	sw $t3, -384($t7)			# Colour previous doodle spot with background colour
		
	jal processMovement			# Colour in the new spot
	
	addi $t6, $t6, -1
	
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
	
	jal keyboardCheck			# Check if any of the keys are pressed
	
	jal checkPlatformInit			# Check if the doodle landed on any of the platforms
	
	addi $t5, $s7, -4068
	bgez $t5, drawEndInit			# Fell off screen, paint goodbye
	
	bne $t6, 10, doodleJumpDown
	
keyboardCheck:
	lw $t5, 0xffff0000 
	beq $t5, 1, keyboardInput
	
	jr $ra					# No keyboard input so jump back to whatever we were doing before
	
keyboardInput:
	lw $t5, 0xffff0004 
	beq $t5, 0x6A, leftInput		# the "j" key
	beq $t5, 0x6B, rightInput		# the "k" key
	j initialKeyboardCheck			# The key entered wasn't valid, check for valid
	
leftInput:
	addi $s7, $s7, -8			# Move doodle location exactly 1 pixel left
	add $t7, $gp, $s7			# pixel of spot to the left
	lw $t2, backgroundColour		# $t2 stores the beige colour
	
	sw $t2, 12($t7)				# Colour previous doodle spot with background colour
	sw $t2, -120($t7)			# Colour previous doodle spot with background colour
	sw $t2, -116($t7)			# Colour previous doodle spot with background colour
	sw $t2, -248($t7)			# Colour previous doodle spot with background colour
	
	j processMovement			# Colour in the new spot
	
rightInput:
	addi $s7, $s7, 8			# Move doodle location exactly 1 pixel right
	add $t7, $gp, $s7			# pixel of spot to the right
	lw $t2, backgroundColour		# $t2 stores the beige colour
	
	sw $t2, -12($t7)			# Colour previous doodle spot with background colour
	sw $t2, -136($t7)			# Colour previous doodle spot with background colour
	sw $t2, -140($t7)			# Colour previous doodle spot with background colour
	sw $t2, -264($t7)			# Colour previous doodle spot with background colour
	
	j processMovement			# Colour in the new spot


processMovement:
	lw $t2, doodleColour
	lw $t1, oliveGreen
	
	# Draw the doodle
	add $t5, $gp, $s7
	add $t3, $zero, $s1
	
	sw $t2, 4($t5)
	sw $t2, -4($t5)
	sw $t1, -128($t5)
	sw $t1, -124($t5)
	sw $t1, -132($t5)
	sw $t2, -256($t5)
	
	jr $ra
	
### Check for jumping onto a platform ###
checkPlatformInit:
	addi $sp, $sp, -4			# Make space on the stack to store $ra to jump back later, otherwise we're lost
	sw $ra, 0($sp)				# Pointer back to either doodleJumpUp/doodleJumpDown
	li $t4, 0				# Offset for array
	
	jal retrievePlatform
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4			# Shrink the stack back
	jr $ra
	
retrievePlatform:
	add $t5, $s6, $t4			# Array Position
	lw $t8, 0($t5)				# Load platform coordinate from array
	add $s5, $zero, $t8
	lw $s0, 4($t5)
	#addi $s0, $t8, 24			# 6 pixels down from platform
	
	
checkDoodleOnPlatform:
	add $t9, $gp, $s7			# Address of doodle
	
	addi $t5, $t9, -4
	beq $t5, $t8, doodleLeftLeg		# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	addi $t5, $t9, 4	
	beq $t5, $t8, doodleRightLeg		# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	#addi $t5, $t9, -132
	#beq $t5, $t8, doodleOnPlatform		# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	#addi $t5, $t9, -128
	#beq $t5, $t8, doodleOnPlatform		# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	#addi $t5, $t9, -124
	#beq $t5, $t8, doodleOnPlatform		# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	addi $t5, $t9, -256			# "Head" of the doodle
	beq $t5, $t8, doodleTop			# Doodle is on the platform, $t5 is the PLATFORM that was "hit"
	
	addi $t8, $t8, 4
	
	bne $t8, $s0, checkDoodleOnPlatform	# Haven't finished checking all of the platform
	
	addi $t4, $t4, 8			# Move to next platform in list (a.k.a finishing checking one platform)
	bne $t4, 48, retrievePlatform		# Haven't finished checking all the platforms
	
	j doodleNotOnPlatform

doodleLeftLeg:
	addi $s7, $s7, -128			# Doodle reached a platform so place it directly above the platform
	
	lw $t0, platformColour
	sw $t0, 0($t5)
	
	lw $t0, backgroundColour
	sw $t0, -124($t5)
	
	# Check if the "right" leg hit a point that was out of platform
	addi $t3, $t9, 4
	sub $t4, $s0, $t3
	
	bgtz $t4, rightLegInRange
	
	sw $t0, 0($t3)
	j doodleOnPlatform
	
rightLegInRange:
	lw $t0, platformColour
	sw $t0, 0($t3)
	j doodleOnPlatform
	
doodleRightLeg:
	addi $s7, $s7, -128			# Doodle reached a platform so place it directly above the platform

	lw $t0, platformColour
	sw $t0, 0($t5)
	
	lw $t0, backgroundColour
	sw $t0, -132($t5)
	
	addi $t3, $t9, -4
	
	# Check if the "left" leg hit a point that was out of platform
	addi $t3, $t9, -4
	sub $t4, $t3, $s5
	
	bgez $t4, leftLegInRange
	
	sw $t0, 0($t3)
	j doodleOnPlatform

leftLegInRange:
	lw $t0, platformColour
	sw $0, 0($t3)
	j doodleOnPlatform

doodleTop:
	addi $s7, $s7, -384			# Doodle reached a platform so place it directly above the platform
	
	j doodleOnPlatform

doodleOnPlatform:
	
	#lw $t0, platformColour			# Load platform colour
	#sw $t0, 0($t5)				# Store platform colour where doodle hit platform
	#sw $t0, 8($t5)	
	
	#addi $s7, $s7, -128			# Doodle reached a platform so place it directly above the platform

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
	
	jal processMovement
	
	add $t9, $zero, $zero
	addi $s2, $s2, 1			# Increment the player's score by 1 (for hitting a new platform)
	
	j drawMessage				
		
doodleNotOnPlatform:
	jr $ra					# Continue back to point in the program


### Scroll the screen ###
shiftPlatforms:
	add $t6, $s6, $t9			# Array offset/position
	lw $a2, 8($t6)				# Get platform in that array position
	addi $a2, $a2, 384			# Shift platforms 3 rows downwards
	sw $a2, 0($t6)				# Store this new platform coordinate in the previous spot i.e. A[i] = A[i + 1]
	lw $a2, 12($t6)				# Get ENDPOINT
	addi $a2, $a2, 384			# Shift ENDPOINT
	sw $a2, 4($t6)
	addi $t9, $t9, 8
	bne $t9, 40, shiftPlatforms
	
	# Generate a random platform coordinate
	li $v0, 42
	li $a0, 0
	li $a1, 10
	syscall
	addi $a0, $a0, 10
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	#add $t9, $gp, $t6
	
	lw $t9, 32($s6)				# Previous last platform in the platforms array
	addi $t9, $t9, -512			# Shift that platform
	add $t6, $t6, $t9
		
	# Store the platform location
	sw $t6, 40($s6)				# Store this platform as last one in the array
	add $t6, $t6, $a3
	sw $t6, 44($s6)				# Sore ENDPOINT of the new platform
	li $s3, 1				# Means not restarting
	j backgroundInit			# Go repaint the whole entire screen
	
	
### Start Screen ###
drawEndInit:
	# Sleep to delay animation
	li $v0, 32		
	move $a0, $v1
	syscall
  
	li $t3, 0 				# Counter for filling in background
	lw $t0, displayAddress
	lw $t2, goldenRod			
	lw $t9, screenSize			# Screen size

drawEndBackground:
	sw $t2, 0($t0)				# Paint the pixel
	add $t0, $t0, 4				# Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, drawEndBackground
		
### Draw goodbye screen ###
drawGameOver:
	lw $a1, wordColour
	
	# Draw the word "game"
	la $a0, letterG
	li $a2, 160
	jal drawCharInit
	la $a0, letterA
	li $a2, 176
	jal drawCharInit
	la $a0, letterM
	li $a2, 192
	jal drawCharInit 
	la $a0, letterE
	li $a2, 208
	jal drawCharInit
	
	# Draw the word "over!"
	la $a0, letterO
	li $a2, 928
	jal drawCharInit
	la $a0, letterV
	li $a2, 944
	jal drawCharInit
	la $a0, letterE
	li $a2, 960
	jal drawCharInit 
	la $a0, letterR
	li $a2, 976
	jal drawCharInit
	la $a0, exclaimMark
	li $a2, 992
	jal drawCharInit
	
	
	lw $a1, darkBrown
	# Draw the word "Score:"
	la $a0, letterS
	li $a2, 1796
	jal drawCharInit
	la $a0, letterC
	li $a2, 1812
	jal drawCharInit
	la $a0, letterO
	li $a2, 1828
	jal drawCharInit
	la $a0, letterR
	li $a2, 1844
	jal drawCharInit
	la $a0, letterE
	li $a2, 1860
	jal drawCharInit
	la $a0, colonMark
	li $a2, 1872
	jal drawCharInit
	
	lw $a1, oliveGreen
	# Draw the word "S to"
	la $a0, letterS
	li $a2, 2564
	jal drawCharInit
	la $a0, letterT
	li $a2, 2580
	jal drawCharInit
	la $a0, letterO
	li $a2, 2596
	jal drawCharInit
	
	# Draw the word "restart"
	la $a0, letterR
	li $a2, 3332
	jal drawCharInit
	la $a0, letterE
	li $a2, 3348
	jal drawCharInit
	la $a0, letterS
	li $a2, 3364
	jal drawCharInit
	la $a0, letterT
	li $a2, 3380
	jal drawCharInit
	la $a0, letterA
	li $a2, 3396
	jal drawCharInit
	la $a0, letterR
	li $a2, 3412
	jal drawCharInit
	la $a0, letterT
	li $a2, 3428
	jal drawCharInit
	
	
### Draw score in top left corner ###
drawFirstEndScoreInit:
	lw $a1, scoreColour
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	# Break score into 2 pieces
	li $t1, 10
	div $s2, $t1
	mflo $a0
	
	# Multiply by 15 for the number
	li $t1, 15
	mult $a0, $t1
	mflo $a0
	
	# Multiply by 4 as word-aligned
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	
	add $a0, $s4, $t1
	
drawFirstEndScoreRow:
	addi $t5, $zero, 0			# Counter for going through all 5 rows (i.e. j)
	add $t4, $gp, $t3			# Top row position
	addi $t4, $t4, 1884			# As second column
	jal drawFirstEndScoreCol
	addi $t3, $t3, 4
	
	bne $t3, 12, drawFirstEndScoreRow		# Not done drawing the number for the first score
	
	j drawSecondScoreEndInit			# Done and now paint the second digit of the score
	
drawFirstEndScoreCol:
	beq $t5, 60, done			# If we're done for that row
	add $t6, $t3, $t5			# i + j
	add $t6, $t6, $a0			# Get offset of A[i + j]
	lw $t7, 0($t6)				# Get value from A[i + j]
	
	addi $t5, $t5, 12			# Increase the column skipping count
	addi $t4, $t4, 128			# Jump to next row of the screen
	beq $t7, 0, drawFirstEndScoreCol	# If the value was a 0, we DO NOT draw
	
	sw $a1, -128($t4)
	bne $t5, 60, drawFirstEndScoreCol	# Haven't painted the whole column
	
	jr $ra
	
drawSecondScoreEndInit:
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	lw $a1, scoreColour
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
	# Break score into 2 pieces
	li $t1, 10
	div $s2, $t1
	mfhi $a0
	
	# Multiply by 15 for the number
	li $t1, 15
	mult $a0, $t1
	mflo $a0
	
	# Multiply by 4 as word-aligned
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	
	add $a0, $s4, $t1

drawSecondEndScoreRow:
	addi $t5, $zero, 0			# Counter for going through all 5 rows (i.e. j)
	add $t4, $gp, $t3			# Top row position
	addi $t4, $t4, 1900			# As second column
	jal drawSecondEndScoreCol
	addi $t3, $t3, 4
	
	bne $t3, 12, drawSecondEndScoreRow
	
	j checkRestartInit
	
drawSecondEndScoreCol:
	beq $t5, 60, done			# If all rows for this column has been painted
	add $t6, $t3, $t5			# i + j
	add $t6, $t6, $a0			# Get offset of A[i + j]
	lw $t7, 0($t6)				# Get value from A[i + j]
	
	addi $t5, $t5, 12			# Increase the column skipping count
	addi $t4, $t4, 128			# Jump to next row of the screen
	beq $t7, 0, drawSecondEndScoreCol		# If the value was a 0, we DO NOT draw
	
	sw $a1, -128($t4)
	bne $t5, 60, drawSecondEndScoreCol		# Haven't painted the whole column
	
	jr $ra
	
checkRestartInit:
	lw $t5, 0xffff0000 			# Check for keyboard input
	beq $t5, 1, checkRestart
	
checkRestart:
	lw $t5, 0xffff0004 
	bne $t5, 0x73, checkRestartInit		# the "s" key
	li $s3, 1
	j platformInit
	
### Draw On-Screen Notifications ###
drawMessage:
	add $t9, $zero, $zero
	beq $s2, 0, shiftPlatforms 		# 0 does not count as wow! or great!
	
	# Check if the current score is a multiple of 5
	li $t5, 10
	div $s2, $t5
	mfhi $t0
	
	lw $a1, wordColour
	
	beq $t0, 0, drawGreat			# We have a multiple of 10
	
	# Check if the current score is a multiple of 5
	li $t5, 5
	div $s2, $t5
	mfhi $t0
	
	beq $t0, 0, drawWow 			# We have a multiple of 5
	
	add $t9, $zero, $zero
	j shiftPlatforms			# None of the above, so we just shift platforms
	

drawWow:
	la $a0, letterW
	li $a2, 36
	jal drawCharInit
	la $a0, letterO
	li $a2, 52
	jal drawCharInit
	la $a0, letterW
	li $a2, 68
	jal drawCharInit 
	la $a0, exclaimMark
	li $a2, 84
	jal drawCharInit
	
	# Sleep to delay animation
	li $v0, 32		
	li $a0, 300
	syscall
	
	beq $a3, 8, noDecrease			# Want platforms to be at least 2 pixels wide				
	addi $a3, $a3, -4			# Decrease the platform length
	beq $v1, 60, noDecrease			# Need at least 60 rates for sleep
	addi $v1, $v1, -10			# Decrease sleep delay to make game seem faster
	
	add $t9, $zero, $zero
	j shiftPlatforms			# Jump back to shifting platform

noDecrease:
	add $t9, $zero, $zero
	j shiftPlatforms
	
drawGreat:
	la $a0, letterG
	li $a2, 36
	jal drawCharInit
	la $a0, letterR
	li $a2, 52
	jal drawCharInit
	la $a0, letterE
	li $a2, 68
	jal drawCharInit 
	la $a0, letterA
	li $a2, 84
	jal drawCharInit
	la $a0, letterT
	li $a2, 100
	jal drawCharInit
	la $a0, exclaimMark
	li $a2, 112
	jal drawCharInit
	
	# Sleep to delay animation
	li $v0, 32		
	li $a0, 300
	syscall
	
	beq $s1, 2, noDecrease			# Don't want to allow - amount of jumping
	addi $s1, $s1, -4			# Decrease the bounce allowed by the doodle
	
	add $t9, $zero, $zero
	j shiftPlatforms			# Jump back to shifting platform
	
		
### Draw a character in general ###		
drawCharInit:
	addi $sp, $sp, -4			# Increase stack size
	sw $ra, 0($sp)				# Store the return address

	#lw $a1, wordColour
	addi $t3, $zero, 0			# Counter for going through all 3 columns (i.e. i)
	
drawCharRow:
	addi $t5, $zero, 0			# Counter for going through all 5 rows (i.e. j)
	add $t4, $gp, $a2			# Position to draw the character at
	add $t4, $t4, $t3			# Top row position
	jal drawCharCol
	addi $t3, $t3, 4
	
	bne $t3, 12, drawCharRow		# Not done drawing the character
	
	lw $ra, 0($sp)				# Grab return address from the stack
	addi $sp, $sp, 4			# Shrink back the stack
	jr $ra
	
drawCharCol:
	beq $t5, 60, done			# If we're done for that row
	add $t6, $t3, $t5			# i + j
	add $t6, $t6, $a0			# Get offset of A[i + j]
	lw $t7, 0($t6)				# Get value from A[i + j]
	
	addi $t5, $t5, 12			# Increase the column skipping count
	addi $t4, $t4, 128			# Jump to next row of the screen
	beq $t7, 0, drawCharCol			# If the value was a 0, we DO NOT draw
	
	sw $a1, -128($t4)
	bne $t5, 60, drawCharCol		# Haven't painted the whole column
	
	jr $ra
	
drawBouncingDoodle:
	add $t4, $gp, $s1

	sw $t2, 4($t4)
	sw $t2, -4($t4)
	sw $t1, -128($t4)
	sw $t1, -124($t4)
	sw $t1, -132($t4)
	sw $t2, -256($t4)
	
	jr $ra		
	
Exit:
	li $v0, 10 				# terminate the program gracefully
	syscall
