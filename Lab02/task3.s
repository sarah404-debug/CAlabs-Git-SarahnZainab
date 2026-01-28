    .text
    .globl main

main:
    li   x22, 0          # i = 0
    li   x23, 0          # sum = 0
    li   x5,  10         # n = 10
    li   x6,  0          # offset = 0
Loop1:
    beq  x22, x5, Init   # if i == 10, go to Init
    sw   x22, 0x200(x6)  # store i at memory[0x200 + offset]
    addi x6, x6, 4       # offset += 4
    addi x22, x22, 1    # i++
    beq  x0, x0, Loop1  # unconditional jump
Init:
    li   x22, 0          # i = 0
    li   x6,  0          # offset = 0

Loop2:
    beq  x22, x5, End   # if i == 10, end
    lw   x28, 0x200(x6) # load value
    add  x23, x23, x28  # sum += value
    addi x6, x6, 4      # offset += 4
    addi x22, x22, 1    # i++
    beq  x0, x0, Loop2 # unconditional jump
End:
    beq  x0, x0, End    # infinite loop






