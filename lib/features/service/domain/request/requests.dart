class CreateCoreServiceRequest {
  final int schoolId;
  final int providerId;
  final int coreServiceCategoryId;
  final String title;
  final String description;
  final String price;
  final String availability;

  CreateCoreServiceRequest({
    required this.schoolId,
    required this.providerId,
    required this.coreServiceCategoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.availability,
  });

  Map<String, dynamic> toMap() => {
        "school_id": schoolId,
        "provider_id": providerId,
        "core_service_category_id": coreServiceCategoryId,
        "title": title,
        "description": description,
        "price": price,
        "availability": availability,
      };
}

class UpdateCoreServiceRequest {
  final int id;
  final String title;
  final String description;
  final String price;
  final String images;
  final String availability;

  UpdateCoreServiceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.availability,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "images": images,
        "availability": availability,
      };
}

class CreateCoreServiceRatingRequest {
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int userId;
  final String rating;
  final String body;

  CreateCoreServiceRatingRequest({
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    required this.userId,
    required this.rating,
    required this.body,
  });

  Map<String, dynamic> toMap() => {
        "school_id": schoolId,
        "provider_id": providerId,
        "core_service_id": coreServiceId,
        "core_service_booking_id": coreServiceBookingId,
        "user_id": userId,
        "rating": rating,
        "body": body,
      };
}

class UpdateCoreServiceRatingRequest {
  final int id;
  final int rating;
  final String body;

  UpdateCoreServiceRatingRequest({
    required this.id,
    required this.rating,
    required this.body,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "rating": rating,
        "body": body,
      };
}

class UpdateCoreServicePaymentRequest {
  final int id;
  final String amount;
  final String reference;

  UpdateCoreServicePaymentRequest({
    required this.id,
    required this.amount,
    required this.reference,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "reference": reference,
      };
}

class UpdatePaymentStatusRequest {
  final int id;
  final String status;

  UpdatePaymentStatusRequest({
    required this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };
}

class CreateCoreServicePaymentRequest {
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int coreServiceEscrowId;
  final String amount;
  final String reference;
  final int userId;
  final String status;

  CreateCoreServicePaymentRequest({
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    required this.coreServiceEscrowId,
    required this.amount,
    required this.reference,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "school_id": schoolId,
        "provider_id": providerId,
        "core_service_id": coreServiceId,
        "core_service_booking_id": coreServiceBookingId,
        "core_service_escrow_id": coreServiceEscrowId,
        "amount": amount,
        "reference": reference,
        "user_id": userId,
        "status": status,
      };
}

class UpdateCoreServiceCategoryRequest {
  final int id;
  final String name;

  UpdateCoreServiceCategoryRequest({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class CreateCoreServiceCategoryRequest {
  final String name;

  CreateCoreServiceCategoryRequest({required this.name});

  Map<String, dynamic> toMap() => {
        "name": name,
      };
}

class CreateCoreServiceBookingRequest {
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceEscrowId;
  final int coreServicePaymentId;
  final String amount;
  final int userId;
  final String status;

  CreateCoreServiceBookingRequest({
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceEscrowId,
    required this.coreServicePaymentId,
    required this.amount,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "school_id": schoolId,
        "provider_id": providerId,
        "core_service_id": coreServiceId,
        "core_service_escrow_id": coreServiceEscrowId,
        "core_service_payment_id": coreServicePaymentId,
        "amount": amount,
        "user_id": userId,
        "status": status,
      };
}

class UpdateCoreServiceBookingRequest {
  final int id;
  final String amount;

  UpdateCoreServiceBookingRequest({
    required this.id,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
      };
}

class UpdateBookingStatusRequest {
  final int id;
  final String status;

  UpdateBookingStatusRequest({
    required this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };
}

class UpdateCoreServiceEscrowRequest {
  final int id;
  final String amount;

  UpdateCoreServiceEscrowRequest({
    required this.id,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
      };
}

class CreateCoreServiceEscrowRequest {
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int coreServicePaymentId;
  final String amount;
  final int userId;
  final String status;

  CreateCoreServiceEscrowRequest({
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    required this.coreServicePaymentId,
    required this.amount,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "school_id": schoolId,
        "provider_id": providerId,
        "core_service_id": coreServiceId,
        "core_service_booking_id": coreServiceBookingId,
        "core_service_payment_id": coreServicePaymentId,
        "amount": amount,
        "user_id": userId,
        "status": status,
      };
}

class UpdateEscrowStatusRequest {
  final int id;
  final String status;

  UpdateEscrowStatusRequest({
    required this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };
}
