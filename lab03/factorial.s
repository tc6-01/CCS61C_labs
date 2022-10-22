.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # a0 is the given value to implemment the fn
    addi t0, x0, 1 # t0=1
    mv t1, a0 # t1 = a0
return:
    mul t0, t1, t0 # total = tmp * total
    addi t1, t1, -1  # a0=a0-1
    mv a0, t0
    beq t1, x0, C  # judge the n eaual 0
    j return
