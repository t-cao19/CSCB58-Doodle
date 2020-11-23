# Demo for painting
#
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
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	li $t3, 0x0000ff	# $t3 stores the blue colour code
	
	#sw $t1, 0($t0)	 # paint the first (top-left) unit red. 
	#sw $t2, 4($t0)	 # paint the second unit on the first row green. Why $t0+4? As 4 bits for an int
	#sw $t2, 64($t0)
	#sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128? As # row byte = 256 * 2
	
loopinit: 
	li $t4, 0 # Counter
	li $t5, 1024

loop:
	sw $t2, 0($t0)
	add $t0, $t0, 4 # Move along the screen
	addi $t4, $t4, 1
	bne $t4, $t5, loop
	# Try to paint the whole screen green
	

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
