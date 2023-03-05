import 'package:intl/intl.dart';

class NumberService {
  static String formatNumber(dynamic number) {
    return NumberFormat('####,###,###,##0.00', 'en_us').format(number);
  }
}
