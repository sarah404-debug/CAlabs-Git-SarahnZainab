.text
.globl main

main:
    li x10, 0x100       
    
    li x5, 1
    sw x5, 0(x10)        # v[0] = 1
    li x5, 2
    sw x5, 4(x10)        # v[1] = 2
    li x5, 4
    sw x5, 8(x10)        # v[2] = 4
    li x5, 3
    sw x5, 12(x10)       # v[3] = 3
    li x5, 5
    sw x5, 16(x10)       # v[4] = 5
    li x5, 6
    sw x5, 20(x10)       # v[5] = 6

    li x11, 6            # len = 6 elements

    jal x1, bubble      

    li a7, 10



bubble:
    #initial check: if (a == NULL || len == 0) return
    beq  x10, x0, exit       
    beq  x11, x0, exit       

    li   x5, 0           

outer_loop:
    bge  x5, x11, exit       

    addi x6, x5, 0           # j = i (inner loop counter)

inner_loop:
    bge  x6, x11, next_i     

    #calculate address of a[i]
    slli x7, x5, 2           
    add  x7, x10, x7         
    lw   x28, 0(x7)          

    #calculate address of a[j]
    slli x8, x6, 2           
    add  x8, x10, x8         
    lw   x29, 0(x8)          

    # iif (a[i] < a[j]), then swap (descending Order)
    bge  x28, x29, next_j    

    # swapping
    sw   x29, 0(x7)          
    sw   x28, 0(x8)          

next_j:
    addi x6, x6, 1           
    j    inner_loop

next_i:
    addi x5, x5, 1           
    j    outer_loop

exit:
    ret