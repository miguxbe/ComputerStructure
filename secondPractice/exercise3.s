.data
stringToLength: .asciiz "This is a test"

.text
.globl main
main:
	jal  strlen							#calling the function
	move $a0 $v0
	li $v0 1							
	syscall								#printing the value in $a0
	li $v0 10
	syscall								#exit

strlen: 
	li $s0 0 							#initialiting counter
	la $s1 stringToLength				#storing the address of the first char of the string in $s1

	for:	
		add $t0, $s1, $s0 
		lb $t1 ($t0)					#$so=character of the string
		
		beq $t1, $0 end					#if character is null jump to end
		addi $s0, $s0, 1				#counter+1
		b for

	end:
		move $v0 $s0					#$v0=$s0
		jr $ra
		