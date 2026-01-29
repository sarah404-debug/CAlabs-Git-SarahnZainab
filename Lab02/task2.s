.text
.globl main

main:
    # initialize variables
    li x22, 10          # b = 10
    li x23, 4           # c = 4
    li x20, 5           # x = 1 (selector)

    li t0, 1           
    beq x20, t0, case1  # if x == 1, jump to case1
    li t0, 2            
    beq x20, t0, case2  # if x == 2, jump to case2
    li t0, 3           
    beq x20, t0, case3  # if x == 3, jump to case3
    li t0, 4            
    beq x20, t0, case4  # if x == 4, jump to case4
    j default           # else go to default

    case1:
        add x21, x22, x23  # a = b + c
        j end              # break

    case2:
        sub x21, x22, x23  # a = b - c
        j end              # break

    case3:
        slli x21, x22, 1   # a = b * 2 (shift left)
        j end              # break

    case4:
        srai x21, x22, 1   # a = b / 2 (shift right)
        j end              # break

    default:
        li x21, 0          # a = 0

end:
    j end             














    