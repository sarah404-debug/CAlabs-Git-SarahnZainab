# ============================================================
# Task A: Countdown Timer
# LEDs at 0x100, Switches at 0x200
# ============================================================

# --- Initialization ---
# 0x00: 10000113
    addi x2,  x0, 256      # sp = 256 (stack pointer)
# 0x04: 00000437
    lui  x8,  0            # s0 upper = 0
# 0x08: 10040413
    addi x8,  x8, 256      # s0 = 0x100 (LED address)
# 0x0C: 000004B7
    lui  x9,  0            # s1 upper = 0
# 0x10: 20048493
    addi x9,  x9, 512      # s1 = 0x200 (switch address)

# --- Wait for non-zero switch input ---
# wait_for_input:
# 0x14: 0004A303
    lw   x6,  0(x9)        # t1 = read switches
# 0x18: FE030EE3
    beq  x6,  x0, -4       # if t1 == 0, loop back to lw

# --- Main countdown loop ---
# count_loop:
# 0x1C: 00642023
    sw   x6,  0(x8)        # write count to LEDs
# 0x20: FF810113
    addi x2,  x2, -8       # allocate stack space
# 0x24: 00112223
    sw   x1,  4(x2)        # save return address
# 0x28: 020000EF
    jal  x1,  delay        # call delay subroutine (+32 → 0x48)
# 0x2C: 00412083
    lw   x1,  4(x2)        # restore return address
# 0x30: 00810113
    addi x2,  x2, 8        # deallocate stack
# 0x34: FFF30313
    addi x6,  x6, -1       # decrement count
# 0x38: 00034463
    blt  x6,  x0, finish   # if count < 0, jump to finish (+8 → 0x40)
# 0x3C: FE1FF06F
    jal  x0,  count_loop   # loop back (-32 → 0x1C)

# --- Done ---
# finish:
# 0x40: 00042023
    sw   x0,  0(x8)        # clear LEDs
# 0x44: 0000006F
    jal  x0,  0            # halt (infinite loop at 0x44)

# --- Delay subroutine (~0.5s at 100MHz) ---
# delay:
# 0x48: 017D82B7
    lui  x5,  6104         # load upper bits of ~25,000,000
# 0x4C: 80028293
    addi x5,  x5, -2048    # complete the delay count value
# delay_loop:
# 0x50: FFF28293
    addi x5,  x5, -1       # decrement
# 0x54: FE029EE3
    bne  x5,  x0, -4       # loop until zero (back to 0x50)
# 0x58: 00008067
    jalr x0,  0(x1)        # return to caller