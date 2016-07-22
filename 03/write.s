.section    .data

.equ    SYS_OPEN,   5
.equ    SYS_WRITE,  4
.equ    SYS_READ,   3
.equ    SYS_CLOSE,  6
.equ    SYS_EXIT,   1

.equ    STDIN,      0
.equ    STDOUT,     1
.equ    STDERR,     2
.equ    SYSCALL,    0x80
.equ    EOF,        0

record:
  .ascii  "Ben Anderson\0"
  .rept   15
  .byte   0
  .endr

.section    .text

file_name:
  .ascii  "test.dat\0"

.equ  FILE_DESCRIPTOR,  -4
.equ  RECORD_SIZE,      15

.globl    _start

_start:
  movl    %esp,   %ebp
  subl    $4,     %esp    # file descriptor

  # Open the file

  movl    $SYS_OPEN,    %eax
  movl    $file_name,   %ebx
  movl    $0101,        %ecx
  movl    $0666,        %edx
  int     $SYSCALL

  movl    %eax,         FILE_DESCRIPTOR(%ebp) # Save returned file descriptor

  # stack contents just in case turn the string writing to a function

  pushl   FILE_DESCRIPTOR(%ebp)
  pushl   $record

  call  write_string
  addl    $8,   %esp

  # Close the file

  movl    $SYS_CLOSE,             %eax
  movl    FILE_DESCRIPTOR(%ebp),  %ebx
  int     $SYSCALL

  # Exit

  movl    $SYS_EXIT,    %eax
  movl    $0,           %ebx
  int     $SYSCALL


# write_string:
#   Writes a string to a file

.equ  WRITE_BUFFER,      8
.equ  FILE_DES,          12

.type   write_string, @function
write_string:
  pushl   %ebp
  movl    %esp,   %ebp
  pushl   %ebx

  movl    $SYS_WRITE,             %eax
  movl    FILE_DES(%ebp),         %ebx
  movl    WRITE_BUFFER(%ebp),     %ecx
  movl    $RECORD_SIZE,           %edx
  int     $SYSCALL

  popl    %ebx

  movl    %ebp,   %esp
  popl    %ebp
  ret