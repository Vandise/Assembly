SECTION .data
  hello_msg:     db    'Hello World!'
  hello_msg_len: equ   $-hello_msg

SECTION .text
  STDOUT:    equ   1
  SYS_WRITE: equ   4
  SYS_EXIT:  equ   0
  SYS_CALL:  equ   80h

global _start

_start:
  mov   edx,  hello_msg_len         ; 13 byte string
  mov   ecx,  hello_msg
  mov   ebx,  $STDOUT
  mov   eax,  $SYS_WRITE
  int   $SYS_CALL

  mov   ebx,  0
  mov   eax,  $STDOUT
  int   $SYS_CALL
  
