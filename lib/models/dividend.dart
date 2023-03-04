import 'dart:convert';

class Dividend {
  String? key;
  DateTime? payDate;
  String? symbol;
  double? amt;
  double? wht;
  double? netAmt;

  Dividend({
    this.key,
    this.payDate,
    this.symbol,
    this.amt,
    this.wht,
    this.netAmt,
  });

  factory Dividend.fromMap(String? key, Map<String, dynamic> data) => Dividend(
        key: key,
        payDate: data['payDate'] == null
            ? null
            : DateTime.parse(data['payDate'] as String),
        symbol: data['symbol'] as String?,
        amt: double.tryParse(data['amt'].toString()),
        wht: double.tryParse(data['wht'].toString()),
        netAmt: double.tryParse(data['netAmt'].toString()),
      );

  Map<String, dynamic> toMap() => {
        'payDate': payDate?.toIso8601String(),
        'symbol': symbol,
        'amt': amt,
        'wht': wht,
        'netAmt': netAmt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Dividend].
  factory Dividend.fromJson(String key, String data) {
    return Dividend.fromMap(key, json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Dividend] to a JSON string.
  String toJson() => json.encode(toMap());
}
