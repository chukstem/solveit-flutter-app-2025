// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  String toJson() => json.encode(toMap());

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
