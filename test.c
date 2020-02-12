#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "test.h"

int main() {
  bool success = true;

  success &= checkPrintInterger(20);
  success &= checkPrintInterger(3917220579289287);
  success &= checkPrintInterger(0x40);

  success &= checkParseInteger("20");
  success &= checkParseInteger("3917220579289287");

  success &= checkOverflowHandler("9223372036854775808");
  success &= checkOverflowHandler("10000000000000000000");
  success &= checkParseErrorHandler();

  success &= checkParseReal(27, 0b0100010100011110101110000101000111101011100001010001111010111);
  success &= checkParseReal(2923948573939374732, 0b0100101011011010011000111010111000000110100010100010000111110001);
  success &= checkParseReal(125, 0b001);

  success &= checkPrintReal(0b10100010100011110101110000101000111101011100001010001111010111, 0.27f);
  success &= checkPrintReal(0b1010010101101101001100011101011100000011010001010001000011111, 0.2923948573939374732f);
  success &= checkPrintReal(0b1001, 0.125f);

  if (success) fprintf(stdout, "All tests have passed!\n");
  return success ? 0 : -1;
}

bool checkPrintInterger(unsigned long long test) {
  char* output = malloc(64);
  char* expectation = malloc(64);
  sprintf(expectation, "%llu", test);

  printInteger(output, test);

  bool success = (strcmp(output, expectation) == 0);
  if (!success) fprintf(stderr, "printInteger -> output: %s, expected: %s\n", output, expectation);

  free(expectation);
  free(output);
  return success;
}

bool checkParseInteger(const char* test) {
  unsigned long long expectation;
  sscanf(test, "%llu", &expectation);

  unsigned long long output = parseInteger(test);

  bool success = output == expectation;
  if (!success) fprintf(stderr, "parseInteger -> output: %llu, expected: %llu\n", output, expectation);

  return success;
}

bool checkParseReal(unsigned long long convert, unsigned long long expectation) {
  unsigned long long output = parseReal(convert);
  bool success = (output == expectation);
  if (!success) fprintf(stderr, "parseReal -> output: %llx, expected: %llx\n", output, expectation);
  return success;
}

bool checkPrintReal(unsigned long long convert, float expectation) {
  unsigned long long integerOutput = printReal(convert);
  float floatOutput = integerOutput / 1e19f;
  bool success = (floatOutput == expectation);
  if (!success) fprintf(stderr, "printReal -> floatOutput: %f, expected: %f\n", floatOutput, expectation);
  return success;
}

static bool didGetOverflowError = false;
void checkParseOverflow(enum Exception exception) {
  didGetOverflowError = (exception == overflow);
}

bool checkOverflowHandler(const char* bigValue) {
  didGetOverflowError = false;
  setErrorHandler(&checkParseOverflow);
  parseInteger(bigValue);

  if (!didGetOverflowError) fprintf(stderr, "checkOverflowHandler - the number %s should throw an overflow exception, but did not happen\n", bigValue);
  return didGetOverflowError;
}

static bool didGetParseError = false;
void checkParseError(enum Exception exception) {
  didGetParseError = (exception == parse);
}

bool checkParseErrorHandler() {
  setErrorHandler(&checkParseError);

  parseInteger("92e8");
  if (!didGetParseError) fprintf(stderr, "checkParseError - \"e\" should be considered a strange character\n");

  parseInteger("92,8");
  if (!didGetParseError) fprintf(stderr, "checkParseError - commas should not be allowed\n");

  parseInteger("92.8");
  if (!didGetParseError) fprintf(stderr, "checkParseError - integers should not contain decimal digit\n");

    return didGetParseError;
}
