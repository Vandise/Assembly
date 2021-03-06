# Common Linux Definitions

## System Call Numbers

.equ    SYS_CONSOLE, 0
.equ    SYS_EXIT,    1
.equ    SYS_READ,    3
.equ    SYS_WRITE,   4
.equ    SYS_OPEN,    5
.equ    SYS_CLOSE,   6
.equ    SYS_BRK,     45

## System Call

.equ    SYS_CALL,   0x80

## File Descriptors

.equ    STDIN,    0
.equ    STDOUT,   1
.equ    STDERR,   2

## File Status Codes

.equ    EOF,      0
