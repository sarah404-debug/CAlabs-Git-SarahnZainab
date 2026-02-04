.text
.globl main

main:
    li x10, 0x100        #Base address for string x
    li x11, 0x200        #Base address for string y

    li x5, 90            #'Z'
    sb x5, 0(x11)
    li x5, 110           #'n'
    sb x5, 1(x11)
    li x5, 83            #'S'
    sb x5, 2(x11)
    li x5, 0             #'\0'
    sb x5, 3(x11)

    jal x1, strcpy

end:
    j end                


strcpy:
    addi sp, sp, -4      
    sw x19, 0(sp)        
    add x19, x0, x0      #i = 0

L1:
    add x5, x19, x11     #address of y[i]
    lbu x6, 0(x5)        #load byte y[i]
    add x7, x19, x10     #address of x[i]
    sb x6, 0(x7)         #x[i] = y[i]
    beq x6, x0, L2       #if '\0', exit loop
    addi x19, x19, 1     #i++
    j L1

L2:
    lw x19, 0(sp)        #restore x19
    addi sp, sp, 4       #restore stack pointer
    jalr x0, 0(x1)       #return
