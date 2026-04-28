# ================= INIT =================
addi x2, x0, 511      # sp = 511
addi x6, x0, 256      # LED address = 0x100

addi x7, x0, 0        # prev = 0
addi x8, x0, 1        # curr = 1
addi x14, x0, 10      # count = 10

# ================= MAIN LOOP =================
loop:
    add x10, x8, x0        # a0 = curr
    jal x1, display        # call display

    add x9, x7, x8         # next = prev + curr
    add x7, x8, x0         # prev = curr
    add x8, x9, x0         # curr = next

    addi x14, x14, -1      # count--
    bne x14, x0, loop      # repeat

# ================= DONE =================
sw x0, 0(x6)               # clear LEDs
jal x0, 0                  # halt (infinite loop)

# ================= SUBROUTINE =================
display:
    addi x2, x2, -8        # make stack space
    sw x1, 4(x2)           # save ra
    sw x10, 0(x2)          # save a0

    sw x10, 0(x6)          # output to LEDs

    addi x13, x0, 5        # small delay counter

delay:
    addi x13, x13, -1
    bne x13, x0, delay

    lw x10, 0(x2)          # restore a0
    lw x1, 4(x2)           # restore ra
    addi x2, x2, 8         # pop stack

    jalr x0, 0(x1)         # return