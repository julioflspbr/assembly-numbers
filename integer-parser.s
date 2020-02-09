.include "shared.h"
.include "exception.h"

.text
  .align 3
  .global _parseInteger

_parseInteger:                        # usage: unsigned long long parseInteger(const char*)
  mov   $0, %rax                      # byte comparison, stop when find the null-character
  cld                                 # scan string forward
  mov   $largestIntegerLength, %rcx
  repne scasb                         # increment the string cursor until find the null-character
  jne   overflowError                 # if haven't found the null-character, then it means that the string is too long
  dec   %rdi                          # cursor was past the end
  sub   $largestIntegerLength, %rcx   # calculate the string size
  neg   %rcx
  dec   %rcx

  mov   $0, %r8                       # initialise the accumulator
  mov   $1, %r9                       # initialise the 10-multiplier

getDigit:
  mov   $0, %rax                      # clear out multiplication result operands
  mov   $0, %rdx
  dec   %rdi                          # rewind the cursor one step
  mov   (%rdi), %al                   # load the character

  cmp   $'0', %al                     # if smaller than char '0' throw parse error
  jb    parseError
  cmp   $'9', %al                     # if greater than char '9' throw parse error
  ja    parseError

  sub   $'0', %al                     # and transform it to integer
  mul   %r9                           # multiply by the 10-multiplier
  add   %rax, %r8                     # accumulate
  jo    overflowError                 # halt and throw overflow error

  mov   $10, %rax                     # prepare multiplication operands to build the new 10-multiplier
  mov   $0, %rdx
  mul   %r9                           # multiply the 10-multiplier by ten
  mov   %rax, %r9                     # make the multiplication-by-10 result the new 10-multiplier

  loop  getDigit                      # go get the next digit until counter is 0
  jmp   return

return:
  mov %r8, %rax
  ret

overflowError:
  mov   $overflow, %rdi
  call  _throw
  ret

parseError:
  mov   $parse, %rdi
  call  _throw
  ret
