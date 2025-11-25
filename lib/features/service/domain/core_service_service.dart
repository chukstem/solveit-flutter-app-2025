import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/services.dart';
import 'package:solveit/core/network/utils/failures.dart';
import 'package:solveit/features/service/domain/request/requests.dart';
import 'package:solveit/features/service/domain/response/core_service_booking.dart';
import 'package:solveit/features/service/domain/response/core_service_escrow.dart';
import 'package:solveit/features/service/domain/response/core_service_payments.dart';
import 'package:solveit/features/service/domain/response/core_service_ratings.dart';
import 'package:solveit/features/service/domain/response/core_service_response.dart';
import 'package:solveit/features/service/domain/response/generic_response.dart';
import 'package:solveit/features/service/domain/response/get_core_services.dart';

abstract class CoreServicesService {
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

class CoreServicesServiceImplementation extends CoreServicesService {
  CoreServicesServiceImplementation();

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreService(request) {
    return coreServicesApi.createCoreService(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceBooking(request) {
    return coreServicesApi.createCoreServiceBooking(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceCategory(request) {
    return coreServicesApi.createCoreServiceCategory(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceEscrow(request) {
    return coreServicesApi.createCoreServiceEscrow(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServicePayment(request) {
    return coreServicesApi.createCoreServicePayment(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> createCoreServiceRating(request) {
    return coreServicesApi.createCoreServiceRating(request);
  }

  @override
  Future<Either<Failure, AllCoreServiceModelsResponse>> getAllCoreServices() {
    return coreServicesApi.getAllCoreServices();
  }

  @override
  Future<Either<Failure, CoreServiceBookingsResponse>> getCoreServiceBookings() {
    return coreServicesApi.getCoreServiceBookings();
  }

  @override
  Future<Either<Failure, CoreServiceCategoryResponse>> getCoreServiceCategories() {
    return coreServicesApi.getCoreServiceCategories();
  }

  @override
  Future<Either<Failure, CoreServiceEscrowsResponse>> getCoreServiceEscrows() {
    return coreServicesApi.getCoreServiceEscrows();
  }

  @override
  Future<Either<Failure, CoreServicePaymentsResponse>> getCoreServicePayments() {
    return coreServicesApi.getCoreServicePayments();
  }

  @override
  Future<Either<Failure, CoreServiceRatingsResponse>> getCoreServiceRatings() {
    return coreServicesApi.getCoreServiceRatings();
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateBookingStatus(request) {
    return coreServicesApi.updateBookingStatus(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreService(request) {
    return coreServicesApi.updateCoreService(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceBooking(request) {
    return coreServicesApi.updateCoreServiceBooking(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceCategory(request) {
    return coreServicesApi.updateCoreServiceCategory(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrow(request) {
    return coreServicesApi.updateCoreServiceEscrow(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceEscrowStatus(request) {
    return coreServicesApi.updateCoreServiceEscrowStatus(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServicePayment(request) {
    return coreServicesApi.updateCoreServicePayment(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updateCoreServiceRating(request) {
    return coreServicesApi.updateCoreServiceRating(request);
  }

  @override
  Future<Either<Failure, GenericCreateOrUpdateResponse>> updatePaymentStatus(request) {
    return coreServicesApi.updatePaymentStatus(request);
  }
}
