.include "exception.s"

.data
  # enum Exception
  .global   notANumber
  .global   minusInfinite
  .global   plusInfinite
  .global   notANumber
  .global   overflow
  .global   underflow
  .global   divisionByZero
  .global   parse
  # end enum Exception

.bss
  .comm errorHandler, 8           # void (*) (Exception)

.text
  .global _throw
  .global _setErrorHandler

_throw:                           # usage: void throw(Exception)
  cmpq  $0, errorHandler(%rip)    # if errorHandler == 0
  je    return                    # return
  call  *errorHandler(%rip)       # else invoke the error handler

return:
  ret

_setErrorHandler:
  mov   %rdi, errorHandler(%rip)
  ret
