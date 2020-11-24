# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	screenWidth: 	.word 64
	screenHeight: 	.word 64
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xdeb887	# $t1 stores the brown
	li $t2, 0xf5f5dc	# $t3 stores the beige colour
	
	
# Fill screen with background colour
		
loopinit: 
	li $t4, 0 # Counter
	li $t5, 1024

loop:
	sw $t2, 0($t0)
	add $t0, $t0, 4 # Move along the screen
	addi $t4, $t4, 1
	bne $t4, $t5, loop
	# Try to paint the whole screen green
	
platform:
	lw $t0, displayAddress
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	sw $t1, 60($t0)
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	
	sw $t1, 304($t0)
	sw $t1, 308($t0)
	sw $t1, 312($t0)
	sw $t1, 316($t0)
	sw $t1, 320($t0)
	sw $t1, 324($t0)
	sw $t1, 328($t0)
	sw $t1, 332($t0)
	sw $t1, 336($t0)

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
