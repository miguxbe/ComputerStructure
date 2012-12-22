#### .data    ####
#### Declare as many numx variables as %i, or %d ####
.data
	string:			.asciiz "This is the test string number %d. We can print integer numbers such as %d, %d and %d. Additionally, we can print floats:%f, %f, %f, %f, %f and %f."
	int0:			.word 1
	int1:			.word 5
	int3:			.word 9
	int4:			.word 72
	float0:			.float 5236.254
	float1:			.float 256.54
	float3:			.float -2568.2
	float4:			.float 25.92
	float5:			.float 6.4
	float6:			.float 2359.3358
	
.text
.globl main

#### MAIN STARTS ####

main:
	lw $a0, string			#1st argument
	lw $a1, int0			#2nd argument
	lw $a2, int1			#3rd argument
	lw $a3, int3			#4th argument
	
	l.s $f12, float0		#6th argument
	l.s $f13, float1		#7th argument
	l.s $f14, float3		#8th argument
	l.s $f15, float4		#9th argument
	
	sub $sp, $sp, 16		#Using the stack in order to store arguments
	sw $ra, ($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	
	lw $s0, int4			#5th argument
	lw $s1, float5			#10th argument
	lw $s2, float6			#11th argument
	
	jal printf
	
	lw $ra, ($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 16		#returnin the values of the stack
	
	jr $ra

#### MAIN FINISHES ####

#### PRINTF STARTS ####

printf:
	
	move $s3, $zero			#position
	move $s4, $zero			#counter

loop:	
	lb $t0, string($s3)		#character
	
	beq $t0, $zero end
	
	beq $t0, 37 if			#if($t0=='%')
	move $t1, $a0			#storing the value of $a0 temporarily
	move $a0, $t0
	li $v0, 11
	syscall					#print character
	move $a0, $t1			#returning the original value of $a0
	addi $s3, $s3, 1		#position +1
	b loop
	
if:
	addi $s3, $s3, 1		#position +1
	lb $t0, string($s3)		#getting a character
	
	beq $t0, 100 ifi		#if($t0=='d')
	beq $t0, 102 iff		#if($t0=='f')
	
	move $t1, $a0			#storing the value of $a0 temporarily
	li $a0, '%'
	li $v0, 11
	syscall					#print character
	
	move $a0, $t0
	li $v0, 11
	syscall					#print character
	
	move $a0, $t1			#returning the original value of $a0
	addi $s3, $s3, 1		#position +1
	
	b loop
	
ifi:
	move $t1, $a0			#storing the value of $a0 temporarily
	
	beq $s4, 0 case0
	beq $s4, 1 case1
	beq $s4, 2 case2
	beq $s4, 3 case3
case0:
	move $a0, $a1
	b breaki
case1:
	move $a0, $a2
	b breaki
case2:
	move $a0, $a3
	b breaki
case3:
	move $a0, $s0
	b breaki
	
breaki:
	sub $sp, $sp, 4
	sw $ra, ($sp)			#storing the value of $ra temporarily
	jal print_int
	lw $ra, ($sp)			#returning the value of $ra
	addi $sp, $sp, 4
	
	move $a0, $t1			#returning the original value of $a0
	
	addi $s4, $s4, 1		#counter +1
	addi $s3, $s3, 1		#position +1
	
	b loop
	
iff:
	mov.s $f4, $f12			#storing the value of $f12 temporarily
	
	beq $s4, 4 case4
	beq $s4, 5 case5
	beq $s4, 6 case6
	beq $s4, 7 case7
	beq $s4, 8 case8
	beq $s4, 9 case9
	
case4:
	b breakf
case5:
	mov.s $f12, $f13
	b breakf
case6:
	mov.s $f12, $f14
	b breakf
case7:
	mov.s $f12, $f15
	b breakf
case8:
	mtc1 $s1, $f12
	b breakf
case9:
	mtc1 $s2, $f12
	b breakf
	
breakf:
	sub $sp, $sp, 4
	sw $ra, ($sp)			#storing the value of $ra temporarily
	jal print_float
	lw $ra, ($sp)			#returning the value of $ra
	addi $sp, $sp, 4
	
	mov.s $f12, $f4			#returning the original value of $a0
	
	addi $s4, $s4, 1		#counter +1
	addi $s3, $s3, 1		#position +1
	
	b loop
	
end:
	jr $ra

#### PRINTF FINISHES ####

#### PRINT FLOAT STARTS ####

print_float:
	li $v0, 2
	syscall					#print float
	
	jr $ra

#### PRINT FLOAT FINISHES ####

#### PRINT INT STARTS ####

print_int:
	li $v0, 1
	syscall					#print integer

	jr $ra

#### PRINT INT FINISHES ####

