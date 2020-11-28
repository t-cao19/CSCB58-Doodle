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
	displayAddress:	.word	0x10008000
	screenWidth: 	.word 32
	screenHeight: 	.word 32
	platformWidth: .word  6
	screenSize: .word 1024
	platforms: .space 24
	
.text
main:
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xdeb887	# $t1 stores the brown
	li $t2, 0xf5f5dc	# $t2 stores the beige colour
	la $t8, platforms 	# Array with 6 int spots for platform locations
	lw $t9, screenSize	# Screen size
	
	
# Fill screen with background colour
backgroundinit: 
	li $t3, 0 # Counter

backgroundloop:
	sw $t2, 0($t0)
	add $t0, $t0, 4 # Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, backgroundloop

platformInit:
	lw $t0, displayAddress
	addi $t3, $t3, 0 	# Counter/Offset for the array
	addu $t4, $t4, $zero	# Counter for number of platforms to generate

		
generatePlatform:
	add $t5, $t8, $t3 	# Current array location

	# Generate a random platform coordinate
	li $v0, 42
	li $a0, 0
	li $a1, 1024
	syscall
	
	# Multiply the platform by 4
	li $t6, 4
	mult $a0, $t6
	mflo $t6
	add $t7, $t0, $t6
	
	# Store the platform location
	sw $t7, 0($t5)
	addi $t3, $t3, 4
	# bne $t4, 24, randomplatform
	
	li $t6, 0 		# Counter for pixel width
	lw $a0, platformWidth
	
drawPlatform:
	sw $t1, 0($t7)
	addi $t7, $t7, 4
	addi $t6, $t6, 1
	bne $t6, $a0, drawPlatform
	
	addi $t4, $t4, 1
	bne $t4, 6, generatePlatform
	
# Attempt to draw the doodle

doodledraw:
	li $t3, 0x556b2f	# $t3 stores colour of doodle
	#addi $t4, $t0, 4028
	sw $t3, 3776($t0)
	sw $t3, 3900($t0)
	sw $t3, 3904($t0)
	sw $t3, 3908($t0)
	sw $t3, 4028($t0)
	sw $t3, 4036($t0)

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
