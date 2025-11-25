import 'dart:convert';

///Department, Faculty, Level, or School
class GetSchoolElements {
  final String elementType;
  GetSchoolElements({
    required this.elementType,
  });

  GetSchoolElements copyWith({
    String? elementType,
  }) {
    return GetSchoolElements(
      elementType: elementType ?? this.elementType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'elementType': elementType,
    };
  }

  factory GetSchoolElements.fromMap(Map<String, dynamic> map) {
    return GetSchoolElements(
      elementType: map['elementType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetSchoolElements.fromJson(String source) => GetSchoolElements.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetSchoolElements(elementType: $elementType)';

  @override
  bool operator ==(covariant GetSchoolElements other) {
    if (identical(this, other)) return true;

    return other.elementType == elementType;
  }

  @override
  int get hashCode => elementType.hashCode;
}
