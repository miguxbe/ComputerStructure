.data
baseString: .asciiz "All work and no play makes Jimmy a dull boy"
searchString: .asciiz " play makes Jimmy "
.text
.globl main
main: 
		jal isInside
		move $a0, $v0
		li $v0, 1
		syscall							#print the integer in $a0
		li $v0, 10
		syscall							#exit

isInside:
		la $s0, baseString
		la $s1, searchString
		
		li $s2, 0						#counter of baseString
		li $s3, 0						#counter of searchString
		
		add $t2, $s1, $s3				#we load the first character of the searchString
		lb $t3 ($t2)
		
check:	
		add $t0, $s0, $s2				#we load the character of the baseString
		lb $t1 ($t0)					#in order to compare to the first character of searchString
		
		beq $t1, $0 end
		beq $t1, $t3 for				#if the first character of searchString is equal to the character of baseString
										#then goto for
										
		addi $s2, $s2, 1				#else add 1 to $s2 and continue searching
		b check
		
for:	
		seq $s4, $t1, $t3

		addi $s3, $s3, 1				#now we check if every character is equal
		add $t2, $s1, $s3				
		lb $t3 ($t2)
		
		addi $s2, $s2, 1
		add $t0, $s0, $s2
		lb $t1 ($t0)
		
		beq $t3, $0 end
		beq $t3, $t1 for
		li $s4, 0
		b check
		
end:	
		beq $s4, $0, false
		li $v0, 1
		b jump

false:
		li $v0, -1

jump:
		jr $ra