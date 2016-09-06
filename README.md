# Assembly
Some assembler flavors and examples. Exercises are taken from the book <a href="https://pragprog.com/book/bhwb/exercises-for-programmers"> Exercises for Programmers </a>. I highly recommend it if you're learning a technology you've had <strong>*little to no exposure*</strong> to.

## How to use
Most of these projects can be compiled by editing the makefile provided to your architecture and assembler (GAS and NASM are the only two provided). By default the makefile is set to nasm for MacOSX.
```
#Compiler and Linker
ASM          := nasm
LD           := ld

...

#---------------------------------------------------------------------------------
# EDIT ARCHITECTURE AND FLAGS HERE
#---------------------------------------------------------------------------------

#Flags, Libraries and Includes
ASM_FLAGS      := -f macho64 -g
LINK_FLAGS     := -macosx_version_min 10.7.0 -lSystem
```
You can compile individual programs by running the command:
```
$ make SRCDIR=some/program/directory
```
It outputs your executable as bin/main
