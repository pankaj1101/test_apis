import 'package:intl/intl.dart';

class AmountFormatter {
  static String inr(dynamic value, {bool showDecimal = false}) {
    if (value == null) return "-";

    final num? amount = value is num ? value : num.tryParse(value.toString());
    if (amount == null) return "-";

    final format = NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹ ",
      decimalDigits: showDecimal ? 2 : 0,
    );

    return format.format(amount);
  }
}
