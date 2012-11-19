.data
array: .word 60, 20, 80, 40, 120
n: .word 5
bar: .asciiz "-"

.text
.globl main
main:
	jal maxNumber
	move $a0, $v0
	li $v0, 1
	syscall						#print the value of $a0
	
	la $a0, bar
	li $v0, 4
	syscall						#printing a bar
	
	move $a0, $v1
	li $v0, 1
	syscall						#print the value of $a0
	
	li $v0, 10
	syscall						#exit
	
maxNumber:
	
	lw $t0 n					#$t0=n
	
	ble $t0, 0, zero			#if(n==0) then jump to zero
	
	li $s1, 1 					#initialiting counter
	li $s0, 0					#initializing position
	la $t1 array   				#storing the address of array in $t1
	lw $s2 ($t1)				#first value of the array
	
		for:			
			beq $s1, $t0 end
		
			mul $t2, $s1, 4		#4*counter
			add $t3, $t1, $t2	#$t2=displacement 4*counter from the array address 
		
			lw $t4 ($t3)		#$t4=content in the address $t3 
		
			sgt $t5, $t4, $s2 	#if($t4>$s2)      
			
			beq $t5, 1 store
			addi $s1, $s1, 1
			b for
	
	end:
		move $v0 $s2			#$v0=greater
		move $v1 $s0 			#$v1=counter
		jr $ra


	store:
		move $s2 $t4 			#Storing the greatest of both
		move $s0 $s1 			#Storing the position
		addi $s1, $s1, 1 		#counter + 1  
		b for
		
	zero:
		move $v0 $0 #$v0=0
		move $v1 $0 #$v1=0
		jr $ra
		