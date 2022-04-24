	.data
signe:		.word 0
exponent:	.word 0
mantissa:	.word 0
cfixa:		.word 0x87D18A00
cflotant:	.float 0.0

	.text
	.globl main
main:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$t0, cfixa
	lw	$a0, 0($t0)
	la	$a1, signe
	la	$a2, exponent
	la	$a3, mantissa
	jal	descompon

	la	$a0, signe
	lw	$a0,0($a0)
	la	$a1, exponent
	lw	$a1,0($a1)
	la	$a2, mantissa
	lw	$a2,0($a2)
	jal	compon

	la	$t0, cflotant
	swc1	$f0, 0($t0)

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	
	###Mostra cflotant en decimal
	li $v0, 2
	lwc1 $f12, 0($t0)
	syscall
	###Mostra cflotant en decimal
	
	jr	$ra


descompon:
	li $t0, 0 #int exp = 0
	slt $t0, $a0, $zero
	sw $t0, 0($a1) #*s = (cf < 0)
	sll $a0, $a0, 1 #cf = cf << 1

if:	beq $a0, $zero, else
	addiu $t0, $zero, 18
	
while:  blt $a0, $zero, fi_w
        sll $a0, $a0, 1
        addiu $t0, $t0, -1
        b while
        
fi_w:   sra $a0, $a0, 8
	li $t1, 0x7FFFFF
	and $a0, $a0, $t1 #cf = (cf >> 8) & 0x7FFFFF
	addiu $t0, $t0, 127
	
else:   sw $t0, 0($a2)
	sw $a0, 0($a3)
	
	jr $ra

compon:
	sll $a1, $a1, 23
	sll $a0, $a0, 31
	or $t0, $a1, $a0
	or $t0, $t0, $a2
	mtc1 $t0, $f0
	
	jr $ra

