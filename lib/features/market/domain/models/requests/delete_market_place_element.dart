class DeleteMarketPlaceElementRequest {
  final String elementType;
  final int elementId;

  DeleteMarketPlaceElementRequest({
    required this.elementType,
    required this.elementId,
  });

  Map<String, dynamic> toMap() {
    return {
      'elementType': elementType,
      'elementId': elementId,
    };
  }
}
