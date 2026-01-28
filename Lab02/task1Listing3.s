.text
.globl main

main:

    li x19, 5          # i = 5
    li x20, 6          # j = 6
    li x21, 7          # k = 7
    li x22, 8          # a = 8
    li x23, 9          # b = 9

        
    bne x22, x23, Else # if a != b, jump to Else
    add x19, x20, x21  # i = j + k
    beq x0, x0, Exit   # jump to Exit 

Else: 
    sub x19, x20, x21  # i = j - k
    Exit:

end:
j end


