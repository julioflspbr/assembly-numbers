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

bool checkConvertToRealNumber(unsigned long long, unsigned long long);
extern unsigned long long convertToRealNumber(unsigned long long);

bool checkOverflowHandler(const char*);
void checkParseOverflow(enum Exception);

bool checkParseErrorHandler(void);
void checkParseError(enum Exception);
