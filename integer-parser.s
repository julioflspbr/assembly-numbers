.text
  .align 4
  .global _parseInteger

_parseInteger:            # usage: long long parseInteger(const char*)
  mov   $0, %rcx

findStringLength:
  cmpb  $0, (%rdi)        # the last char is null-char
  je    parse             # if null-char found, proceed with parsing the string
  inc   %rcx              # else, increment the string size, we've not reached its end yet
  inc   %rdi
  jmp   findStringLength  # do it all over again, until the null-char is found

parse:
  mov   $0, %r8           # initialise the accumulator
  mov   $1, %r9           # initialise the 10-multiplier

getDigit:
  dec   %rdi              # move the string cursor to its last character
  mov   $0, %rax          # clear out multiplication result operands
  mov   $0, %rdx
  mov   (%rdi), %al       # load the character
  sub   $'0', %al         # and transform it to integer
  mul   %r9               # multiply by the 10-multiplier
  add   %rax, %r8         # accumulate

  mov   $10, %rax         # prepare multiplication operands to build the new 10-multiplier
  mov   $0, %rdx
  mul   %r9               # multiply the 10-multiplier by ten
  mov   %rax, %r9         # make the multiplication-by-10 result the new 10-multiplier

  loop  getDigit          # go get the next digit until counter is 0

  mov %r8, %rax
  ret
