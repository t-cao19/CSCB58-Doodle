# Bitmap Display Configuration:
# - Unit width in pixels: 16					     
# - Unit height in pixels: 16
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	screenWidth: 	.word 32
	screenHeight: 	.word 32
	platformWidth: .word  8
	screenSize: .word 1024
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xdeb887	# $t1 stores the brown
	li $t2, 0xf5f5dc	# $t2 stores the beige colour
	lw $t8, platformWidth
	lw $t9, screenSize
	
	
# Fill screen with background colour
		
loopinit: 
	li $t3, 0 # Counter

backgroundloop:
	sw $t2, 0($t0)
	add $t0, $t0, 4 # Move along the screen
	addi $t3, $t3, 1
	bne $t3, $t9, backgroundloop

# Attempt to draw 3 platforms onto the background
		
init:
	lw $t0, displayAddress
	addi $t3, $t0, 1496
	addi $t4, $t0, 1968
	addi $t5, $t0, 2304
	li $t6, 0
	
platformloop:
	sw $t1, 0($t3)
	sw $t1, 0($t4)
	sw $t1, 0($t5)
	addi $t3, $t3, 4
	addi $t4, $t4, 4
	addi $t5, $t5, 4
	addi $t6, $t6, 1
	bne $t6, $t8, platformloop
	

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
