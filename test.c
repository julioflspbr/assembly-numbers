#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

///
/// Declarations
///
bool checkPrintInterger(long long test);
extern void printInteger(char*, long long);
bool testPrintInteger(void);

///
/// Implementations
///
int main() {
  bool success = true;

  success &= testPrintInteger();

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

bool testPrintInteger() {
  bool success = true;

  success &= checkPrintInterger(20);
  success &= checkPrintInterger(3917220579289287);
  success &= checkPrintInterger(0x40);

  if (success) fprintf(stdout, "All tests passed!\n");
  return success;
}
