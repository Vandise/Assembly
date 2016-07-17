#
# Finds the largest item in a list
#   %edi - current index
#   %ebx - largest item found
#   %eax - current item
#

.section .data

list:
  .long 1,2,3,4,5,6,7,8,9,10,11,0

.section .text

.globl _start

_start:
  movl    $0,   %edi            # set index position to 0
  movl    list(,%edi,4),  %eax  # load the first byte in the list
  movl    %eax, %ebx            # first item is always initially the largest

start_loop:
  cmpl    $0,   %eax            # check for terminating byte (0)
  je      loop_exit             # exit routine if true
  incl    %edi                  # increment next index
  movl    list(,%edi,4),  %eax
  cmpl    %ebx, %eax            # compare the two values
  jle     start_loop            # jump next iteration if new value 
                                # is less then current value
  movl    %eax, %ebx            # save the largest number
  jmp     start_loop            # next iteration

loop_exit:
  movl    $1, %eax              # move largest value to sys call
  int     $0x80
