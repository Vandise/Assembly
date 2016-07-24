.include  "./common/linux.s"
.include  "./common/io.s"
.include  "./common/string.s"
.include  "./common/integer.s"

.section    .data

greeting_prompt:
  .ascii  "What is the input string? "

temp_buffer:
  .space 5

input_buffer:
  .space  25

output_buffer:
  .space  50

fragment_1:
  .string  " has "

fragment_2:
  .string " characters.\n"

.section    .text

.equ  _CHAR_COUNT, -4

.globl _start

_start:

  movl  %esp, %ebp
  subl  $4,   %esp          # Local variable for char count

  pushl $greeting_prompt    # Get the buffer size dynamically
  call  str_len
  addl  $4,   %esp

  pushl   %eax              # Buffer Size
  pushl   $greeting_prompt
  call    writeln
  addl    $8,   %esp

  pushl   $25               # Get user input
  pushl   $input_buffer
  call    readln
  addl    $8,   %esp

  subl    $1,     %eax                # Exclude the null value in count
  movl    %eax,   _CHAR_COUNT(%ebp)   # Input character length

  movl    $input_buffer,      %eax    # Replace the new-line char with a null char
  movl    _CHAR_COUNT(%ebp),  %edi
  movb    $0,                 %cl
  movb    %cl,                (%eax,%edi,1)

  pushl   $output_buffer               # Build the string <name> has ..
  pushl   $fragment_1
  pushl   $input_buffer
  call    str_concat
  addl    $12,  %esp

  pushl   $temp_buffer                # Convert integer to string
  pushl   _CHAR_COUNT(%ebp)
  call    int_to_s
  addl    $8,   %esp

  pushl   $output_buffer              # Add the character count <name> has <characters>
  pushl   $temp_buffer
  pushl   $output_buffer
  call    str_concat
  addl    $12,  %esp 

  pushl   $output_buffer              # Build the string <name> has <characters> characters.
  pushl   $fragment_2
  pushl   $output_buffer
  call    str_concat
  addl    $12,  %esp

  pushl $output_buffer                 # Get the message length
  call  str_len
  addl  $4,   %esp  

  pushl   %eax                         # Output the buffer
  pushl   $output_buffer
  call    writeln
  addl    $8,   %esp

  movl $SYS_EXIT,  %eax                # Exit
  movl $0,         %ebx
  int  $SYS_CALL
