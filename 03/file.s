#
# SYS CALL Parameters for files:
#
# %eax contains the system call number as usual - 5 in this case.
# %ebx contains a pointer to a string that is the name of the file to open. The
#   string must be terminated with the null character.
# %ecx contains the options used for opening the file. These tell Linux how to open the file. 
#    They can indicate things such as open for reading, open for writing, open for reading and writing, 
#    create if it doesn’t exist, delete the file if it already exists, etc. 
# %edx contains the permissions that are used to open the file. This is used in case the 
#   file has to be created first, so Linux knows what permissions to create the file with. 
#   These are expressed in octal, just like regular UNIX permissions.

.section    .data

### Constants ###

.equ    SYS_OPEN,   5
.equ    SYS_WRITE,  4
.equ    SYS_READ,   3
.equ    SYS_CLOSE,  6
.equ    SYS_EXIT,   1

.equ    O_RDONLY,   0
.equ    O_CREAT_WRONLY_TRUNC,  03101

.equ    STDIN,      0
.equ    STDOUT,     1
.equ    STDERR,     2
.equ    SYSCALL,    0x80
.equ    EOF,        0

.equ    NUM_ARGS,   2

.section    .bss

.equ    BUFFER_SIZE,  500
.lcomm  BUFFER_DATA,  BUFFER_SIZE

.section    .text

# stack positions

.equ    ST_SIZE_RESERVE,    8
.equ    ST_FD_IN,          -4
.equ    ST_FD_OUT,         -8
.equ    ST_ARGC,            0
.equ    ST_ARGV_0,          4 # Name of program
.equ    ST_ARGV_1,          8 # Input File
.equ    ST_ARGV_2,         12 # Output file name

.globl    _start

_start:
  movl    %esp, %ebp
  subl    $ST_SIZE_RESERVE, %esp    # Reserve space for file descriptors on the stack

open_files:
open_fd_in:
  movl    $SYS_OPEN,  %eax          # File Command
  movl    ST_ARGV_1(%ebp),  %ebx    # Input filename into ebx
  movl    $O_RDONLY,  %ecx          # Readonly
  movl    $0666,      %edx
  int     $SYSCALL                  # Call linux

store_fd_in:
  movl    %eax, ST_FD_IN(%ebp)      # Save given file descriptor

open_fd_out:
  movl    $SYS_OPEN,        %eax       # Open the file
  movl    ST_ARGV_2(%ebp),  %ebx       # Output filename
  movl    $O_CREAT_WRONLY_TRUNC,  %ecx # Flags for writing to the file
  movl    $0666,  %edx                 # Mode for new file
  int     $SYSCALL                     # Call linux

store_fd_out:
  movl    %eax, ST_FD_OUT(%ebp)   # Store out file descriptor

read_loop_begin:
  movl    $SYS_READ,    %eax      # Read in a block from the input file
  movl    ST_FD_IN(%ebp),   %ebx  # Get the input file descriptor
  movl    $BUFFER_DATA,     %ecx  # Location to read into
  movl    $BUFFER_SIZE,     %edx  # The size of the buffer
  int     $SYSCALL                # Size of buffer read is returned in %eax
  
  cmpl    $EOF,   %eax            # End of file?
  jle     end_loop                # EOF or error, exit

continue_read_loop:

  # Convert to uppercase

  pushl   $BUFFER_DATA      # Location of the buffer
  pushl   %eax              # Size of the buffer
  call    convert_to_upper
  popl    %eax              # Get the size back
  addl    $4,   %esp        # Restore esp

  # write the block to the output file

  movl    %eax,   %edx           # Size of the buffer
  movl    $SYS_WRITE, %eax
  movl    ST_FD_OUT(%ebp),  %ebx # File to use
  movl    $BUFFER_DATA,     %ecx # Location of the buffer
  int     $SYSCALL
  jmp     read_loop_begin

end_loop:

  # Close files

  movl    $SYS_CLOSE,      %eax
  movl    ST_FD_OUT(%ebp), %ebx
  int     $SYSCALL

  movl    $SYS_CLOSE,     %eax
  movl    ST_FD_IN(%ebp), %ebx
  int     $SYSCALL

  # Exit

  movl    $SYS_EXIT,    %eax
  movl    $0,           %ebx
  int     $SYSCALL

# Convert_to_Upper

.equ    LOWERCASE_A,  'a'
.equ    LOWERCASE_Z,  'z'
.equ    UPPER_CONVERSION, 'A' - 'a'

# Stack
.equ    ST_BUFFER_LEN,  8 # Length of buffer
.equ    ST_BUFFER,     12 # Actual Buffer

convert_to_upper:
  pushl   %ebp
  movl    %esp,   %ebp

  # Set up variables

  movl    ST_BUFFER(%ebp),      %eax
  movl    ST_BUFFER_LEN(%ebp),  %ebx
  movl    $0,   %edi
  cmpl    $0,   %ebx                  # Check if buffer length is 0
  je      end_convert_loop

convert_loop:
  movb    (%eax,%edi,1),  %cl         # Get the current byte
  cmpb    $LOWERCASE_A,   %cl         # Go to next byte unless between a - z
  jl      next_byte
  cmpb    $LOWERCASE_Z,   %cl
  jg      next_byte
  addb    $UPPER_CONVERSION,  %cl     # Convert to uppercase
  movb    %cl,  (%eax,%edi,1)         # Store converted byte

next_byte:
  incl    %edi       # Next byte
  cmpl    %edi, %ebx # Continue unless we've reached the end
  jne     convert_loop

end_convert_loop:
  movl    %ebp,   %esp
  popl    %ebp
  ret
