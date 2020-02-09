enum Exception {
  notANumber      = 0,
  minusInfinite   = 1,
  plusInfinite    = 2,
  overflow        = 3,
  underflow       = 4,
  divisionByZero  = 5,
  parse           = 6
};

typedef void (*ExceptionHandler)(enum Exception);
extern void setErrorHandler(ExceptionHandler);

bool checkPrintInterger(unsigned long long);
extern void printInteger(char*, unsigned long long);

bool checkParseInteger(const char*);
extern unsigned long long parseInteger(const char*);

bool checkParseReal(unsigned long long, unsigned long long);
extern unsigned long long parseReal(unsigned long long);

bool checkPrintReal(unsigned long long, float);
extern unsigned long long printReal(unsigned long long);

bool checkOverflowHandler(const char*);
void checkParseOverflow(enum Exception);

bool checkParseErrorHandler(void);
void checkParseError(enum Exception);
