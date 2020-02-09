.include "shared.h"

.text
  .align 3
  .global _printInteger

# printInteger divides an integer by 10 and get the reminder as the digit, and loops until there is no dividend nor remainder.
# the result of this repeated process is the integer reversed (e.g. 12345 would be printed "54321"). At the end, we reverse the string
# to make it look the way it should (e.g. revert "54321" to be "12345")

_printInteger:                        # usage: void printInteger(char*, unsigned long long)
  push  %rbp                          # create the stack frame
  mov   %rsp, %rbp

  mov   %rsi, %rax                    # 2nd param: grab the integer to be printed

  sub   $largestIntegerLength, %rsp   # create the temporary reversed string buffer
  mov   %rsp, %rsi                    # create the temporary reversed string variable

  mov   %rsi, %rcx                    # store the source string's address to later compute the string size
  mov   $10, %r10                     # the divisor (see the introductory comment above)

getNextChar:
  mov   $0, %rdx                      # zero out the reminder
  div   %r10                          # divide the integer

  add   $'0', %dl                     # transform the remainder in character
  mov   %dl, (%rsi)                   # move the character to the source string
  inc   %rsi                          # increment the source string's cursor

  cmp   $0, %rax                      # check whether done computing all the integer characters
  jne   getNextChar                   # repeat the operation

revertString:
  sub   %rsi, %rcx                    # subtract from the current source string's address, thus getting the string length
  neg   %rcx                          # but the operation was done the other way around and the result was negative; so, inverting the signal

moveCharacter:
  dec   %rsi                          # decrement the source string cursor
  mov   (%rsi), %al                   # move the byte in the current position to a temporary 8-bit register
  mov   %al, (%rdi)                   # move the byte from the temporary register to the destination string
  inc   %rdi                          # increment the destination string cursor
  loop  moveCharacter                 # decrement the counter and move the next character if the counter is greater than 0

  movb  $0, (%rdi)                    # append the null-char terminator

wrapUp:
  mov   %rbp, %rsp                    # destroy the stack frame
  pop   %rbp
  ret

