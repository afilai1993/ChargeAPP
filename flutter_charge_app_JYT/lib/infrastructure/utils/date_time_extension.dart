const _daysInMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

/// Returns the number of days in the specified month.
///
/// This function assumes the use of the Gregorian calendar or the proleptic
/// Gregorian calendar.
int daysInMonth(int year, int month) =>
    (month == DateTime.february && isLeapYear(year)) ? 29 : _daysInMonth[month];

/// Returns true if [year] is a leap year.
///
/// This implements the Gregorian calendar leap year rules wherein a year is
/// considered to be a leap year if it is divisible by 4, excepting years
/// divisible by 100, but including years divisible by 400.
///
/// This function assumes the use of the Gregorian calendar or the proleptic
/// Gregorian calendar.
bool isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
