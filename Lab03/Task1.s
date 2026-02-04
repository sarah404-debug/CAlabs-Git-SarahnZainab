.text
.globl main

main:
    addi x10, x0, 12     #load first number (12)
    addi x11, x0, 12     #load second number (12)

    jal x1, sum          #call sum function

    addi x11, x10, 0     #move result to x11 for printing
    li x10, 1            #print integer
    ecall 

    j end               

sum:
    add x10, x11, x10    #x10 = x10 + x11
    jalr x0, 0(x1)       #return to caller

end:
    j end                
