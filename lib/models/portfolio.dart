import 'dart:convert';

class Portfolio {
  String? key;
  String? symbol;
  String? nameTh;
  String? nameEn;
  String? category;
  double? volumn;
  double? avgPrice;

  Portfolio({
    this.key,
    this.symbol,
    this.nameTh,
    this.nameEn,
    this.category,
    this.volumn,
    this.avgPrice,
  });

  factory Portfolio.fromMap(String key, Map<String, dynamic> data) => Portfolio(
        key: key,
        symbol: data['symbol'] as String?,
        nameTh: data['nameTh'] as String?,
        nameEn: data['nameEn'] as String?,
        category: data['category'] as String?,
        volumn: double.tryParse(data['volumn'].toString()),
        avgPrice: double.tryParse(data['avgPrice'].toString()),
      );

  Map<String, dynamic> toMap() => {
        'symbol': symbol,
        'nameTh': nameTh,
        'nameEn': nameEn,
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
