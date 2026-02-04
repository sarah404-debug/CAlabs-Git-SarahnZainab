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
    addi sp, sp, -12     # allocate stack space

    sw x18, 0(sp)        # save x18
    sw x19, 4(sp)        # save x19
    sw x20, 8(sp)        # save x20

    add x18, x10, x11    # x18 = g + h
    add x19, x12, x13    # x19 = i + j
    sub x20, x18, x19    # x20 = (g + h) - (i + j)
                          

    lw x18, 0(sp)        # restore x18
    lw x19, 4(sp)        # restore x19
    lw x20, 8(sp)        # restore x20

    addi sp, sp, 12      # restore stack pointer
    jalr x0, 0(x1)       # return
