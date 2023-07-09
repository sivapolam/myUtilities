import 'package:intl/intl.dart';

String getFormattedNumber(double number) {
  return NumberFormat.decimalPattern('en_IN').format(number);
}
