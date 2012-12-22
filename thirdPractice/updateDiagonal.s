#### .data ####
.data
	array:		.word 1, 1, 1, 1
				.word 1, 1, 1, 1
				.word 1, 1, 1, 1 
				.word 1, 1, 1, 1
	x:			.word 4
	y:			.word 4
	msg_error:	.asciiz "An error has occurred, please check the inputs"
	enter: .asciiz "\n"
	space: .asciiz " "
	
.text
.globl main

#### MAIN STARTS ####

main:
	
	la $a0, array   	#Arguments for function print and update_diagonal
	lw $a1, x			#Arguments for function print and update_diagonal
	lw $a2, y			#Arguments for function print and update_diagonal
	
	sub $sp, $sp, 4
	sw $ra, ($sp)		#saving the $ra in the stack
	
	jal print
	
	move $t0, $a0 		#temporaty saving the value of $a0
	
	la $a0, enter
	li $v0, 4
	syscall 			#Printing a blank line
	
	move $a0, $t0		#returning the value of $a0
	
	jal update_diagonal
	
	jal print		
	
	lw $ra, ($sp)		#returning the inital value of $ra
	addi $sp, $sp, 4
	
	jr $ra
	

#### MAIN FINISHES ####

#### GET STARTS ####


get: 
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	jal check_mistakes_get
	
	mul $t0, $s0, $a1 		#y_pos * x
	add $t0, $t0, $a3		#(y_pos*x) + x_pos
	mul $t0, $t0, 4 		#transforming the words calculated into bytes

	add $t1, $a0, $t0
	lw $v0, ($t1)	 		#Getting the word in the given position 

	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra

#### GET FINISHES ####

#### NEIGHBORS STARTS ####

neighbors:
	
	sub, $sp, $sp, 32
	sw $ra, ($sp)
	sw $s1, 4($sp)				
	sw $s2, 8($sp)				
	sw $s3, 12($sp)			
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)		
	
	li $s7, 0
	
	sub $s1, $a3, 1				#x_pos-1
	sub $s2, $s0, 1				#y_pos-1
	addi $s3, $a3, 1			#x_pos+1
	addi $s4, $s0, 1			#y_pos+1
	
	sge $s5,$s1, 0				#if(x_pos - 1 >= 0)
	
	bne $s5, 1, jump1			
	
	sub, $sp, $sp, 4
	sw $a3, ($sp)				#temporaty saving the value of $a3
	
	move $a3, $s1				#modifiting $a3 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem 
	
	lw $a3, ($sp)				#returning the value of $a3
	addi, $sp, $sp, 4
	
jump1:
	sge $s6,$s2, 0				#if(y_pos - 1 >= 0)
	
	bne $s6, 1, jump2			
	
	sub, $sp, $sp, 4
	sw $s0, ($sp)				#temporaty saving the value of $s0
	
	move $s0, $s2				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem
	
	lw $s0, ($sp)				#returning the value of $s0
	addi, $sp, $sp, 4
	
jump2:
	and $t0, $s5, $s6			#if(x_pos - 1 >= 0 && y_pos - 1 >= 0)
	
	bne $t0, 1, jump3			
	
	sub, $sp, $sp, 8
	sw $a3, ($sp)				#temporaty saving the value of $a3
	sw $s0, 4($sp)				#temporaty saving the value of $s0
	
	move $a3, $s1				#modifiting $a3 by the new argument
	move $s0, $s2				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem
	
	lw $a3, ($sp)				#returning the value of $a3
	lw $s0, 4($sp)				#returning the value of $s0
	addi, $sp, $sp, 8

jump3:
	slt $s5,$s3, $a1			#if(x_pos + 1 < x)
	
	bne $s5, 1, jump4			
	
	sub, $sp, $sp, 4
	sw $a3, ($sp)				#temporaty saving the value of $a3
	
	move $a3, $s3				#modifiting $a3 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem 
	
	lw $a3, ($sp)				#returning the value of $a3
	addi, $sp, $sp, 4
	
