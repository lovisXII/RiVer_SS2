.section .text
.global _start

_start:
    ori x1,x0,10
    ori x2,x0,12
    ori x3,x0,12
    ori x4,x0,52
    nop
    nop
    nop
    nop
    beq x3,x2,_label_test_1
    addi x7,x0,120
    beq x3,x2, _label_test_2 
    lw x10,0(x3)
    addi x12,x2,3
    slt x12,x3,x0

_label_test_2 :
    ori x6,x0,12
    lw x10,0(x3)
    addi x12,x2,3
    slt x12,x3,x0
    
_label_test_1 :
    addi x5,x0,12
    j _good
    