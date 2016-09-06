; Executable name : EATSYSCALL
; Version         : 1.0
; Author          : Benjamin J. Anderson
; Description     : A simple program that makes a system call to display
;                   some text.

SECTION .data
  EatMsg:   db  "Eat at Joe's!", 10
  EatLen:   equ $-EatMsg
SECTION .bss
SECTION .text

global start

start:
  nop
  mov   rax,  0x2000004
  mov   rdi,  1
  mov   rsi,  EatMsg
  mov   rdx,  EatLen
  syscall

  mov   rax,  0x2000001
  mov   rdi,  0
  syscall