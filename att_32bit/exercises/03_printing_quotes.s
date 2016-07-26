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

  pushl $quote_prompt
  pushl $input_buffer
  call user_prompt

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

  pushl $author_prompt
  pushl $input_buffer
  call user_prompt

  # TODO: Finish building the quote string


  movl $SYS_EXIT,  %eax         # Exit
  movl $0,         %ebx
  int  $SYS_CALL

#
# User Prompt
#   ret: bytes read in
#
.equ _PROMPT_BUFFER, 8
.equ _PROMPT_TEXT, 12

.type user_prompt, @function

user_prompt:
  pushl   %ebp
  movl    %esp,   %ebp

  pushl _PROMPT_TEXT(%ebp)     # Get the quote prompt string size
  call  str_len
  addl  $4,   %esp

  pushl   %eax                  # Buffer Size
  pushl   _PROMPT_TEXT(%ebp)
  call    writeln
  addl    $8,   %esp

  pushl   $150                  # Get user quote
  pushl   _PROMPT_BUFFER(%ebp)
  call    readln
  addl    $8,   %esp  

  movl  %ebp,   %esp
  popl  %ebp
  ret