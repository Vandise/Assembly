.include "./common/linux.s"

#
# Prints a message out to the console
#   Param 1 - A string
#   Param 2 - Buffer Size
#
.type   writeln,  @function

.equ    _STRING,  8
.equ    _BUFFER_SIZE, 12

writeln:

  pushl %ebp
  movl  %esp, %ebp


  movl  $SYS_WRITE,         %eax    # System Write
  movl  $STDOUT,            %ebx
  movl  _STRING(%ebp),      %ecx
  movl  _BUFFER_SIZE(%ebp), %edx

  int   $SYS_CALL

  movl  %ebp,   %esp
  popl  %ebp
  ret

#
# Reads user input
#   Param 1 - Input Buffer
#   Param 2 - Max Bytes
#   Return:
#     Number of bytes read in
#
.type   readln,   @function

.equ    _BUFFER,    8
.equ    _MAX_BYTES, 12

readln:

  pushl   %ebp
  movl    %esp,   %ebp

  movl  $SYS_READ,        %eax     # Get user input
  movl  $SYS_CONSOLE,     %ebx
  movl  _BUFFER(%ebp),    %ecx
  movl  _MAX_BYTES(%ebp), %edx

  int   $SYS_CALL

  movl  %ebp,   %esp
  popl  %ebp
  ret
