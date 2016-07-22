.include  "linux.s"

.type   open_file,    @function

# Function open_file:
##  Open a file, returns file descriptor (%eax)
##  Param 1: File Name
##  Param 2: Flags
##  Param 3: Mode

.equ  _OPEN_FILE_NAME,  8
.equ  _OPEN_FILE_FLAGS, 12
.equ  _OPEN_FILE_MODE,  16

open_file:
  
  # C function calling convention

  pushl   %ebp
  movl    %esp,   %ebp
  pushl   %ebx

  # Open the file

  movl    $SYS_OPEN,              %eax
  movl    _OPEN_FILE_NAME(%ebp),  %ebx
  movl    _OPEN_FILE_FLAGS(%ebp), %ecx
  movl    _OPEN_FILE_MODE(%ebp),  %edx

  int     $SYS_CALL

  # Restore stack pointer

  movl    %ebp,   %esp
  popl    %ebp
  ret
