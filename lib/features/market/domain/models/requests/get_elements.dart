import 'dart:convert';

class GetMarketElementsRequest {
  final String elementType;
  GetMarketElementsRequest({
    required this.elementType,
  });

  GetMarketElementsRequest copyWith({
    String? elementType,
  }) {
    return GetMarketElementsRequest(
      elementType: elementType ?? this.elementType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'elementType': elementType,
    };
  }

  factory GetMarketElementsRequest.fromMap(Map<String, dynamic> map) {
    return GetMarketElementsRequest(
      elementType: map['elementType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMarketElementsRequest.fromJson(String source) => GetMarketElementsRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetMarketElementsRequest(elementType: $elementType)';

  @override
  bool operator ==(covariant GetMarketElementsRequest other) {
    if (identical(this, other)) return true;

    return other.elementType == elementType;
  }

  @override
  int get hashCode => elementType.hashCode;
}
