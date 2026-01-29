.text
.globl main

main:
    li x10, 0x100
    li x11, 0x200
    
    li x5, 72
    sb x5, 0(x11)
    li x5, 105
    sb x5, 1(x11)
    li x5, 0
    sb x5, 2(x11)

    jal x1, strcpy

    li x17, 10
    ecall

strcpy:
    addi sp, sp, -4
    sw x19, 0(sp)
    add x19, x0, x0

L1:
    add x5, x19, x11
    lbu x6, 0(x5)
    add x7, x19, x10
    sb x6, 0(x7)
    beq x6, x0, L2
    addi x19, x19, 1
    j L1

L2:
    lw x19, 0(sp)
    addi sp, sp, 4
    jalr x0, 0(x1)