import 'package:money_formatter/money_formatter.dart';

extension MoneyExtensions on int {
  String parseCurrency() {
    MoneyFormatter fmf = MoneyFormatter(
        amount: toDouble(),
        settings: MoneyFormatterSettings(
            symbol: '₦',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.short));
    return fmf.output.symbolOnLeft;
  }
}

extension DoubleMoney on double {
  String parseCurrency() {
    MoneyFormatter fmf = MoneyFormatter(
        amount: this,
        settings: MoneyFormatterSettings(
            symbol: '₦',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 1,
            compactFormatType: CompactFormatType.short));
    return fmf.output.symbolOnLeft;
  }
}

extension NumMoney on num {
  String parseCurrency() {
    MoneyFormatter fmf = MoneyFormatter(
        amount: toDouble(),
        settings: MoneyFormatterSettings(
            symbol: '₦',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 1,
            compactFormatType: CompactFormatType.short));
    return fmf.output.symbolOnLeft;
  }
}

extension CurrencyString on String {
  String parseCurrency() {
    final isValidDoule = double.tryParse(this);
    if (isValidDoule == null) return "0";
    MoneyFormatter fmf = MoneyFormatter(
        amount: isValidDoule,
        settings: MoneyFormatterSettings(
            symbol: '₦',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.short));
    return fmf.output.symbolOnLeft;
  }
}
