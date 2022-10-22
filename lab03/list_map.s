.globl map

.text
main:
    jal ra, create_default_list
    add s0, a0, x0  # a0 = s0 is head of node list

    #print the list
    add a0, s0, x0
    jal ra, print_list

    # print a newline
    jal ra, print_newline

    # load your args
    add a0, s0, x0  # load the address of the first node into a0

    # load the address of the function in question into a1 (check out la on the green sheet)
    ### YOUR CODE HERE ###
    la a1, square

    # issue the call to map
    jal ra, map

    # print the list
    add a0, s0, x0
    jal ra, print_list

    # print another newline
    jal ra, print_newline

    addi a0, x0, 10
    ecall #Terminate the program

map:
    # Prologue: Make space on the stack and back-up registers
    # in there you must use the stack to store the value other taht it will visit other space in this area
    ### YOUR CODE HERE ###
    addi sp, sp, -8     # make space for stack
    beq a0, x0, done    # If we were given a null pointer (address 0), we're done.
    # 将a0和a1分别放在s0和s1中
    add s0, a0, x0  # Save address of this node in s0
    add s1, a1, x0  # Save address of function in s1

    # Remember that each node is 8 bytes long: 4 for the value followed by 4 for the pointer to next.
    # What does this tell you about how you access the value and how you access the pointer to next?

    # load the value of the current node into a0
    # THINK: why a0?
    # Just beacause the square operation have the goal of a0
    # 0(s0) is the value of current node and 4(s0) is the next node
    ### YOUR CODE HERE ###
    # store the return address and the current value into stack
    sw ra, 0(sp)        # store the return address
    sw s0, 4(sp)        # store the stack frame address
    lw a0, 0(s0)
    # Call the function in question on that value. DO NOT use a label (be prepared to answer why).
    # What function? Recall the parameters of "map"
    ### YOUR CODE HERE ###
    jal ra, square

    # store the returned value back into the node
    # Where can you assume the returned value is?
    ### YOUR CODE HERE ###
    sw a0, 0(s0)  # update the value of current node

    # Load the address of the next node into a0
    # The Address of the next node is an attribute of the current node.
    # Think about how structs are organized in memory.
    ### YOUR CODE HERE ###
    lw a0, 4(s0) # translate the next node's address into a0
    # Put the address of the function back into a1 to prepare for the recursion
    # THINK: why a1? What about a0?
    ### YOUR CODE HERE ###
    mv a1, s1
    # recurse
    ### YOUR CODE HERE ###
    jal ra, map # jump and update the pc to get the next address of return
done:
    # Epilogue: Restore register values and free space from the stack
    ### YOUR CODE HERE ###
    addi sp, sp, 8  # restore the stack
    lw ra, 0(sp)    # get the return address
    lw s0, 4(sp)    # get the current stack address
    jr ra # Return to caller

square:
    mul a0 ,a0, a0 # a0 = a0 * a0
    jr ra

create_default_list:
    # here is the example of allocate the space of one node
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    li  s0, 0       # pointer to the last node we handled
    li  s1, 0       # number of nodes handled
loop:   #do...while loop
    li  a0, 8
    jal ra, malloc      # get memory for the next node
    sw  s1, 0(a0)   # node->value = i
    sw  s0, 4(a0)   # node->next = last
    add s0, a0, x0  # last = node
    addi s1, s1, 1   # i++
    addi t0, x0, 10     # tmp = 10
    bne s1, t0, loop    # ... while i!= tmp
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    jr ra

print_list:
    bne a0, x0, printMeAndRecurse
    jr ra       # nothing to print
printMeAndRecurse:
    add t0, a0, x0  # t0 gets current node address
    lw  a1, 0(t0)   # a1 gets value in current node
    addi a0, x0, 1      # prepare for print integer ecall
    ecall
    addi    a1, x0, ' '     # a0 gets address of string containing space
    addi    a0, x0, 11      # prepare for print string syscall
    ecall
    lw  a0, 4(t0)   # a0 gets address of next node
    jal x0, print_list  # recurse. We don't have to use jal because we already have where we want to return to in ra

print_newline:
    addi    a1, x0, '\n' # Load in ascii code for newline
    addi    a0, x0, 11
    ecall
    jr  ra

malloc:
    addi    a1, a0, 0 # have a understand that a0 is the node,所以先 a0 = 8
    addi    a0, x0 9 # using a1 just because there is a need to call kenral
    ecall  # after call the OS, a0 += 2  this data will be allocated into the heap
    jr  ra

