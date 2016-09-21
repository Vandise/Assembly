default rel                       ; Set 6bit RIP-relative addressing

section   .bss
  buffer  resb  1

section   .data

section   .text
  global  start

start:
  nop                             ; Make GDB happy

Read:   mov rax,  0x2000003       ; sys_read
        mov rdi,  0               ; standard IO
        mov rsi,  buffer          ; address of the buffer to write to
        mov rdx,  1               ; read in one byte at a time
        syscall

        cmp rax,  0               ; check read return value
        je  Exit                  ; if zero, EOF

        cmp byte [buffer],  61h   ; compare the character to a lowercase 'a'
        jb Write                  ; if below 'a', not lowercase
        cmp byte [buffer],  7Ah   ; test against lowercase 'z'
        ja Write                  ; if above 'z' not lowercase
                                  ; otherwise it's a lowerchase char
        sub byte [buffer],  20h   ; convert to uppercase

Write:  mov rax,  0x2000004       ; sys_write
        mov rdi,  1               ; standard output
        mov rsi,  buffer          ; pass address of the character to write
        mov rdx,  1               ; buffer size
        syscall

        jmp Read
        

Exit:   mov rax,  0x2000001       ; sys_exit
        mov rdi,  0               ; status code - 0
        syscall
        
  