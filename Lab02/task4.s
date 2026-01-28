.text
.globl main

main:
    li x5, 5            # a = 5
    li x6, 4            # b = 4
    li x10, 0x200       # base address of D
    
    li x7, 0            # i = 0

outerloop:
    bge x7, x5, end     # if i >= a, exit
    li x29, 0           # j = 0

innerloop:
    bge x29, x6, nextI  # if j >= b, increment i
    # address calculation for D[4*j]
    # each word is 4 bytes, so D[4*j] is at offset 16*j
    slli t0, x29, 4     # t0 = j * 16 (shift left 4)
    add t1, x10, t0     # t1 = address of D[4*j]
    
    # logic: D[4*j] = i + j
    add t2, x7, x29     # t2 = i + j
    sw t2, 0(t1)        # store i+j in memory
    
    addi x29, x29, 1    # j++
    j innerloop         # jump to start of inner loop

nextI:
    addi x7, x7, 1      # i++
    j outerloop         # jump to start of outer loop

end:
    j end          

