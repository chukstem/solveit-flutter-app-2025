import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/utils/exceptions.dart';
import 'package:solveit/core/network/utils/failures.dart';
import 'package:solveit/features/service/domain/request/requests.dart';
import 'package:solveit/features/service/domain/response/core_service_booking.dart';
import 'package:solveit/features/service/domain/response/core_service_escrow.dart';
import 'package:solveit/features/service/domain/response/core_service_payments.dart';
import 'package:solveit/features/service/domain/response/core_service_ratings.dart';
import 'package:solveit/features/service/domain/response/core_service_response.dart';
import 'package:solveit/features/service/domain/response/generic_response.dart';
import 'package:solveit/features/service/domain/response/get_core_services.dart';

abstract class CoreServicesApi {
  // --- Core Services ---
  Future<Either<Failure, AllCoreServiceModelsResponse>> getAllCoreServices();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreService(CreateCoreServiceRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreService(UpdateCoreServiceRequest request);

  // --- Core Service Ratings ---
  Future<Either<Failure, CoreServiceRatingsResponse>> getCoreServiceRatings();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceRating(CreateCoreServiceRatingRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceRating(UpdateCoreServiceRatingRequest request);

  // --- Core Service Payments ---
  Future<Either<Failure, CoreServicePaymentsResponse>> getCoreServicePayments();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServicePayment(UpdateCoreServicePaymentRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updatePaymentStatus(UpdatePaymentStatusRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServicePayment(CreateCoreServicePaymentRequest request);

  // --- Core Service Categories ---
  Future<Either<Failure, CoreServiceCategoryResponse>> getCoreServiceCategories();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceCategory(UpdateCoreServiceCategoryRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceCategory(CreateCoreServiceCategoryRequest request);

  // --- Core Service Bookings ---
  Future<Either<Failure, CoreServiceBookingsResponse>> getCoreServiceBookings();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceBooking(CreateCoreServiceBookingRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceBooking(UpdateCoreServiceBookingRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateBookingStatus(UpdateBookingStatusRequest request);

  // --- Core Service Escrows ---
  Future<Either<Failure, CoreServiceEscrowsResponse>> getCoreServiceEscrows();
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrow(UpdateCoreServiceEscrowRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceEscrow(CreateCoreServiceEscrowRequest request);
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrowStatus(UpdateEscrowStatusRequest request);
}

class CoreServicesApiImplementation extends CoreServicesApi {
  Future<Either<ApiFailure, T>> _putRequest<T>(String url, T Function(Map<String, dynamic>) fromJson,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? data}) async {
    try {
      final response = await apiClient.put(url, data: data, queryParameters: queryParams);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in PUT [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in PUT [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  Future<Either<ApiFailure, T>> _postRequest<T>(String url, T Function(Map<String, dynamic>) fromJson,
      {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await apiClient.post(url, data: data, queryParameters: queryParams);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  Future<Either<ApiFailure, T>> _getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson,
      {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await apiClient.get(url, queryParameters: queryParams);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreService(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceBooking(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceCategory(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceEscrow(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServicePayment(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceRating(request) async {
    return await _postRequest(
      servicesEndpoints.createCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, AllCoreServiceModelsResponse>> getAllCoreServices() async {
    return await _getRequest(
      servicesEndpoints.getCoreServices,
      AllCoreServiceModelsResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, CoreServiceBookingsResponse>> getCoreServiceBookings() async {
    return await _getRequest(
      servicesEndpoints.getCoreServiceBookings,
      CoreServiceBookingsResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, CoreServiceCategoryResponse>> getCoreServiceCategories() async {
    return await _getRequest(
      servicesEndpoints.getCoreServiceCategories,
      CoreServiceCategoryResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, CoreServiceEscrowsResponse>> getCoreServiceEscrows() async {
    return await _getRequest(
      servicesEndpoints.getCoreServiceEscrows,
      CoreServiceEscrowsResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, CoreServicePaymentsResponse>> getCoreServicePayments() async {
    return await _getRequest(
      servicesEndpoints.getCoreServicePayments,
      CoreServicePaymentsResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, CoreServiceRatingsResponse>> getCoreServiceRatings() async {
    return await _getRequest(
      servicesEndpoints.getCoreServiceRatings,
      CoreServiceRatingsResponse.fromMap,
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateBookingStatus(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceBookingStatus,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreService(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreService,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceBooking(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceBooking,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceCategory(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceCategory,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrow(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceEscrows,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrowStatus(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceEscrowsStatus,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServicePayment(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServicePayment,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceRating(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServiceRating,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updatePaymentStatus(request) async {
    return await _putRequest(
      servicesEndpoints.updateCoreServicePaymentStatus,
      GenericCreateOrUpdateResponse.fromMap,
      data: request.toMap(),
    );
  }
}
