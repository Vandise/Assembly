.include "string.s"

.section  .data
  
number:
  .long 6000

buffer:
  .space 10

.equ SYS_EXIT,    1
.equ SYS_WRITE,   4
.equ STDOUT,      1
.equ LEN,         11

.section  .text

.global _start
.text

_start:

  movl  %esp, %ebp

  pushl   $buffer
  pushl   number
  call    i_to_s

  pushl $buffer
  call  str_len
  addl  $8,   %esp

  movl    $STDOUT, %ebx
  movl    $buffer, %ecx
  movl    %eax, %edx
  movl    $SYS_WRITE, %eax
  int     $0x80

  movl    $SYS_EXIT, %eax
  xorl    %ebx, %ebx
  int     $0x80



# Converts an integer to a string
#   Param 1 - An integer adress
.type i_to_s, @function

.equ  _ITOS_NUM,     8
.equ  _ITOS_BUFFER,  12

decimal:  .long 10

i_to_s:

  pushl  %ebp
  movl   %esp,  %ebp
  
  movl    _ITOS_BUFFER(%ebp), %edi
  movl    _ITOS_NUM(%ebp),    %eax
  
loop_digits:                  # Convert each digit to its ascii counterpart

  xorl    %edx, %edx
  divl    decimal
  addl    $48, %edx
  movb    %dl, (%edi)
  incl    %edi
  cmpl    $4, %eax
  jg      loop_digits

reverse_bytes:

  pushl  _ITOS_BUFFER(%ebp)
  call  str_len
  addl  $8,   %esp

  pushl   %eax
  pushl   _ITOS_BUFFER(%ebp)
  call    str_reverse
  addl    $8,   %esp

end_i_to_s:

  movl  %ebp, %esp
  popl  %ebp
  ret
