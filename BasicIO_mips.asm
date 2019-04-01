.data
	Strings: .asciiz " Alpha\n"," Bravo\n"," China\n"," Delta\n"," Echo\n"," Foxtrot\n"," Golf\n"," Hotel\n",
    			   " India\n"," Juliet\n"," Kilo\n"," Lima\n"," Mary\n"," November\n"," Oscar\n"," Paper\n"," Quebec\n",
	               " Research\n"," Sierra\n"," Tango\n"," Uniform\n"," Victor\n"," Whisky\n"," X-ray\n"," Yankee\n"," Zulu\n"
	strings: .asciiz " alpha\n"," bravo\n"," china\n"," delta\n"," echo\n"," foxtrot\n"," golf\n"," hotel\n"," india\n",
    			   " juliet\n"," kilo\n"," lima\n"," mary\n"," november\n"," oscar\n"," paper\n"," quebec\n"," research\n",
			       " sierra\n"," tango\n"," uniform\n"," victor\n"," whisky\n"," x-ray\n"," yankee\n"," zulu\n"
	offsets_strings: .word 0,8,16,24,32,39,49,56,64,72,81,88,95,102,113,121,129,138,149,158,166,176,185,194,202,211
	
	numbers: .asciiz " Zero\n"," First\n"," Second\n"," Third\n"," Fourth\n"," Fifth\n"," Sixth\n"," Seventh\n"," Eighth\n"," Ninth\n"
	offsets_numbers: .word 0,7,15,24,32,41,49,57,67,76
	
	star: .asciiz " *\n"

.text
.globl main
main:
	# read character
	li $v0 12 
	syscall
	# exit
	beq $v0, '?', exit
	# else
	slti $t1, $v0, 48 # 48 = 0, t1 is used for slt
	bne $t1, $zero, print_star
	# number
	slti $t1, $v0, 58 # 57 = 9
	bne $t1, $zero, print_number
	# else
	slti $t1, $v0, 65 # 65 = A
	bne $t1, $zero, print_star	
	# Strings
	slti $t1, $v0, 91 # 90 = Z
	bne $t1, $zero, print_Strings
	# else
	slti $t1, $v0, 97 # 97 = a
	bne $t1, $zero, print_star	
	# strings
	slti $t1, $v0, 123 # 122 = z
	bne $t1, $zero, print_strings
	# else
	j print_star

exit:
	li $v0, 10
	syscall

print_star:
	la $a0, star
	li $v0, 4
	syscall
	j main
	
print_number:
	subi $t3, $v0, 48 # 48 = 0, t3 is offset from 0
	sll $t3, $t3, 2   # *4, int is 4 bytes
	la $a1, offsets_numbers 
	add $a1, $a1, $t3 # t3 is offset in numbers
	la $a0, numbers
	lw $t3, ($a1) # not move!
	add $a0, $a0, $t3
	li $v0, 4
	syscall
	j main
	
print_Strings:
	subi $t3, $v0, 65 
	sll $t3, $t3, 2 
	la $a1, offsets_strings
	add $a1, $a1, $t3 
	la $a0, Strings
	lw $t3, ($a1)
	add $a0, $a0, $t3
	li $v0, 4
	syscall
	j main

print_strings:
	subi $t3, $v0, 97
	sll $t3, $t3, 2 
	la $a1, offsets_strings
	add $a1, $a1, $t3 
	la $a0, strings
	lw $t3, ($a1)
	add $a0, $a0, $t3
	li $v0, 4
	syscall
	j main