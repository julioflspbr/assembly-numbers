#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "exception.h"

///
/// Declarations
///
typedef void (*ExceptionHandler)(enum Exception);
extern void setErrorHandler(ExceptionHandler);

bool checkPrintInterger(long long);
extern void printInteger(char*, long long);

bool checkParseInteger(const char*);
extern long long parseInteger(const char*);

bool checkOverflowErrorHandler(void);
void checkParseOverflow(enum Exception);

///
/// Implementations
///
int main() {
  bool success = true;

  success &= checkPrintInterger(20);
  success &= checkPrintInterger(3917220579289287);
  success &= checkPrintInterger(-75);
  success &= checkPrintInterger(0x40);

  success &= checkParseInteger("20");
  success &= checkParseInteger("3917220579289287");
  success &= checkParseInteger("-75");

  success &= checkOverflowErrorHandler();

  if (success) fprintf(stdout, "All tests have passed!\n");
  return success ? 0 : -1;
}

bool checkPrintInterger(long long test) {
  char* output = malloc(64);
  char* expectation = malloc(64);
  sprintf(expectation, "%lld", test);

  printInteger(output, test);

  bool success = (strcmp(output, expectation) == 0);
  if (!success) fprintf(stderr, "printInteger -> output: %s, expected: %s\n", output, expectation);

  free(expectation);
  free(output);
  return success;
}

bool checkParseInteger(const char* test) {
  long long expectation;
  sscanf(test, "%lld", &expectation);

  long long output = parseInteger(test);

  bool success = output == expectation;
  if (!success) fprintf(stderr, "parseInteger -> output: %lld, expected: %lld\n", output, expectation);

  return success;
}

static bool didGetOverflowError = false;
void checkParseOverflow(enum Exception exception) {
  didGetOverflowError = (exception == overflow);
}

bool checkOverflowErrorHandler() {
  setErrorHandler(&checkParseOverflow);
  parseInteger("9223372036854775808");

  if (!didGetOverflowError) fprintf(stderr, "setErrorHandler - should throw an overflow exception, but did not happen\n");
  return didGetOverflowError;
}
