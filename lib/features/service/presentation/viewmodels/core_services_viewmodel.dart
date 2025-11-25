import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/service/domain/request/requests.dart';
import 'package:solveit/features/service/domain/response/core_service_booking.dart';
import 'package:solveit/features/service/domain/response/core_service_escrow.dart';
import 'package:solveit/features/service/domain/response/core_service_payments.dart';
import 'package:solveit/features/service/domain/response/core_service_ratings.dart';
import 'package:solveit/features/service/domain/response/core_service_response.dart';
import 'package:solveit/features/service/domain/response/get_core_services.dart';
import 'package:solveit/core/injections/services.dart';

class CoreServicesState {
  final bool isLoading;
  final String? errorMessage;
  final Failure? failure;

  // Request objects
  final CreateCoreServiceRequest? createServiceRequest;
  final UpdateCoreServiceRequest? updateServiceRequest;
  final CreateCoreServiceRatingRequest? createRatingRequest;
  final UpdateCoreServiceRatingRequest? updateRatingRequest;
  final CreateCoreServicePaymentRequest? createPaymentRequest;
  final UpdateCoreServicePaymentRequest? updatePaymentRequest;
  final UpdatePaymentStatusRequest? updatePaymentStatusRequest;
  final CreateCoreServiceCategoryRequest? createCategoryRequest;
  final UpdateCoreServiceCategoryRequest? updateCategoryRequest;
  final CreateCoreServiceBookingRequest? createBookingRequest;
  final UpdateCoreServiceBookingRequest? updateBookingRequest;
  final UpdateBookingStatusRequest? updateBookingStatusRequest;
  final CreateCoreServiceEscrowRequest? createEscrowRequest;
  final UpdateCoreServiceEscrowRequest? updateEscrowRequest;
  final UpdateEscrowStatusRequest? updateEscrowStatusRequest;

  // Response objects
  final AllCoreServiceModelsResponse? coreServicesResponse;
  final CoreServiceRatingsResponse? ratingsResponse;
  final CoreServicePaymentsResponse? paymentsResponse;
  final CoreServiceCategoryResponse? categoriesResponse;
  final CoreServiceBookingsResponse? bookingsResponse;
  final CoreServiceEscrowsResponse? escrowsResponse;

  const CoreServicesState({
    this.isLoading = false,
    this.errorMessage,
    this.failure,

    // Request objects
    this.createServiceRequest,
    this.updateServiceRequest,
    this.createRatingRequest,
    this.updateRatingRequest,
    this.createPaymentRequest,
    this.updatePaymentRequest,
    this.updatePaymentStatusRequest,
    this.createCategoryRequest,
    this.updateCategoryRequest,
    this.createBookingRequest,
    this.updateBookingRequest,
    this.updateBookingStatusRequest,
    this.createEscrowRequest,
    this.updateEscrowRequest,
    this.updateEscrowStatusRequest,

    // Response objects
    this.coreServicesResponse,
    this.ratingsResponse,
    this.paymentsResponse,
    this.categoriesResponse,
    this.bookingsResponse,
    this.escrowsResponse,
  });

