.include "shared.h"

.data
  .set bias, 10000000000000000000
.text
  .align 3
  .global _printReal
# In the real-numbers realm, the left-most zeroes matter, and the rightmost are meaningless.
# Howerver, when working with integer, the system works the other way around (as it should).
# Thus, a leading bit 1 must be appended to the beginning of the number, so that the routine understands
# how many significant zeroes there are in the beginning.
_printReal:                                   # usage: unsigned long long printReal(unsigned long long)
  bsr   %rdi, %rcx                            # eliminate the leading zeroes
  sub   $(largestBitLength - 1), %rcx
  neg   %rcx
  shl   %cl, %rdi

  mov   %rdi, %r8                             # load the binary to be converted
  mov   $1, %r9                               # the current power of two
  mov   $0, %r10                              # zeroise the final result accumulator
  mov   $(largestBitLength - 2), %rcx         # load how many bits will be calculated, and eliminate the leading 1
                                              # (see comment above the method label)
checkNextBit:
  shl   %r9                                   # calculate the next power of two
  bt    %rcx, %r8                             # if the bit is set
  jc    calculateBit                          # then calculate bit
  loop  checkNextBit                          # else go to the next bit
  jmp   wrapUp                                # if there are no bits left, wrap it up

calculateBit:
  mov   $0, %rdx                              # clear the most significant bits of the dividend
  mov   $bias, %rax                           # load the bias as the dividend
  idiv  %r9                                   # calculate the value of the current bit by dividinb by the current power of two
  add   %rax, %r10                            # and accumulate it
  loop  checkNextBit                          # go to the next bit

wrapUp:
  mov   %r10, %rax                            # return the calculated value
  ret

