.text
.globl main

main:
    li x10, 4         
    jal x1, ntri       

    addi x11, x10, 0     
    addi x10, x0, 1     
    ecall

end:

    jal x0, end   

ntri:

    addi x2, x2, -8     

    sw x1, 4(x2)        
    sw x10, 0(x2)      

    addi x5, x0, 1
    bge x5, x10, base_case  

    addi x10, x10, -1       
    jal x1, ntri            

    lw x6, 0(x2)         
    add x10, x10, x6       

    lw x1, 4(x2)           
    addi x2, x2, 8          
    jalr x0, 0(x1)     

base_case:

    addi x10, x0, 1         
    lw x1, 4(x2)           

    addi x2, x2, 8          

    jalr x0, 0(x1)

