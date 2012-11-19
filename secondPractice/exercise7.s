.data
	toPrint: .asciiz "It is known that %i percent of the work requires %i percent of the time."
	numbers: .word	20, 80
	
.text
	.globl main
main:
	jal subMain						#We first go to the method
	li $v0, 10						#And we exit the program
	syscall
	
subMain:
	la $s0, toPrint					#First of all, we load the string
	la $s1, numbers					#And the numbers to substitute
	add $t0, $s0, $s5
	lb $t1, ($t0)					#Then, we load the first character of the string
	
forCheck:
	beq $t1, 37, found				#Here we check if the character is equal to '%'
	beqz $t1, end					#And here we check if we are at the end of the string
	move $a0, $t1					#If the previous conditions are not fullfiled
	li $v0, 11						#Then we print the character and we go to the next one
	syscall							#In order to search the full string
	addi $s5, $s5, 1
	add $t0, $s0, $s5
	lb $t1, ($t0)
	b forCheck
	
found:
	move $t2, $s5					#When a '%' is reached, we have to check if the next char
	addi $t2, $t2, 1				#Is an 'i'. If it is, then the number is substituted while
	add $t0, $s0, $t2				#"%i" is not printed.
	lb $t1, ($t0)
	beq $t1, 105, replacement		#If "%i" is not found, then it continues printing the string
	add $t0, $s0, $s5
	lb $t1, ($t0)
	move $a0, $t1					
	li $v0, 11						
	syscall	
	b forCheck						#And come back to the search
	
replacement:
	lw $a0, numbers($s7)			#Here we load the number according to the times that "%i" have appeared
	li $v0, 1						#And then we print them and continue searching for more "%i"
	syscall
	addi $s7, $s7, 4
	addi $s5, $s5, 2
	add $t0, $s0, $s5
	lb $t1, ($t0)
	b forCheck
	
end:
	jr $ra							#The program goes to the main and exits.
	
	