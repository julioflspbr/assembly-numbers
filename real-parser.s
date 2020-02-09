.include "shared.h"

.text
  .align 3
  .global _parseReal

_parseReal:                         # usage: unsigned long long parseReal(unsigned long long)
  mov   %rdi, %rax                  # get the number to divide
  mov   $10, %rbx                   # the divisor to find the decimal digits
  mov   $0, %rcx                    # zero out the counter before couting the digits up

digitCount:
  cmp   $0, %rax                    # if the division results in 0
  je    startMakingBias             # go ahead and make the bias
  mov   $0, %rdx                    # zero out the high bits of the dividend
  div   %rbx                        # divide by ten to get the digit
  inc   %rcx                        # else count up the digit count
  jmp   digitCount                  # look for the next digit

startMakingBias:
  mov   $1, %rax                    # initialise the first bias multiplicand
  mov   $0, %rdx                    # clear the high bits of the multiplicand
  mov   $10, %rbx                   # initialise the second bias multiplicand

makeBias:
  mul   %rbx                        # calculate the bias
  loop  makeBias                    # do it again until reach the number of digits
  mov   %rax, %r8                   # store the bias

startMakingBits:
  mov   %rdi, %rax                  # get the number to multiply
  mov   $2, %rbx                    # the multiplicand to find binary digits (bits)
  mov   $largestBitLength, %rcx     # define the max loop/bit count
  mov   $0, %r10                    # initialise what is going to be the final result

makeBit:
  mul   %rbx                        # multiply to find out the bit
  jc    bit1                        # if the result is bigger than 64-bits, append bit 1
  cmp   %r8, %rax                   # else if the result is greater than or equal to the bias
  jae   bit1                        # append bit 1
  cmp   $0, %rax                    # else if the result is equal to 0
  je    stripRightmostZeroes        # then there are no bits left
  loop  makeBit                     # look for the next bit
  jmp   stripRightmostZeroes        # no loop means all bits are computed

bit1:
  mov   %rcx, %r9                   # get the counter
  dec   %r9                         # since it is a 0-based index
  bts   %r9, %r10                   # set the desired bit
  mov   $0, %rdx                    # zero out high bits of the multiplication
  sub   %r8, %rax                   # subtract the bias from the result
  loop  makeBit                     # look for the next bit

stripRightmostZeroes:
  bsf   %r10, %rcx                  # find out how many zeroes are at the right
  shr   %cl, %r10                   # strip the rightmost zeroes

done:
  mov   %r10, %rax                  # return the result
  ret
