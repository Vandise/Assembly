.include "./common/linux.s"
.include "./common/string.s"

.section .data

input_msg:
  .string "What is your name? "
input_msg_end:
  .equ  input_msg_len, input_msg_end - input_msg

greeting:
  .string "Hello "

input_buffer:
  .space 25

buf:
  .space 50

.section .text

.globl _start

_start:

  movl  %esp, %ebp

  movl  $SYS_WRITE,     %eax    # Prompt the user for their name
  movl  $1,             %ebx
  movl  $input_msg,     %ecx
  movl  $input_msg_len, %edx

  int   $SYS_CALL

  movl  $SYS_READ,     %eax     # Get the users name
  movl  $SYS_CONSOLE,  %ebx
  movl  $input_buffer, %ecx
  movl  $25,           %edx

  int   $SYS_CALL

  pushl $buf                    # Concat the greeting with the users name
  pushl $input_buffer
  pushl $greeting

  call str_concat
  addl  $12, %esp

  pushl $buf                    # Get the new buffer size
  call str_len
  addl  $4, %esp
  
  movl  %eax, %edx              # Save in edx for output call
  
  movl $4,    %eax              # Display the output
  movl $1,    %ebx
  movl $buf,  %ecx
  int  $SYS_CALL

  movl $SYS_EXIT,  %eax                # Exit
  movl $0,         %ebx
  int  $SYS_CALL
