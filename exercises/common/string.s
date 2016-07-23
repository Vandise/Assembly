# Concats two strings into a defined buffer
#   Param 1 - String 1
#   Param 2 - String 2
#   Param 3 - Out Buffer
.type str_concat, @function

.equ  _STRING_1,  8
.equ  _STRING_2,  12
.equ  _BUFFER,    16
.equ  _STR_1_LEN, -4
.equ  _STR_2_LEN, -8

str_concat:

  pushl   %ebp
  movl    %esp,   %ebp
  subl    $8,     %esp

  pushl _STRING_1(%ebp)           # Get the input lengths
  call str_len
  addl  $4, %esp
  movl  %eax, _STR_1_LEN(%ebp)

  pushl _STRING_2(%ebp)
  call str_len
  addl  $4, %esp
  movl  %eax, _STR_2_LEN(%ebp)

  movl _STRING_1(%ebp),   %esi    # Merge the strings
  movl _BUFFER(%ebp),     %edi
  movl _STR_1_LEN(%ebp),  %ecx
  cld	
  rep  movsb

  movl _STRING_2(%ebp),  %esi
  movl _STR_2_LEN(%ebp), %ecx
  cld			
  rep  movsb

  movl    %ebp,   %esp            # Return
  popl    %ebp
  ret


# Calculates the length of a string
#   Param 1 - String
.type str_len, @function

.equ  _STRING, 8

str_len:

  pushl  %ebp
  movl   %esp,  %ebp

  xorl    %edi,         %edi
  movl   _STRING(%ebp), %esi

str_len_loop:

  lodsb                 # Read byte of string and increment position
  cmpb    $0,   %al     # If read byte = 0, end of string
  jz      end_str_len
  incl    %edi
  jmp     str_len_loop

end_str_len:

  #decl  %edi
  movl  %edi, %eax      # return the character count
  movl  %ebp, %esp
  popl  %ebp
  ret

# Reverses a string
#   Param 1 - String / Buffer
#   Param 2 - Buffer Length

.type str_reverse, @function

  .equ  _STR_BUFFER,     8
  .equ  _STR_BUFFER_LEN, 12

str_reverse:

  pushl  %ebp
  movl   %esp,  %ebp

  movl    _STR_BUFFER(%ebp),      %eax
  movl    _STR_BUFFER_LEN(%ebp),  %ebx

  movl    $0,   %edi
  cmpl    $0,   %ebx
  je      end_str_reverse

push_loop:                          # Push the string onto the stack in reverse order

  movb    (%eax,%edi,1),  %cl
  push    %ecx
  incl    %edi
  cmpl    %edi, %ebx
  jne     push_loop

  movl    $0,   %edi

construct_string:                   # Reconstruct the string

  pop   %ecx                
  movb  %cl,  (%eax,%edi,1)

  incl  %edi
  cmpl  %edi, %ebx
  jne   construct_string

end_str_reverse:

  movl  %ebp, %esp
  popl  %ebp
  ret
