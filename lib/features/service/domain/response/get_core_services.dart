class AllCoreServiceModelsResponse {
  final int status;
  final String message;
  final List<CoreServiceModel> data;

  AllCoreServiceModelsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllCoreServiceModelsResponse.fromMap(Map<String, dynamic> map) {
    return AllCoreServiceModelsResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServiceModel>.from(
        map['data'].map((x) => CoreServiceModel.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }
}

class CoreServiceModel {
  final int id;
  final int schoolId;
  final int providerId;
  final int coreServiceModelCategoryId;
  final String title;
  final String description;
  final String price;
  final String? images;
  final String availability;
  final int active;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  CoreServiceModel({
    required this.id,
    required this.schoolId,
    required this.providerId,
    required this.coreServiceModelCategoryId,
    required this.title,
    required this.description,
    required this.price,
    this.images,
    required this.availability,
    required this.active,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CoreServiceModel.fromMap(Map<String, dynamic> map) {
    return CoreServiceModel(
      id: map['id'],
      schoolId: map['school_id'],
      providerId: map['provider_id'],
      coreServiceModelCategoryId: map['core_service_category_id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      images: map['images'],
      availability: map['availability'],
      active: map['active'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolId,
      'provider_id': providerId,
      'core_service_category_id': coreServiceModelCategoryId,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'availability': availability,
      'active': active,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  CoreServiceModel copyWith({
    int? id,
    int? schoolId,
    int? providerId,
    int? coreServiceModelCategoryId,
    String? title,
    String? description,
    String? price,
    String? images,
    String? availability,
    int? active,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return CoreServiceModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      providerId: providerId ?? this.providerId,
      coreServiceModelCategoryId: coreServiceModelCategoryId ?? this.coreServiceModelCategoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      availability: availability ?? this.availability,
      active: active ?? this.active,
      code: code ?? this.code,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          schoolId == other.schoolId &&
          providerId == other.providerId &&
          coreServiceModelCategoryId == other.coreServiceModelCategoryId &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          images == other.images &&
          availability == other.availability &&
          active == other.active &&
          code == other.code &&
          deletedAt == other.deletedAt &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      schoolId.hashCode ^
      providerId.hashCode ^
      coreServiceModelCategoryId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      images.hashCode ^
      availability.hashCode ^
      active.hashCode ^
      code.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
