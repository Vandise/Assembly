; Executable name : main
; Version         : 1.0
; Author          : Benjamin J. Anderson
; Description     : Transform a string to lower-case

SECTION .data
  Snippet   db    "KANGAROO"
SECTION .bss
SECTION .text

global start

start:
  nop
  mov rbx, Snippet
  mov rax, 8
cycle:
  add byte [rbx], 32        ; Add 32 bytes to start of address rbx 
  inc rbx                   ; Increment address at rbx
  dec rax
  jnz cycle

  mov   rax,  0x2000004
  mov   rdi,  1
  mov   rsi,  Snippet
  mov   rdx,  8
  syscall

  mov   rax,  0x2000001
  mov   rdi,  0
  syscall