
.text
.globl main

main:

    li x10, 0x100        
    
    li x5, 1
    sw x5, 0(x10)        
    li x5, 2
    sw x5, 4(x10)        
    li x5, 4
    sw x5, 8(x10)       
    li x5, 3
    sw x5, 12(x10)       
    li x5, 5
    sw x5, 16(x10)       
    li x5, 6
    sw x5, 20(x10)     

  
    li x11, 6            

    jal x1, bubble       

  
    li a7, 10


bubble:

    beq  x10, x0, exit     
    beq  x11, x0, exit       

    li   x5, 0              

outer_loop:
    bge  x5, x11, exit       
    mv   x6, x5              

inner_loop:
    bge  x6, x11, next_i    

    
    slli x7, x5, 2           # x7 = i * 4
    add  x7, x10, x7         # x7 = &a[i]
    lw   x28, 0(x7)          # x28 = a[i]

   
    slli x8, x6, 2           # x8 = j * 4
    add  x8, x10, x8         # x8 = &a[j]
    lw   x29, 0(x8)          # x29 = a[j]

    # If (a[i] < a[j]), then swap (Descending Order)
    bge  x28, x29, next_j    # if a[i] >= a[j], skip swap

    # Perform swap
    sw   x29, 0(x7)          # a[i] = old a[j]
    sw   x28, 0(x8)          

next_j:
    addi x6, x6, 1        
    j    inner_loop

next_i:
    addi x5, x5, 1         
    j    outer_loop

exit:
    ret                    