jump4:
	slt $s6,$s4, $a2			#if(y_pos + 1 < y)
	
	bne $s6, 1, jump5			
	
	sub, $sp, $sp, 4
	sw $s0, ($sp)				#temporaty saving the value of $s0
	
	move $s0, $s4				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem
	
	lw $s0, ($sp)				#returning the value of $s0
	addi, $sp, $sp, 4
	
jump5:
	and $t0, $s5, $s6			#if(x_pos + 1 < x && y_pos + 1 <y)
	
	bne $t0, 1, jump6		
	
	sub, $sp, $sp, 8
	sw $a3, ($sp)				#temporaty saving the value of $a3
	sw $s0, 4($sp)				#temporaty saving the value of $s0

	move $a3, $s3				#modifiting $a3 by the new argument
	move $s0, $s4				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem
	
	lw $a3, ($sp)				#returning the value of $a3
	lw $s0, 4($sp)				#returning the value of $s0
	addi, $sp, $sp, 8
	
jump6:
	sge $t0, $s1, 0				#if(x_pos - 1 >= 0)
	slt $t1, $s4, $a2			#if(y_pos + 1 < y)
	and $t2, $t0, $t1			#if(x_pos - 1 >= 0 && y_pos + 1 < y)
	
	bne $t2, 1, jump7	
	
	sub, $sp, $sp, 8
	sw $a3, ($sp)				#temporaty saving the value of $a3
	sw $s0, 4($sp)				#temporaty saving the value of $s0
	
	move $a3, $s1				#modifiting $a3 by the new argument
	move $s0, $s4				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem

	lw $a3, ($sp)				#returning the value of $a3
	lw $s0, 4($sp)				#returning the value of $s0
	addi, $sp, $sp, 8
	
jump7:
	slt $t0,$s3, $a1			#if(x_pos + 1 < x)
	sge $t1,$s2, 0				#if(y_pos - 1 >= 0)
	and $t2, $t0, $t1			#if(x_pos + 1 < x && y_pos - 1 >= 0)
	
	bne $t2, 1, jump8	
	
	sub, $sp, $sp, 8
	sw $a3, ($sp)				#temporaty saving the value of $a3
	sw $s0, 4($sp)				#temporaty saving the value of $s0
	
	move $a3, $s3				#modifiting $a3 by the new argument
	move $s0, $s2				#modifiting $s0 by the new argument 
	
	jal get
	add $s7, $s7, $v0			#sum=sum+elem

	lw $a3, ($sp)				#returning the value of $a3
	lw $s0, 4($sp)				#returning the value of $s0
	addi, $sp, $sp, 8
	
jump8:
	move $v0, $s7				#return sum 
	
	lw $ra, ($sp)
	lw $s1, 4($sp)				
	lw $s2, 8($sp)				
	lw $s3, 12($sp)			
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi, $sp, $sp, 32
		
	jr $ra

#### NEIGHBORS FINISHES ####

#### SET STARTS ####

set:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	jal check_mistakes_set
	
	mul $t0, $s1, $a2 		#y_pos * x
	add $t0, $t0, $s0		#(y_pos*x) + x_pos
	mul $t0, $t0, 4 		#transforming the words calculated into bytes

	add $t1, $a0, $t0
	sw $a1, ($t1)	 		#Setting the word in the given position 

	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra

#### SET FINISHES ####

#### PRINT STARTS ####

