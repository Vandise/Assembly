.include "string.s"

#
# Converts an int to a string
#   Param 1 - Int Value
#   Param 2 - Buffer to write the string to
#
.equ ST_VALUE, 8
.equ ST_BUFFER, 12

.type int_to_s, @function
int_to_s:

  pushl   %ebp
  movl    %esp,   %ebp

  movl    $0,   %ecx
  movl    ST_VALUE(%ebp), %eax
  movl    $10,  %edi

conversion_loop:

  movl    $0,   %edx
  divl    %edi

  addl    $'0', %edx
  pushl   %edx
  incl    %ecx

  cmpl    $0,   %eax
  je      end_conversion_loop

  jmp     conversion_loop

end_conversion_loop:

  movl  ST_BUFFER(%ebp),    %edx

copy_reversing_loop:

  popl  %eax
  movb  %al,  (%edx)

  decl  %ecx
  incl  %edx

  cmpl  $0, %ecx
  je    end_copy_reversing_loop

  jmp   copy_reversing_loop

end_copy_reversing_loop:

  movb  $0,   (%edx)

  movl  %ebp,   %esp
  popl  %ebp
  ret