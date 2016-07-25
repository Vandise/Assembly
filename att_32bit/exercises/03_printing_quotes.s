.include  "./common/linux.s"
.include  "./common/io.s"
.include  "./common/string.s"
.include  "./common/integer.s"

.section    .data

quote_prompt:
  .ascii "What is the quote? \0"

author_prompt:
  .ascii "Who said it? \0"

input_buffer:
  .space 150

output_buffer:
  .space 250

.section    .text

  .equ  _CHAR_COUNT, -4

.globl  _start

_start:

  movl  %esp,   %ebp
  subl  $4,     %esp

  #
  # TODO: Make a function for the user-input prompting
  #

  pushl $quote_prompt           # Get the quote prompt string size
  call  str_len
  addl  $4,   %esp

  pushl   %eax                  # Buffer Size
  pushl   $quote_prompt
  call    writeln
  addl    $8,   %esp

  pushl   $150                   # Get user quote
  pushl   $input_buffer
  call    readln
  addl    $8,   %esp

  #subl    $1,     %eax                # Exclude the null value in count
  movl    %eax,   _CHAR_COUNT(%ebp)    # Input character length

  movl    $input_buffer,      %eax     # Replace the new-line char with a null char
  movl    _CHAR_COUNT(%ebp),  %edi
  movb    $0,                 %cl
  movb    %cl,                (%eax,%edi,1)


  # TODO: merge the input and output buffers


  movb    $0, %al                      # Empty the buffer
  xorb    %al, input_buffer
  leal    input_buffer, %edi
  movl    $150, %ecx
  cld
  rep stosb

  #
  # See above TODO
  #

  pushl $author_prompt                 # Get the author prompt string size
  call  str_len
  addl  $4,   %esp

  pushl   %eax                         # Display the prompt
  pushl   $author_prompt
  call    writeln
  addl    $8,   %esp

  pushl   $150                         # Get the author
  pushl   $input_buffer
  call    readln
  addl    $8,   %esp


  # TODO: Finish building the quote string


  movl $SYS_EXIT,  %eax         # Exit
  movl $0,         %ebx
  int  $SYS_CALL
