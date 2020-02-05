.include "shared.h"

.text
  .align 4
  .global _printInteger

# printInteger divides an integer by 10 and get the reminder as the digit, and loops until there is no dividend nor remainder.
# the result of this repeated process is the integer reversed (e.g. 12345 would be printed "54321"). At the end, we reverse the string
# to make it look the way it should (e.g. revert "54321" to be "12345")

_printInteger:                        # usage: void printInteger(char*, long long)
  push  %rbp                          # create the stack frame
  mov   %rsp, %rbp
                                      # 1st param: no need to grab because we will already be using %rdi to store the final string
  mov   %rsi, %rax                    # 2nd param: grab the integer to be printed
  sub   $largestIntegerLength, %rsp   # create the result string buffer
  mov   %rsp, %rsi                    # get the result string address

  mov   %rsi, %rcx                    # store the source string's address to later compute the string size
  mov   $10, %r10                     # the divisor (see the introductory comment above)

getNextChar:
  cqo                                 # extend the dividend's sign bit
  idiv  %r10                          # divide the integer
  mov   %rax, %r8

  lahf                                # store the sign to later on append '-' to the string
  mov   %rax, %r9

  mov   %rdx, %rax                    # remove the sign of the remainder
  cqo
  xor   %rdx, %rax
  sub   %rdx, %rax
  add   $'0', %al                     # transform the remainder in character
  mov   %al, (%rsi)                   # move the character to the source string
  inc   %rsi                          # increment the source string's cursor

  mov   %r8, %rax
  cmp   $0, %rax                      # check whether done computing all the integer characters
  jne   getNextChar                   # repeat the operation

minusSign:
  mov   %r9, %rax                     # restore the sign to append the '-'in case it is negative
  sahf
  jns   revertString                  # in case the number is not negative, it is ready to revert the string

  movb  $'-', (%rsi)                  # append the minus sign to the reversed string
  inc   %rsi

revertString:
  sub   %rsi, %rcx                    # subtract from the current source string's address, thus getting the string length
  neg   %rcx                          # but the operation was done the other way around and the result was negative; so, inverting the signal

moveCharacter:
  dec   %rsi                          # decrement the source string cursor
  mov   (%rsi), %al                   # move the byte in the current position to a temporary 8-bit register
  mov   %al, (%rdi)                   # move the byte from the temporary register to the destination string
  inc   %rdi                          # increment the destination string cursor
  loop  moveCharacter                 # decrement the counter and move the next character if the counter is greater than 0

  movb  $0, (%rdi)

wrapUp:
  mov   %rbp, %rsp                    # destroy the stack frame
  pop   %rbp
  ret

