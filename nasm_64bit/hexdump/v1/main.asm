; ./bin/main > nasm_64bit/hexdump/v1/output.txt < nasm_64bit/hexdump/v1/input.txt

default rel                        ; Set 64bit RIP-relative addressing

section .bss
  buffer_len  equ   16             ; read in 16 bits at a time
  buffer      resb  buffer_len     ; the input buffer

section .data
  hex_str  db   " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
  hex_len  equ  $-hex_str
  digits   db   "0123456789ABCDEF"

section .text
  global  start

start:
  nop

Read: mov rax,  0x2000003           ; sys_read
      mov rdi,  0
      mov rsi,  buffer
      mov rdx,  buffer_len
      syscall

      mov rbp,  rax                 ; store bytes read in rbp
      cmp rax,  0                   ; check for EOF
      je  Exit

      mov rsi,  buffer              ; place buffer addr in rsi
      mov rdi,  hex_str             ; place line str addr in rdi
      xor rcx,  rcx                 ; clear out rcx ptr to 0

Scan: xor rax,  rax                 ; clear rax to 0

                                    ; Start calculation of the offset into the hex string, (rcx * 3)
      mov rdx,  rcx                 ; Copy the pointer into line string into rdx
      lea rdx,  [rdx*2+rdx]         ; Get a character from the buffer and put it in both eax and ebx:
      mov al, byte [rsi+rcx]	      ; Put a byte from the input buffer into al
      mov rbx,  rax		              ; Duplicate the byte in bl for second nybble

      lea rdi,  [digits]            ; load the addresses of the digits and
      lea rsi,  [hex_str]           ; hex str to 64bit values

                                    ; Look up low nybble character and insert it into the string
      and al,   0Fh                 ; Mask out the first four bytes 0F = 00001111
      mov al, byte [rdi+rax]        ; Look up the char equivalent of nybble
      mov byte [rsi+rdx+2], al      ; Write the char equivalent to line string

                                    ; Look up high nybble character and insert it into the string
      shr bl,   4		                ; Shift high 4 bits of char into low 4 bits
      mov bl,   byte [rdi+rbx]      ; Look up char equivalent of nybble
      mov byte [rsi+rdx+1], bl      ; Write the char equivalent to line string

                                    ; Bump the buffer pointer to the next character and see if we're done
      inc rcx                       ; inc line string ptr
      cmp rcx,  rbp	                ; Compare to the number of characters in the buffer
      jna Scan	                    ; Loop back if rcx is <= number of chars in buffer

                                    ; Write the line of hexadecimal values to stdout
      mov rax,  0x2000004           ; sys_write
      mov rdi,  1
      mov rsi,  hex_str
      mov rdx,  hex_len
      syscall      

      jmp Read

Exit: mov rax,  0x2000001           ; sys_exit
      mov rdi,  0
      syscall