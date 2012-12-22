#### .data   ####
.data
	array:		.word 0, 0, 0, 0, 0
				.word 0, 0, 0, 0, 0
				.word 0, 0, 1, 1, 1
				.word 0, 0, 1, 0, 0
				.word 0, 0, 0, 1, 0
	x:			.word 5
	y:			.word 5
	msg_error:	.asciiz "An error has occurred, please check the inputs"
	enter: .asciiz "\n"
	space: .asciiz " "
	
.text
.globl main

#### MAIN STARTS ####

main:
	
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	la $a0, array
	lw $a1, x
	lw $a2, y
	li $a3, 10
	
	jal game_of_life
	
	jal print
	
	lw $ra, ($sp)
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

#### FINISHES STARTS ####

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

#### MALLOC STARTS####

malloc:
	
	mul $t0, $a0, $a1 #rows*columns=words
	move $t1, $a0 	  #temporary saving the value of $a0
	mul $a0, $t0, 4	  #words to bytes

	li $v0, 9
	syscall
	
	move $a0, $t1     #returning the value of $a0
	jr $ra

#### MALLOC FINISHES ####

#### COPY ARRAY STARTS ####

copy_array:
			sub $sp, $sp, 4
			sw $s0, ($sp)
			sub $sp, $sp, 4
			sw $s1, ($sp)
			sub $sp, $sp, 4
			sw $s2, ($sp)

			mul $t0, $a2, $a3 #rows*columns=words
			mul $t0, $t0, 4	  #words to bytes
			
			add $s0, $a0, $t0		#src_array + positions
			la $s1, ($a0)			#initial address src_array
			la $s2, ($a1)			#initial address dest_array
			
copy_loop:	beq $s0, $s1 end_copy
			
			lw $t0, ($s1)		#Getting the element from src_array
			sw $t0, ($s2)		#Saving the element in dest_array
			
			addi $s1, $s1, 4	#src_address + 4
			addi $s2, $s2, 4	#dest_address + 4
			
			b copy_loop
	
end_copy:
			addi $sp, $sp, 4
			lw $s2, ($sp)
			addi $sp, $sp, 4
			lw $s1, ($sp)
			addi $sp, $sp, 4
			lw $s0, ($sp)
			jr $ra

#### COPY ARRAY FINISHES ####

#### CLEAN ARRAY STARTS ####

clean_array:
			sub $sp, $sp, 28
			sw $ra, ($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s3, 16($sp)
			sw $a1, 20($sp)
			sw $a2, 24($sp)
			
			move $a2, $a1		#Argument for function set
			move $a3, $a2		#Argument for function set
			li $a1, 0        	#Argument for function set
			
for_outer_clean:	bge $s2, $a3 end_clean
					move $s1, $s2		#Argument for function set
					li $s3, 0			#counter for columns
			
	for_inner_clean:	bge $s3, $a2 next_line_clean
				
						move $s0, $s3		#argument for function set
						jal set
						
						addi $s3, $s3, 1	#columns+1
						b for_inner_clean
next_line_clean: 
			addi $s2, $s2, 1
			b for_outer_clean
	
end_clean:
			lw $ra, ($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $a1, 20($sp)
			lw $a2, 24($sp)
			addi $sp, $sp, 28
			jr $ra

#### CLEAN ARRAY FINISHES ####

#### STARTS GAME OF LIFE ####

game_of_life:
	
	sub, $sp, $sp, 48
	sw $ra, ($sp)
	sw $s0, 4($sp)		#argument for function set
	sw $s1, 4($sp)		#argument for function set
	sw $s2, 8($sp)		#neighbors
	sw $s3, 12($sp)		#cell
	sw $s4, 16($sp)		#x_pos
	sw $s5, 20($sp)		#y_pos
	sw $s6, 24($sp)		#it
	sw $s7, 44($sp)		#new array addres
	sw $a0, 28($sp)		#initial argument
	sw $a1, 32($sp)		#initial argument
	sw $a2, 36($sp)		#initial argument
	sw $a3, 40($sp)		#initial argument
	
	
	move $a0, $a1		#Argument for function malloc
	move $a1, $a2		#Argument for function malloc
	
	jal malloc
	
	move $s7, $v0       #saving addres new array
	
	move $a2, $a1		#initial argument
	move $a1, $a0		#initial argument
	lw $a0, 28($sp)		#initial argument
	
itloop:	bge $s6, $a3 end_game
		
		move $a0, $s7	#Argument for function clean
		
		jal clean_array
		
		lw $a0, 28($sp)		#initial argument
		
			loop1: bge $s5, $a2 end_loop1
					li $s4, 0					#reseting x_pos counter
				loop2:	bge $s4, $a1 end_loop2
						
						move $a3, $s4			#Argument for functions get and neighbors
						move $s0, $s5			#Argument for functions get and neighbors
						
						jal get
						move $s3, $v0			#Saving the value of the cell
						
						jal neighbors
						move $s2, $v0			#saving the value of the neighbors
						
						lw $a0, 28($sp)			#initial argument
						lw $a1, 32($sp)			#initial argument
						lw $a2, 36($sp)			#initial argument
						lw $a3, 40($sp)			#initial argument
						
						move $s1, $s5			#Argument for function set
						move $s0, $s4			#Argument for function set
						move $a3, $a2			#Argument for function set
						move $a2, $a1			#Argument for function set
						move $a0, $s7			#Argument for function set
							
							beqz $s3, equalzero
								seq $t0, $s2, 2		#if(neighbors == 2)
								seq $t1, $s2, 3		#if(neighbors == 3)
								or $t2, $t1, $t0	#if(neighbors == 2||neighbors == 3)
								
								beq $t2, 1, twoOrThree
								
								li $a1, 0
								jal set				#set(array_aux, 0, x, y,i, j)
								b end_if
							
					twoOrThree:	li $a1, 1       #set(array_aux, 1, x, y,i, j)
								jal set			
								b end_if
							
				equalzero:  bne $s2, 3, end_if
							li $a1, 1       	#set(array_aux, 1, x, y,i, j)
							jal set
			
				end_if:	addi $s4, $s4, 1		#x_pos + 1 
						
						lw $a0, 28($sp)			#initial argument
						lw $a1, 32($sp)			#initial argument
						lw $a2, 36($sp)			#initial argument
						lw $a3, 40($sp)			#initial argument
						b loop2
					
end_loop2: addi $s5, $s5, 1     				#y_pos + 1 
		   b loop1
		
end_loop1:	addi $s6, $s6, 1 					#it+1
			li $s5, 0							#resting y_pos counter
			
			move $a0, $s7		#argument for function copy_array
			lw $a1, 28($sp)		#argument for function copy_array
			lw $a2, 32($sp)		#argument for function copy_array
			lw $a3, 36($sp)		#argument for function copy_array
			
			jal copy_array	
			
			lw $a0, 28($sp)		#initial argument
			lw $a1, 32($sp)		#initial argument
			lw $a2, 36($sp)		#initial argument
			lw $a3, 40($sp)		#initial argument
	
			b itloop
	
end_game:		
	

	lw $ra, ($sp)
	lw $s0, 4($sp)		#argument for function set
	lw $s1, 4($sp)		#argument for function set
	lw $s2, 8($sp)		#neighbors
	lw $s3, 12($sp)		#cell
	lw $s4, 16($sp)		#x_pos
	lw $s5, 20($sp)		#y_pos
	lw $s6, 24($sp)		#it
	lw $s7, 44($sp)		#new array addres


	addi, $sp, $sp, 48
	
	jr $ra

#### FINISHES GAME OF LIFE ####

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