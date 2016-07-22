#
# FOR 64 BIT:
#   as --32 power.s -o power.o
#   ld -m elf_i386 power.o -o power
# Function with C calling convention
# Value of 2^3 + 5^2 (test with 0 as well)
# result: 33, 26, or 9
#

.section    .data
.section    .text
.globl      _start

_start:
  pushl   $0          # push 3 onto the stack (or zero)
  pushl   $2          # push 2
  call    power       # call the "power" function
  addl    $8,   %esp  # move the stack pointer back 8 bytes ( 2 words / params)
                      # to pop all the params off the stack
  pushl   %eax        # push the returned value

  pushl   $2
  pushl   $5
  call    power
  addl    $8,   %esp  # at this point the stack contains
                      # 2^3, 2, 5 and eax 5^2
                      # go back two words

  popl    %ebx        # pop the last value on the stack (2^3)
  addl    %eax, %ebx  # add 2^3 + 5^2

  movl    $1,   %eax
  int     $0x80       # exit, ebx returned


#
# %esp - top of the stack pointer
# %ebp - base pointer for function params and local variables
#        a reference to the current stack frame
#
# C calling convention:
#   Save the base pointer:  
#     pushl %ebp (used to access params and local variables)
#   copy the stack pointer:
#     movl %esp, %ebp (access function params as fixed indexes from the base pointer)
#
#
#    param 2    <--- 12(ebp)
#    param 1    <--- 8(ebp)
#    ret addr   <--- 4(ebp)
#    old ebp    <--- esp and ebp
#
#    Reserve space for any local variables:
#     subl $num_words, %esp
#
#    stack ... 
#    old ebp        <---- esp
#    local var 1    <---- -4(ebp)
#    local var 2    <---- -8(ebp) and esp
#
#
#    Before returning, restore previous stack frame:
#     movl %ebp, %esp  -- move previous stack pointer to current
#     popl %ebp        -- remove old ebp reference
#
#     ret           <---- return the value in eax
#

.type   power,   @function

power:
  pushl   %ebp        # save the old base pointer
  movl    %esp, %ebp  # make the stack pointer the base pointer
  subl    $4,   %esp  # save 1 word for current result (local var)

  movl    8(%ebp),  %ebx  # put the first arg. in eax
  movl   12(%ebp),  %ecx  # second arg. ecx

  movl    %ebx,  -4(%ebp) # store current result (first arg)

power_loop_start:
  cmpl    $1, %ecx            # power = 1, exit
  je      end_power
  cmpl    $0, %ecx
  je      zero_power          # the power is, zero, result = 1
  movl    -4(%ebp), %eax      # store current result in eax
  imull   %ebx,     %eax      # multiply base by power
  movl    %eax,     -4(%ebp)  # store current result
  decl    %ecx                # decrease the power by 1
  jmp     power_loop_start    # next power

zero_power:
  movl    $1,       -4(%ebp)  # store current result as 1
  jmp     end_power           # end

end_power:
  movl    -4(%ebp),   %eax    # return value goes in eax
  movl    %ebp,       %esp    # restore stack pointer
  popl    %ebp                # restore base pointer
  ret