print:
	sub $sp, $sp, 12
	sw $ra, ($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	
	li $s1, 0	#counter for rows
	
for_outer:	bge $s1, $a1 end_print
			move $s0, $s1		#argument for function get
			li $s2, 0	#counter for columns
			
	for_inner:	bge $s2, $a2 next_line
				
				move $a3, $s2		#argument for function get
				jal get
				move $s3, $a0		#temporaty saving the value of $a0
				move $a0, $v0		#$a0=array[x_pos][y_pos]
				
				li $v0, 1
				syscall				#printing the elemnt
				
				la $a0, space
				li $v0, 4
				syscall				#printing an space
				
				move $a0, $s3		#returning the value of $a0
				addi $s2, $s2, 1	#columns+1
				b for_inner
next_line: 
			move $s3, $a0		#temporaty saving the value of $a0
			
			la $a0, enter
			li $v0, 4
			syscall				#printing in a new line
			
			move $a0, $s3		#returning the value of $a0
			
			addi $s1, $s1, 1
			b for_outer
			
end_print:	
	
	lw $ra, ($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	addi $sp, $sp, 12
	
	jr $ra

#### PRINT FINISHES ####

#### UPDATE DIAGONAL STARTS ####

update_diagonal:
	
	sub $sp, $sp, 12
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	li $s2, 0	#x_pos
	li $s3, 0	#y_pos
	
loop:
	sge $t0, $s2, $a2	#if(x_pos>=x)
	sge $t1, $s3, $a3	#if(y_pos>=y)
	and $t1, $t0, $t1	#if(x_pos>=x & y_pos>=y)
	
	beq $t1, 1, end_update
	move $a3, $s2	#Argument for function neighbors
	move $s0, $s3	#Argument for function neighbors
	jal neighbors	
	
	move $a3, $a2	#Argument for function set
	move $a2, $a1	#Argument for function set
	move $a1, $v0	#Argument for function set	
	move $s0, $s2	#Argument for function set
	move $s1, $s3	#Argument for function set
	jal set
	
	addi $s2, $s2, 1	#x_pos+1
	addi $s3, $s3, 1	#y_pos+1
	
	move $a1, $a2	#returning initial argument for function neighbors
	move $a2, $a3	#returning initial argument for function neighbors
	
	b loop
	
end_update:

	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

#### UPDATE DIAGONAL FINISHES ####

check_mistakes_get:

	slt $t0 $a3, 0		#x_pos<0
	slt $t1 $s0, 0		#y_pos<0
	
	or $t0, $t0, $t1	#if(x_pos<0 | y_pos<0)
		
	slt $t2 $a3, 0		#x<0
	slt $t3 $s0, 0		#y<0
	
	or $t2, $t2, $t3	#if(x<0 | y<0)
	
	sge $t4 $a3, $a1	#x_pos=>x
	sge $t5 $s0, $a2	#y_pos=>y
	
	or $t3, $t4, $t5	#if(x_pos=>x | y_pos=>y)
	
	or $t0, $t0, $t2	#if(x_pos<0 | y_pos<0 | x<0 | y<0)
	or $t0, $t0, $t3	#if(x_pos<0 | y_pos<0 | x<0 | y<0 | x_pos=>x | y_pos=>y)
	
	bne $t0, 0, mistake

	jr $ra

check_mistakes_set:

	slt $t0 $s0, 0		#x_pos<0
	slt $t1 $s1, 0		#y_pos<0
	
	or $t0, $t0, $t1	#if(x_pos<0 | y_pos<0)
		
	slt $t2 $a2, 0		#x<0
	slt $t3 $a3, 0		#y<0
	
	or $t2, $t2, $t3	#if(x<0 | y<0)
	
	sge $t4 $s0, $a2	#x_pos=>x
	sge $t5 $s1, $a3	#y_pos=>y
	
	or $t3, $t4, $t5	#if(x_pos=>x | y_pos=>y)
	
	or $t0, $t0, $t2	#if(x_pos<0 | y_pos<0 | x<0 | y<0)
	or $t0, $t0, $t3	#if(x_pos<0 | y_pos<0 | x<0 | y<0 | x_pos=>x | y_pos=>y)
	
	bne $t0, 0, mistake

	jr $ra
	
mistake:

	la $a0, msg_error 
	li $v0, 4
	syscall					#print an error msg

	li $v0, 10
	syscall					#exit the program
		