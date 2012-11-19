.data
stringToLower: .asciiz "THIS IS A TEST"

.text
.globl main
main:
	jal  toLower						#calling the function
	move $a0, $v0
	li $v0 4	
	syscall								#printing the string strating in the address $a0
	li $v0 10
	syscall								#exit
	
toLower:
	li $s0 0 							#initialiting counter
	la $s1 stringToLower				#storing the address of the first char of the string in $s1

	for:	
		add $t0, $s1, $s0 
		lb $t1 ($t0)					#$so=character of the string
		
		beq $t1 $0 end					#if character is null jump to end
		
			addi $s0, $s0, 1				#counter+1
		
			sge $t2, $t1, 65				#if($t1>=65)
			sle $t3, $t1, 90				#if($t1<=90)
			and $t4, $t2, $t3				#if(65<=$t1<=90)
		
			beq $t4, 1 change				#if(65<=$t1<=90)==true jump to change
		
			b for

	end:
		move $v0 $s1					#$v0=$s1
		jr $ra
		
	change:
				addi $t5, $t1, 32       #homologue lowercase char of the uppercase 
				sb $t5 ($t0)			#store the lowercase in the uppercase position
				b for
		
		
	