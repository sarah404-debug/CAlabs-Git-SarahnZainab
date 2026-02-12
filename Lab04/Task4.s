
.text
.globl main

main:
    li   x10, 4         
    jal  x1, factorial   

    
end:
    j    end             


factorial:
   
    addi sp, sp, -16     
    sw   x1,  12(sp)    
    sw   x19, 8(sp)      
    sw   x20, 4(sp)  

    mv   x19, x10      

   
    li   x20, 1         
    ble  x19, x20, base_case

    addi x10, x19, -1    
    jal  x1, factorial   

    
    mul  x10, x10, x19   
    j    epilogue

base_case:
    li   x10, 1          

epilogue:
    
    lw   x20, 4(sp)      
    lw   x19, 8(sp)      
    lw   x1,  12(sp)     
    addi sp, sp, 16      
    jr   x1             