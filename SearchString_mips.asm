.data
	# use buffer to save the string
	buffer: .space 100
	success_string: .asciiz " Success! Location: "
	fail_string: .asciiz " Fail!"
	newline: .asciiz "\n"
	
.text
main:
	# read string
	la $a0, buffer
	li $a1, 100
	li $v0, 8
	syscall # a0 is string, a1 is length
	# save
	move $s0, $a0
	move $s1, $a1
	
read:
	# read character
	li $v0, 12
	syscall # v0 is character	
	# exit
	beq $v0, '?', exit
	# loop variable
	li $t0, 0
	
loop:
	# calculate address
	beq $t0, $s1, fail
	add $t2, $s0, $t0
	lb $t1, ($t2)
	# test equality
	beq $v0, $t1, success
	# not equal
	addi $t0, $t0, 1
	j loop
	
success:
	li $v0, 4
	la $a0, success_string
	syscall
	li $v0, 1
	addi $a0, $t0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j read
	
fail:
	li $v0, 4
	la $a0, fail_string
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j read
	
exit:
	li $v0, 10
	syscall