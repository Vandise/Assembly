; ./bin/main > nasm_64bit/uppercaser/v2/output.text < nasm_64bit/uppercaser/v2/input.txt

default rel                       ; Set 64bit RIP-relative addressing

section .bss
  buffer_len  equ   1024          ; Buffer Length
  buffer      resb  buffer_len    ; Text buffer

section .data

section .text
  global  start

start:
  nop

Read:   mov rax,  0x2000003       ; sys_read
        mov rdi,  0
        mov rsi,  buffer
        mov rdx,  buffer_len
        syscall

        mov rbx,  rax             ; sys_read return value
        cmp rax,  0               ; EOF stdin
        je  Exit

        mov rcx,  rbx             ; number of bytes read
        mov rbp,  buffer          ; address of buffer
        dec rbp                   ; shift the buffer point 1 byte out of bounds
                                  ; to point rcx to end of the buffer

Scan:   cmp byte  [rbp+rcx], 61h  ; lowercase 'a'
        jb Next
        cmp byte  [rbp+rcx], 7Ah  ; lowercase 'z'
        ja Next

        sub byte [rbp+rcx], 20h   ; convert to uppercase

Next:   dec rcx
        jnz Scan

Write:  mov rax,  0x2000004       ; sys_write
        mov rdi,  1
        mov rsi,  buffer
        mov rdx,  rbx
        syscall

        jmp Read

Exit:   mov rax,  0x2000001       ; sys_exit
        mov rdi,  0
        syscall