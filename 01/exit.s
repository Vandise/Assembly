#
# Sets an exit status code 
#   as exit.s -o exit.o
#   ld exit.o -o exit
#   ./exit
#   echo $?

.section .data
.section .text

.globl _start

_start:
  movl  $1,   %eax
  movl  $0,   %ebx
  int   $0x80
