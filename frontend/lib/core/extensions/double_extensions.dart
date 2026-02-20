import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  /// Format as Malaysian Ringgit currency
  String toRinggit({bool showDecimals = true}) {
    final formatter = NumberFormat.currency(
      locale: 'ms_MY',
      symbol: 'RM',
      decimalDigits: showDecimals ? 2 : 0,
    );
    return formatter.format(this);
  }

  /// Format as percentage
  String toPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format with thousand separators
  String toFormatted({int decimals = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimals}', 'en_US');
    return formatter.format(this);
  }
}
