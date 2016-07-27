.include  "./common/linux.s"
.include  "./common/io.s"
.include  "./common/string.s"
.include  "./common/integer.s"

.section    .data

quote_prompt:
  .ascii "What is the quote? \0"

author_prompt:
  .ascii "Who said it? \0"

quote_buffer:
  .space 150

author_buffer:
  .space 50

output_buffer:
  .space 250

fragment_1:
  .ascii " says \0"

.section    .text

  .equ  _CHAR_COUNT, -4

.globl  _start

_start:

  movl  %esp,   %ebp
  subl  $4,     %esp

  pushl $quote_prompt
  pushl $quote_buffer
  call user_prompt

  addl  $8,   %esp

  subl    $1,     %eax                 # Exclude the null value in count
  movl    %eax,   _CHAR_COUNT(%ebp)    # Input character length

  movl    $quote_buffer,      %eax     # Replace the new-line char with a null char
  movl    _CHAR_COUNT(%ebp),  %edi
  movb    $0,                (%eax,%edi,)

  pushl $author_prompt
  pushl $author_buffer
  call user_prompt

  addl  $8,   %esp

  subl    $1,     %eax 
  movl  %eax,   _CHAR_COUNT(%ebp)

  movl    $author_buffer,     %eax
  movl    _CHAR_COUNT(%ebp),  %edi
  movb    $0,                (%eax,%edi,1)

  pushl $output_buffer                # Start building the string <person> says
  pushl $fragment_1
  pushl $author_buffer
  call  str_concat
  addl  $12,   %esp

  pushl $output_buffer                # Get the buffer size
  call  str_len
  addl  $4,   %esp

  movl  %eax,           %edi          # Push a quotation mark to the buffer
  movl  $output_buffer, %eax
  movb  $34,            (%eax,%edi,)  # 34 = ascii "
  addl  $1, %edi

  pushl $output_buffer                # <person> says "<quote>
  pushl $quote_buffer
  pushl $output_buffer
  call  str_concat
  addl  $12,   %esp    

  pushl $output_buffer                # TODO: make str_concat return buffer size!
  call  str_len

  movl  %eax,           %edi          # <person> says "<quote>"
  movl  $output_buffer, %eax
  movb  $34,            (%eax,%edi,)
  addl  $1, %edi

  pushl %edi                          # Print out the quote
  pushl $output_buffer
  call  writeln

  addl  $8,   %esp

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
