.text
.globl main

main:
    li x10, 4          # n = 4
    jal x1, ntri       # call function

    addi x11, x10, 0   # move result to x11 for printing

    li x10, 1          # print integer
    ecall

end:
    j end

ntri:
    addi x2, x2, -8      # allocate stack
    sw x1, 4(x2)         # save return address
    sw x10, 0(x2)        # save original n

    li x5, 1
    ble x10, x5, base_case   # if (n <= 1)

    addi x10, x10, -1    # n = n - 1
    jal x1, ntri         # recursive call

    lw x6, 0(x2)         # restore original n
    add x10, x10, x6     # ntri(n-1) + n

    lw x1, 4(x2)         #restore return address
    addi x2, x2, 8       #deallocate stack
    jalr x0, 0(x1)      


base_case:
    li x10, 1          

    lw x1, 4(x2)
    addi x2, x2, 8
    jalr x0, 0(x1)