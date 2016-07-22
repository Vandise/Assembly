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

.type   close_file,    @function

# Function close_file:
##  Closes a file descriptor, returns response
##  Param 1: File Descriptor

.equ  _CLOSE_FILE_DESC,  8

close_file:

  # C function calling convention

  pushl   %ebp
  movl    %esp,   %ebp
  pushl   %ebx

  # Close the file descriptor

  movl    $SYS_CLOSE,             %eax
  movl    _CLOSE_FILE_DESC(%ebp), %ebx
  int     $SYS_CALL

  # Restore stack pointer

  movl    %ebp,   %esp
  popl    %ebp
  ret

.type   read_buffer,    @function

.equ _READ_BUFFER_FILE, 8
.equ _READ_BUFFER, 12
.equ _READ_BUFFER_SIZE, 16

# Function read_buffer:
##  Reads content into a buffer
##  Param 1: File Descriptor
##  Param 2: Buffer
##  Param 3: Buffer Size

read_buffer:

  # C function calling convention

  pushl   %ebp
  movl    %esp,   %ebp
  pushl   %ebx

  # Read contents into the buffer

  movl    $SYS_READ,                %eax
  movl    _READ_BUFFER_FILE(%ebp),  %ebx
  movl    _READ_BUFFER(%ebp),       %ecx
  movl    _READ_BUFFER_SIZE(%ebp),  %edx

  int     $SYS_CALL

  popl    %ebx
  movl    %ebp,   %esp
  popl    %ebp
  ret
