.text
.globl main

main:
    li   x10, 5          # n = 5
    jal  x1, fact_iter   # call factorial

    #print Result logic
    addi x11, x10, 0     
    li   x10, 1       
    ecall 

end:
    j    end            

fact_iter:
    li   x5, 1           # result = 1
    
loop:
    ble  x10, x0, done   # if n <= 0, exit
    mul  x5, x5, x10     # result = result * n
    addi x10, x10, -1    # n = n - 1
    j    loop            # repeat

done:
    addi x10, x5, 0      
    ret             
















    