  CoreServicesState copyWith({
    bool? isLoading,
    String? errorMessage,
    Failure? failure,

    // Request objects
    CreateCoreServiceRequest? createServiceRequest,
    UpdateCoreServiceRequest? updateServiceRequest,
    CreateCoreServiceRatingRequest? createRatingRequest,
    UpdateCoreServiceRatingRequest? updateRatingRequest,
    CreateCoreServicePaymentRequest? createPaymentRequest,
    UpdateCoreServicePaymentRequest? updatePaymentRequest,
    UpdatePaymentStatusRequest? updatePaymentStatusRequest,
    CreateCoreServiceCategoryRequest? createCategoryRequest,
    UpdateCoreServiceCategoryRequest? updateCategoryRequest,
    CreateCoreServiceBookingRequest? createBookingRequest,
    UpdateCoreServiceBookingRequest? updateBookingRequest,
    UpdateBookingStatusRequest? updateBookingStatusRequest,
    CreateCoreServiceEscrowRequest? createEscrowRequest,
    UpdateCoreServiceEscrowRequest? updateEscrowRequest,
    UpdateEscrowStatusRequest? updateEscrowStatusRequest,

    // Response objects
    AllCoreServiceModelsResponse? coreServicesResponse,
    CoreServiceRatingsResponse? ratingsResponse,
    CoreServicePaymentsResponse? paymentsResponse,
    CoreServiceCategoryResponse? categoriesResponse,
    CoreServiceBookingsResponse? bookingsResponse,
    CoreServiceEscrowsResponse? escrowsResponse,
  }) {
    return CoreServicesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,

      // Request objects
      createServiceRequest: createServiceRequest ?? this.createServiceRequest,
      updateServiceRequest: updateServiceRequest ?? this.updateServiceRequest,
      createRatingRequest: createRatingRequest ?? this.createRatingRequest,
      updateRatingRequest: updateRatingRequest ?? this.updateRatingRequest,
      createPaymentRequest: createPaymentRequest ?? this.createPaymentRequest,
      updatePaymentRequest: updatePaymentRequest ?? this.updatePaymentRequest,
      updatePaymentStatusRequest: updatePaymentStatusRequest ?? this.updatePaymentStatusRequest,
      createCategoryRequest: createCategoryRequest ?? this.createCategoryRequest,
      updateCategoryRequest: updateCategoryRequest ?? this.updateCategoryRequest,
      createBookingRequest: createBookingRequest ?? this.createBookingRequest,
      updateBookingRequest: updateBookingRequest ?? this.updateBookingRequest,
      updateBookingStatusRequest: updateBookingStatusRequest ?? this.updateBookingStatusRequest,
      createEscrowRequest: createEscrowRequest ?? this.createEscrowRequest,
      updateEscrowRequest: updateEscrowRequest ?? this.updateEscrowRequest,
      updateEscrowStatusRequest: updateEscrowStatusRequest ?? this.updateEscrowStatusRequest,

      // Response objects
      coreServicesResponse: coreServicesResponse ?? this.coreServicesResponse,
      ratingsResponse: ratingsResponse ?? this.ratingsResponse,
      paymentsResponse: paymentsResponse ?? this.paymentsResponse,
      categoriesResponse: categoriesResponse ?? this.categoriesResponse,
      bookingsResponse: bookingsResponse ?? this.bookingsResponse,
      escrowsResponse: escrowsResponse ?? this.escrowsResponse,
    );
  }

  // Helper method to clear all errors
  CoreServicesState clearErrors() {
    return copyWith(
      errorMessage: null,
      failure: null,
    );
  }

  // Helper method to clear all requests
  CoreServicesState clearRequests() {
    return copyWith(
      createServiceRequest: null,
      updateServiceRequest: null,
      createRatingRequest: null,
      updateRatingRequest: null,
      createPaymentRequest: null,
      updatePaymentRequest: null,
      updatePaymentStatusRequest: null,
      createCategoryRequest: null,
      updateCategoryRequest: null,
      createBookingRequest: null,
      updateBookingRequest: null,
      updateBookingStatusRequest: null,
      createEscrowRequest: null,
      updateEscrowRequest: null,
      updateEscrowStatusRequest: null,
    );
  }

  // Helper method to clear all responses
  CoreServicesState clearResponses() {
    return copyWith(
      coreServicesResponse: null,
      ratingsResponse: null,
      paymentsResponse: null,
      categoriesResponse: null,
      bookingsResponse: null,
      escrowsResponse: null,
    );
  }

  static const empty = CoreServicesState();
}

class CoreServicesViewModel extends ChangeNotifier {
  CoreServicesState _state = CoreServicesState.empty;
  CoreServicesState get state => _state;

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  String? get errorMessage => _state.errorMessage;
  Failure? get failure => _state.failure;

  // Request getters and setters
  CreateCoreServiceRequest? get createServiceRequest => _state.createServiceRequest;
  set createServiceRequest(CreateCoreServiceRequest? value) {
    _setState(_state.copyWith(createServiceRequest: value));
  }

  UpdateCoreServiceRequest? get updateServiceRequest => _state.updateServiceRequest;
  set updateServiceRequest(UpdateCoreServiceRequest? value) {
    _setState(_state.copyWith(updateServiceRequest: value));
  }

  CreateCoreServiceRatingRequest? get createRatingRequest => _state.createRatingRequest;
  set createRatingRequest(CreateCoreServiceRatingRequest? value) {
    _setState(_state.copyWith(createRatingRequest: value));
  }

  UpdateCoreServiceRatingRequest? get updateRatingRequest => _state.updateRatingRequest;
  set updateRatingRequest(UpdateCoreServiceRatingRequest? value) {
    _setState(_state.copyWith(updateRatingRequest: value));
  }

  CreateCoreServicePaymentRequest? get createPaymentRequest => _state.createPaymentRequest;
  set createPaymentRequest(CreateCoreServicePaymentRequest? value) {
    _setState(_state.copyWith(createPaymentRequest: value));
  }

