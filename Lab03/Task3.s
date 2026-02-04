.text
.globl main

main:
    li x10, 0x100        #base address of array v[]

    li x5, 1
    sw x5, 0(x10)        #v[0] = 1
    li x5, 2
    sw x5, 4(x10)        #v[1] = 2
    li x5, 4
    sw x5, 8(x10)        #v[2] = 4
    li x5, 3
    sw x5, 12(x10)       #v[3] = 3
    li x5, 5
    sw x5, 16(x10)       #v[4] = 5
    li x5, 6
    sw x5, 20(x10)       #v[5] = 6

    li x11, 2            #k = 2 (index to swap)

    jal x1, swap         #call swap(v, k)

end:
    j end            

swap:
    slli x5, x11, 2      #x5 = k * 4 (byte offset)
    add x5, x10, x5      #x5 = address of v[k]

    lw x6, 0(x5)         #load v[k]
    lw x7, 4(x5)         #load v[k+1]

    sw x7, 0(x5)         #v[k] = v[k+1]
    sw x6, 4(x5)         #v[k+1] = old v[k]

    jalr x0, 0(x1)       #return to main
