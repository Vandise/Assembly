.include "linux.s"
.include "file.s"

.section    .data

.section    .bss
.lcomm  record_buffer,  15

.section    .text

file_name:
  .ascii  "test.dat\0"

input_file:
  .ascii "testdata.dat\0"

.equ  FILE_DESCRIPTOR,  -4
.equ  INPUT_FILE_DESC,  -8
.equ  RECORD_SIZE,      15

.globl    _start

_start:
  movl    %esp,   %ebp
  subl    $8,     %esp    # file descriptor

  # Open the write file

  pushl    $0666
  pushl    $0101
  pushl    $file_name

  call     open_file
  addl     $12,   %esp

  movl    %eax,         FILE_DESCRIPTOR(%ebp) # Save returned file descriptor

  # Open input file

  pushl   $0666
  pushl   $0
  pushl   $input_file

  call    open_file
  addl    $12,    %esp

  movl    %eax,         INPUT_FILE_DESC(%ebp)

  # Read the input buffer

read_file_loop:
  pushl   $RECORD_SIZE
  pushl   $record_buffer
  pushl   INPUT_FILE_DESC(%ebp)

  call    read_buffer
  addl    $12,    %esp

  cmpl    $RECORD_SIZE,   %eax
  jne     end_read_loop

  # write the input string

  pushl   INPUT_FILE_DESC(%ebp)
  pushl   $record_buffer

  call  write_buffer
  addl    $8,   %esp

  jmp   read_file_loop

end_read_loop:

  # Close the files

  pushl   FILE_DESCRIPTOR(%ebp)

  call    close_file
  addl    $4,   %esp

  pushl   INPUT_FILE_DESC(%ebp)

  call    close_file
  addl    $4,   %esp

  # Exit

  movl    $SYS_EXIT,    %eax
  movl    $0,           %ebx
  int     $SYS_CALL


# write_string:
#   Writes a string to a file

.equ  WRITE_BUFFER,      8
.equ  FILE_DES,          12

.type   write_buffer, @function
write_buffer:
  pushl   %ebp
  movl    %esp,   %ebp
  pushl   %ebx

  movl    $SYS_WRITE,             %eax
  movl    FILE_DES(%ebp),         %ebx
  movl    WRITE_BUFFER(%ebp),     %ecx
  movl    $RECORD_SIZE,           %edx
  int     $SYS_CALL

  popl    %ebx

  movl    %ebp,   %esp
  popl    %ebp
  ret