  UpdateCoreServicePaymentRequest? get updatePaymentRequest => _state.updatePaymentRequest;
  set updatePaymentRequest(UpdateCoreServicePaymentRequest? value) {
    _setState(_state.copyWith(updatePaymentRequest: value));
  }

  UpdatePaymentStatusRequest? get updatePaymentStatusRequest => _state.updatePaymentStatusRequest;
  set updatePaymentStatusRequest(UpdatePaymentStatusRequest? value) {
    _setState(_state.copyWith(updatePaymentStatusRequest: value));
  }

  CreateCoreServiceCategoryRequest? get createCategoryRequest => _state.createCategoryRequest;
  set createCategoryRequest(CreateCoreServiceCategoryRequest? value) {
    _setState(_state.copyWith(createCategoryRequest: value));
  }

  UpdateCoreServiceCategoryRequest? get updateCategoryRequest => _state.updateCategoryRequest;
  set updateCategoryRequest(UpdateCoreServiceCategoryRequest? value) {
    _setState(_state.copyWith(updateCategoryRequest: value));
  }

  CreateCoreServiceBookingRequest? get createBookingRequest => _state.createBookingRequest;
  set createBookingRequest(CreateCoreServiceBookingRequest? value) {
    _setState(_state.copyWith(createBookingRequest: value));
  }

  UpdateCoreServiceBookingRequest? get updateBookingRequest => _state.updateBookingRequest;
  set updateBookingRequest(UpdateCoreServiceBookingRequest? value) {
    _setState(_state.copyWith(updateBookingRequest: value));
  }

  UpdateBookingStatusRequest? get updateBookingStatusRequest => _state.updateBookingStatusRequest;
  set updateBookingStatusRequest(UpdateBookingStatusRequest? value) {
    _setState(_state.copyWith(updateBookingStatusRequest: value));
  }

  CreateCoreServiceEscrowRequest? get createEscrowRequest => _state.createEscrowRequest;
  set createEscrowRequest(CreateCoreServiceEscrowRequest? value) {
    _setState(_state.copyWith(createEscrowRequest: value));
  }

  UpdateCoreServiceEscrowRequest? get updateEscrowRequest => _state.updateEscrowRequest;
  set updateEscrowRequest(UpdateCoreServiceEscrowRequest? value) {
    _setState(_state.copyWith(updateEscrowRequest: value));
  }

  UpdateEscrowStatusRequest? get updateEscrowStatusRequest => _state.updateEscrowStatusRequest;
  set updateEscrowStatusRequest(UpdateEscrowStatusRequest? value) {
    _setState(_state.copyWith(updateEscrowStatusRequest: value));
  }

  // Response getters and setters
  AllCoreServiceModelsResponse? get coreServicesResponse => _state.coreServicesResponse;
  set coreServicesResponse(AllCoreServiceModelsResponse? value) {
    _setState(_state.copyWith(coreServicesResponse: value));
  }

  CoreServiceRatingsResponse? get ratingsResponse => _state.ratingsResponse;
  set ratingsResponse(CoreServiceRatingsResponse? value) {
    _setState(_state.copyWith(ratingsResponse: value));
  }

  CoreServicePaymentsResponse? get paymentsResponse => _state.paymentsResponse;
  set paymentsResponse(CoreServicePaymentsResponse? value) {
    _setState(_state.copyWith(paymentsResponse: value));
  }

  CoreServiceCategoryResponse? get categoriesResponse => _state.categoriesResponse;
  set categoriesResponse(CoreServiceCategoryResponse? value) {
    _setState(_state.copyWith(categoriesResponse: value));
  }

  CoreServiceBookingsResponse? get bookingsResponse => _state.bookingsResponse;
  set bookingsResponse(CoreServiceBookingsResponse? value) {
    _setState(_state.copyWith(bookingsResponse: value));
  }

  CoreServiceEscrowsResponse? get escrowsResponse => _state.escrowsResponse;
  set escrowsResponse(CoreServiceEscrowsResponse? value) {
    _setState(_state.copyWith(escrowsResponse: value));
  }

  void _setState(CoreServicesState state) {
    _state = state;
    notifyListeners();
  }

  void _setStateWithDelay(CoreServicesState state) {
    _state = state;
    Timer(const Duration(milliseconds: 30), () => notifyListeners());
  }

  Future<bool> _handleApiCall(Future<Either<Failure, dynamic>> Function() apiCall) async {
    _setStateWithDelay(_state.copyWith(isLoading: true));
    _clearErrors();

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (success) {
          _handleSuccess(success);
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setStateWithDelay(_state.copyWith(isLoading: false));
    }
  }

