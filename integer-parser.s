.include "exception.s"

.text
  .align 4
  .global _parseInteger

_parseInteger:            # usage: long long parseInteger(const char*)
  mov   %rdi, %r8         # store string address position 0
  mov   $0, %rax          # byte comparison, stop when find the null-character
  cld                     # scan string forward
  repne scasb             # increment the string cursor until find the null-character
  dec   %rdi              # cursor was past the end
  mov   %rdi, %rcx        # calculate the string size
  sub   %r8, %rcx

  mov   $0, %r8           # initialise the accumulator
  mov   $1, %r9           # initialise the 10-multiplier

getDigit:
  dec   %rdi              # move the string cursor to its last character
  cmpb  $'-', (%rdi)      # if minus sign, invert signal and return
  je    invertSign

  mov   $0, %rax          # clear out multiplication result operands
  mov   $0, %rdx
  mov   (%rdi), %al       # load the character
  sub   $'0', %al         # and transform it to integer
  imul  %r9               # multiply by the 10-multiplier
  add   %rax, %r8         # accumulate

  seto  %al               # check overflow
  cmp   $1, %al           # if there is overflow
  je    overflowCheck     # halt and throw overflow error

  mov   $10, %rax         # prepare multiplication operands to build the new 10-multiplier
  mov   $0, %rdx
  mul   %r9               # multiply the 10-multiplier by ten
  mov   %rax, %r9         # make the multiplication-by-10 result the new 10-multiplier

  loop  getDigit          # go get the next digit until counter is 0
  jmp   return

invertSign:
  neg %r8
  jmp return

overflowCheck:
  mov   $overflow, %rdi
  call  _throw

return:
  mov %r8, %rax
  ret
