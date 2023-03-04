import 'dart:convert';

class Portfolio {
  String? key;
  String? symbol;
  String? category;
  double? volumn;
  double? avgPrice;

  Portfolio({
    this.key,
    this.symbol,
    this.category,
    this.volumn,
    this.avgPrice,
  });

  factory Portfolio.fromMap(String key, Map<String, dynamic> data) => Portfolio(
        key: key,
        symbol: data['symbol'] as String?,
        category: data['category'] as String?,
        volumn: double.tryParse(data['volumn'].toString()),
        avgPrice: double.tryParse(data['avgPrice'].toString()),
      );

  Map<String, dynamic> toMap() => {
        'symbol': symbol,
        'category': category,
        'volumn': volumn,
        'avgPrice': avgPrice,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Portfolio].
  factory Portfolio.fromJson(String key, String data) {
    return Portfolio.fromMap(key, json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Portfolio] to a JSON string.
  String toJson() => json.encode(toMap());
}