  void _handleSuccess(dynamic response) {
    if (response is AllCoreServiceModelsResponse) {
      _setState(_state.copyWith(coreServicesResponse: response));
    } else if (response is CoreServiceRatingsResponse) {
      _setState(_state.copyWith(ratingsResponse: response));
    } else if (response is CoreServicePaymentsResponse) {
      _setState(_state.copyWith(paymentsResponse: response));
    } else if (response is CoreServiceCategoryResponse) {
      _setState(_state.copyWith(categoriesResponse: response));
    } else if (response is CoreServiceBookingsResponse) {
      _setState(_state.copyWith(bookingsResponse: response));
    } else if (response is CoreServiceEscrowsResponse) {
      _setState(_state.copyWith(escrowsResponse: response));
    }
    _clearRequests();
  }

  void _clearErrors() {
    _setState(_state.clearErrors());
  }

  void _setError(Failure failure) {
    _setState(_state.copyWith(errorMessage: failure.message, failure: failure));
  }

  void _clearRequests() {
    _setState(_state.clearRequests());
  }

  // Core Services API Methods
  Future<bool> getAllCoreServices() async =>
      _handleApiCall(() => coreServicesService.getAllCoreServices());

  Future<bool> createCoreService() async =>
      _handleApiCall(() => coreServicesService.createCoreService(createServiceRequest!));

  Future<bool> updateCoreService() async =>
      _handleApiCall(() => coreServicesService.updateCoreService(updateServiceRequest!));

  // Ratings Methods
  Future<bool> getCoreServiceRatings() async =>
      _handleApiCall(() => coreServicesService.getCoreServiceRatings());

  Future<bool> createCoreServiceRating() async =>
      _handleApiCall(() => coreServicesService.createCoreServiceRating(createRatingRequest!));

  Future<bool> updateCoreServiceRating() async =>
      _handleApiCall(() => coreServicesService.updateCoreServiceRating(updateRatingRequest!));

  // Payments Methods
  Future<bool> getCoreServicePayments() async =>
      _handleApiCall(() => coreServicesService.getCoreServicePayments());

  Future<bool> createCoreServicePayment() async =>
      _handleApiCall(() => coreServicesService.createCoreServicePayment(createPaymentRequest!));

  Future<bool> updateCoreServicePayment() async =>
      _handleApiCall(() => coreServicesService.updateCoreServicePayment(updatePaymentRequest!));

  Future<bool> updatePaymentStatus() async =>
      _handleApiCall(() => coreServicesService.updatePaymentStatus(updatePaymentStatusRequest!));

  // Categories Methods
  Future<bool> getCoreServiceCategories() async =>
      _handleApiCall(() => coreServicesService.getCoreServiceCategories());

  Future<bool> createCoreServiceCategory() async =>
      _handleApiCall(() => coreServicesService.createCoreServiceCategory(createCategoryRequest!));

  Future<bool> updateCoreServiceCategory() async =>
      _handleApiCall(() => coreServicesService.updateCoreServiceCategory(updateCategoryRequest!));

  // Bookings Methods
  Future<bool> getCoreServiceBookings() async =>
      _handleApiCall(() => coreServicesService.getCoreServiceBookings());

  Future<bool> createCoreServiceBooking() async =>
      _handleApiCall(() => coreServicesService.createCoreServiceBooking(createBookingRequest!));

  Future<bool> updateCoreServiceBooking() async =>
      _handleApiCall(() => coreServicesService.updateCoreServiceBooking(updateBookingRequest!));

  Future<bool> updateBookingStatus() async =>
      _handleApiCall(() => coreServicesService.updateBookingStatus(updateBookingStatusRequest!));

  // Escrow Methods
  Future<bool> getCoreServiceEscrows() async =>
      _handleApiCall(() => coreServicesService.getCoreServiceEscrows());

  Future<bool> createCoreServiceEscrow() async =>
      _handleApiCall(() => coreServicesService.createCoreServiceEscrow(createEscrowRequest!));

  Future<bool> updateCoreServiceEscrow() async =>
      _handleApiCall(() => coreServicesService.updateCoreServiceEscrow(updateEscrowRequest!));

  Future<bool> updateCoreServiceEscrowStatus() async => _handleApiCall(
      () => coreServicesService.updateCoreServiceEscrowStatus(updateEscrowStatusRequest!));

  Future<bool> getAllCoreServicesElements() async {
    await getAllCoreServices();
    getCoreServiceRatings();
    getCoreServicePayments();
    getCoreServiceCategories();
    getCoreServiceBookings();
    getCoreServiceEscrows();
    return true;
  }

  void clearSession() {
    _setState(_state.clearRequests().clearResponses().clearErrors());
  }
}
