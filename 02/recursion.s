.section    .data
.section    .text

.globl _start
.globl factorial

_start:
  pushl   $4            # first parameter
  call    factorial     
  addl    $4,   %esp    # clear the stack
  movl    %eax, %ebx    # set the output value
  movl    $1,   %eax    # status code
  int     $0x80         # exit

#
# val = param * factoraial(param - 1)
#
.type   factorial,  @function

factorial:
  pushl   %ebp
  movl    %esp,    %ebp  # standard function setup
  movl    8(%ebp), %eax  # move the first argument into eax
  cmpl    $1,      %eax  # if the number is 1, simply return
  je      end_factorial
  decl    %eax           # decrease by 1
  pushl   %eax           # push for next factorial call
  call    factorial
  movl    8(%ebp),  %ebx # %eax contains the return value
                         # reload param into %ebx
  imull   %ebx,     %eax # multiply the last value by the factorial

end_factorial:
  movl    %ebp,     %esp # cleanup
  popl    %ebp
  ret
