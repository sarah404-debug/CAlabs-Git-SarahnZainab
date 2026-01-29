# .text
# .globl main

# main:
#     addi x10, x0, 2
#     addi x11, x0, 3
#     addi x12, x0, 4
#     addi x13, x0, 5
#     addi x20, x0, 0

#     jal x1, leaf_example

# end:
#     j end


# leaf_example:
#     add x18, x10, x11     # x18 = g + h
#     add x19, x12, x13     # x19 = i + j
#     sub x20, x18, x19     # f = (g + h) - (i + j)

#     jalr x0, 0(x1)        # return


.text
.globl main

main:
    addi x10, x0, 2      # g = 2
    addi x11, x0, 3      # h = 3
    addi x12, x0, 4      # i = 4
    addi x13, x0, 5      # j = 5

    jal x1, leaf_example

end:
    j end


leaf_example:
    addi sp, sp, -12 

    sw x18, 0(sp)     
    sw x19, 4(sp)     
    sw x20, 8(sp)

    add x18, x10, x11 
    add x19, x12, x13 
    sub x20, x18, x19 

    ld x18, 0(sp)     
    ld x19, 8(sp)      
    ld x20, 16(sp)     

    addi sp, sp, 24    
    jalr x0, 0(x1)       



