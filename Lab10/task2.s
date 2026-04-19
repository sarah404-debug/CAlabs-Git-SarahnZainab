# .data
# SWITCH_ADDR: .word 0x10000000
# LED_ADDR:    .word 0x10000004
# RESET_ADDR:  .word 0x10000008

# .text
# .globl main

# main:
#     li s0, 0                # s0 = state (0 = WAIT, 1 = COUNT)

# main_loop:
#     jal ra, check_reset

#     beq s0, zero, WAIT_STATE

#     li t0, 1
#     beq s0, t0, COUNT_STATE

#     j main_loop

# # WAIT STATE
# WAIT_STATE:
#     la t3, SWITCH_ADDR      # load address of SWITCH_ADDR
#     lw t3, 0(t3)            # get actual address
#     li t1, 5                # read switch value

#     beq t1, zero, WAIT_STATE

#     mv s1, t1               # store counter value

#     la t3, LED_ADDR
#     lw t3, 0(t3)
#     sw s1, 0(t3)            # display on LEDs

#     li s0, 1                # go to COUNT

#     j main_loop

# # COUNT STATE
# COUNT_STATE:
#     mv a0, s1
#     jal ra, countdown

#     li s0, 0                # back to WAIT

#     j main_loop

# # COUNTDOWN FUNCTION
# countdown:
#     addi sp, sp, -8
#     sw ra, 0(sp)
#     sw s1, 4(sp)

#     mv s1, a0

# count_loop:
#     beq s1, zero, count_done

#     la t3, LED_ADDR
#     lw t3, 0(t3)
#     sw s1, 0(t3)

#     addi s1, s1, -1

#     jal ra, delay

#     j count_loop

# count_done:
#     lw ra, 0(sp)
#     lw s1, 4(sp)
#     addi sp, sp, 8
#     ret

# # DELAY FUNCTION
# delay:
#     li t0, 500000

# delay_loop:
#     addi t0, t0, -1
#     bne t0, zero, delay_loop

#     ret

# # RESET FUNCTION
# check_reset:
#     la t3, RESET_ADDR
#     lw t3, 0(t3)
#     lw t2, 0(t3)

#     beq t2, zero, reset_return

#     li s0, 0

#     la t3, LED_ADDR
#     lw t3, 0(t3)
#     sw zero, 0(t3)

# reset_return:
#     ret




.text
.globl main

main:
    li s0, 0                # s0 = state (0 = WAIT, 1 = COUNT)

main_loop:
    jal ra, check_reset
    beq s0, zero, WAIT_STATE
    li t0, 1
    beq s0, t0, COUNT_STATE
    j main_loop

# --- WAIT STATE ---
WAIT_STATE:
    li t3, 0x200            # THE FIX: 0x200 is the Base MMIO for Switches
    lw t1, 0(t3)            # Read switches
    
    beq t1, zero, WAIT_STATE 

    mv s1, t1               # Store switch value
    sw s1, -256(t3)         # THE FIX: Write to LEDs (0x200 - 256 = 0x100)

    li s0, 1                # Go to COUNT state
    j main_loop

# --- COUNT STATE ---
COUNT_STATE:
    mv a0, s1
    jal ra, countdown
    li s0, 0                # Back to WAIT
    j main_loop

# --- COUNTDOWN FUNCTION ---
countdown:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s1, 4(sp)
    mv s1, a0

count_loop:
    beq s1, zero, count_done
    
    li t3, 0x100            # THE FIX: 0x100 is the Base MMIO for LEDs
    sw s1, 0(t3)            # Display counter on LEDs
    
    addi s1, s1, -1         # Decrement
    jal ra, delay           # Delay
    
    j count_loop

count_done:
    lw ra, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

# --- DELAY FUNCTION ---
delay:
    # Set to 5 for simulation. Change to 500000 for actual FPGA hardware.
    li t0, 5                

delay_loop:
    addi t0, t0, -1
    bne t0, zero, delay_loop
    ret

# --- RESET FUNCTION ---
check_reset:
    li t3, 0x200            # Switches Address
    lw t2, 8(t3)            # Read offset 8 (If mapped to a button)
    
    beq t2, zero, reset_return
    
    li s0, 0                # Force state back to WAIT
    sw zero, -256(t3)       # Turn off LEDs (0x200 - 256 = 0x100)

reset_return:
    ret