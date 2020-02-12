.include "exception.h"

.bss
  .comm errorHandler, 8           # void (*) (Exception)

.text
  .align 3
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
