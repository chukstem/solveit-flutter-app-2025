// ignore_for_file: public_member_api_docs, sort_constructors_first

abstract class GenericMarketPlaceResponse {
  final int status;
  final String message;

  GenericMarketPlaceResponse({required this.status, required this.message});

  factory GenericMarketPlaceResponse.fromMap(Map<String, dynamic> map) {
    return GenericMarketPlaceResponseImpl(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'GenericMarketPlaceResponse(status: $status, message: $message)';
  }
}

class GenericMarketPlaceResponseImpl extends GenericMarketPlaceResponse {
  GenericMarketPlaceResponseImpl({required super.status, required super.message});
}

class CreateProductResponse extends GenericMarketPlaceResponse {
  CreateProductResponse({required super.status, required super.message});

  factory CreateProductResponse.fromMap(Map<String, dynamic> map) {
    return CreateProductResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class CreateProductTagsResponse extends GenericMarketPlaceResponse {
  CreateProductTagsResponse({required super.status, required super.message});

  factory CreateProductTagsResponse.fromMap(Map<String, dynamic> map) {
    return CreateProductTagsResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class DeleteMarketPlaceElementResponse extends GenericMarketPlaceResponse {
  DeleteMarketPlaceElementResponse({required super.status, required super.message});

  factory DeleteMarketPlaceElementResponse.fromMap(Map<String, dynamic> map) {
    return DeleteMarketPlaceElementResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class CreateProductCommentResponse extends GenericMarketPlaceResponse {
  CreateProductCommentResponse({required super.status, required super.message});

  factory CreateProductCommentResponse.fromMap(Map<String, dynamic> map) {
    return CreateProductCommentResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class CreateCommentReplyResponse extends GenericMarketPlaceResponse {
  CreateCommentReplyResponse({required super.status, required super.message});

  factory CreateCommentReplyResponse.fromMap(Map<String, dynamic> map) {
    return CreateCommentReplyResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class CreateProductCommentReactionsResponse extends GenericMarketPlaceResponse {
  CreateProductCommentReactionsResponse({required super.status, required super.message});

  factory CreateProductCommentReactionsResponse.fromMap(Map<String, dynamic> map) {
    return CreateProductCommentReactionsResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class UpdateProductDetailsResponse extends GenericMarketPlaceResponse {
  UpdateProductDetailsResponse({required super.status, required super.message});

  factory UpdateProductDetailsResponse.fromMap(Map<String, dynamic> map) {
    return UpdateProductDetailsResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class UpdateProductTagsResponse extends GenericMarketPlaceResponse {
  UpdateProductTagsResponse({required super.status, required super.message});

  factory UpdateProductTagsResponse.fromMap(Map<String, dynamic> map) {
    return UpdateProductTagsResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class UpdateProductCommentResponse extends GenericMarketPlaceResponse {
  UpdateProductCommentResponse({required super.status, required super.message});

  factory UpdateProductCommentResponse.fromMap(Map<String, dynamic> map) {
    return UpdateProductCommentResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}

class UpdateProductCommentReactionResponse extends GenericMarketPlaceResponse {
  UpdateProductCommentReactionResponse({required super.status, required super.message});

  factory UpdateProductCommentReactionResponse.fromMap(Map<String, dynamic> map) {
    return UpdateProductCommentReactionResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }
}
