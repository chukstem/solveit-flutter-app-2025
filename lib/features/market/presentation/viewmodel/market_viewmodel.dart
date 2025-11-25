import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/core/injections/market.dart';
import 'package:solveit/features/market/domain/models/requests/requests.dart';
import 'package:solveit/features/market/domain/models/response/comments.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';
import 'package:solveit/features/market/domain/models/response/reactions.dart';
import 'package:solveit/features/market/domain/models/response/replies.dart';
import 'package:solveit/features/market/domain/models/response/tags.dart';
import 'package:solveit/features/market/domain/models/responses.dart';

class MarketState {
  // UI state
  final bool isLoading;
  final String? errorMessage;
  final Failure? failure;
  final bool isScrolling;
  final String selectedCategory;
  final List<String> categories;

  // Request objects
  final CreateProductRequest? createProductRequest;
  final CreateProductTagsRequest? createProductTagsRequest;
  final DeleteMarketPlaceElementRequest? deleteElementRequest;
  final CreateProductCommentRequest? createCommentRequest;
  final CreateCommentReplyRequest? createReplyRequest;
  final CreateProductCommentReactionsRequest? createReactionRequest;
  final UpdateProductDetailsRequest? updateProductRequest;
  final UpdateProductTagsRequest? updateTagsRequest;
  final UpdateProductCommentRequest? updateCommentRequest;
  final UpdateProductCommentReactionRequest? updateReactionRequest;

  // Response objects
  final MarketPlaceProductResponse? marketProducts;
  final MarketplaceCommentResponse? marketComments;
  final MarketplaceTagResponse? marketTags;
  final MarketplaceCommentReplyResponse? marketReplies;
  final MarketplaceCommentReactionResponse? marketReactions;
  final CreateProductResponse? createProductResponse;
  final CreateProductTagsResponse? createTagsResponse;
  final DeleteMarketPlaceElementResponse? deleteElementResponse;
  final CreateProductCommentResponse? createCommentResponse;
  final CreateCommentReplyResponse? createReplyResponse;
  final CreateProductCommentReactionsResponse? createReactionResponse;
  final UpdateProductDetailsResponse? updateProductResponse;
  final UpdateProductTagsResponse? updateTagsResponse;
  final UpdateProductCommentResponse? updateCommentResponse;
  final UpdateProductCommentReactionResponse? updateReactionResponse;

  const MarketState({
    // UI state
    this.isLoading = false,
    this.errorMessage,
    this.failure,
    this.isScrolling = false,
    this.selectedCategory = 'all',
    this.categories = const ['All', 'Latest', 'Trending', 'Best Selling', 'Hot Pick'],

    // Request objects
    this.createProductRequest,
    this.createProductTagsRequest,
    this.deleteElementRequest,
    this.createCommentRequest,
    this.createReplyRequest,
    this.createReactionRequest,
    this.updateProductRequest,
    this.updateTagsRequest,
    this.updateCommentRequest,
    this.updateReactionRequest,

    // Response objects
    this.marketProducts,
    this.marketComments,
    this.marketTags,
    this.marketReplies,
    this.marketReactions,
    this.createProductResponse,
    this.createTagsResponse,
    this.deleteElementResponse,
    this.createCommentResponse,
    this.createReplyResponse,
    this.createReactionResponse,
    this.updateProductResponse,
    this.updateTagsResponse,
    this.updateCommentResponse,
    this.updateReactionResponse,
  });

  MarketState copyWith({
    // UI state
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
    bool? isScrolling,
    String? selectedCategory,
    List<String>? categories,

    // Request objects
    CreateProductRequest? createProductRequest,
    CreateProductTagsRequest? createProductTagsRequest,
    DeleteMarketPlaceElementRequest? deleteElementRequest,
    CreateProductCommentRequest? createCommentRequest,
    CreateCommentReplyRequest? createReplyRequest,
    CreateProductCommentReactionsRequest? createReactionRequest,
    UpdateProductDetailsRequest? updateProductRequest,
    UpdateProductTagsRequest? updateTagsRequest,
    UpdateProductCommentRequest? updateCommentRequest,
    UpdateProductCommentReactionRequest? updateReactionRequest,

    // Response objects
    MarketPlaceProductResponse? marketProducts,
    MarketplaceCommentResponse? marketComments,
    MarketplaceTagResponse? marketTags,
    MarketplaceCommentReplyResponse? marketReplies,
    MarketplaceCommentReactionResponse? marketReactions,
    CreateProductResponse? createProductResponse,
    CreateProductTagsResponse? createTagsResponse,
    DeleteMarketPlaceElementResponse? deleteElementResponse,
    CreateProductCommentResponse? createCommentResponse,
    CreateCommentReplyResponse? createReplyResponse,
    CreateProductCommentReactionsResponse? createReactionResponse,
    UpdateProductDetailsResponse? updateProductResponse,
    UpdateProductTagsResponse? updateTagsResponse,
    UpdateProductCommentResponse? updateCommentResponse,
    UpdateProductCommentReactionResponse? updateReactionResponse,
  }) {
    return MarketState(
      // UI state
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      isScrolling: isScrolling ?? this.isScrolling,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,

      // Request objects
      createProductRequest: createProductRequest ?? this.createProductRequest,
      createProductTagsRequest: createProductTagsRequest ?? this.createProductTagsRequest,
      deleteElementRequest: deleteElementRequest ?? this.deleteElementRequest,
      createCommentRequest: createCommentRequest ?? this.createCommentRequest,
      createReplyRequest: createReplyRequest ?? this.createReplyRequest,
      createReactionRequest: createReactionRequest ?? this.createReactionRequest,
      updateProductRequest: updateProductRequest ?? this.updateProductRequest,
      updateTagsRequest: updateTagsRequest ?? this.updateTagsRequest,
      updateCommentRequest: updateCommentRequest ?? this.updateCommentRequest,
      updateReactionRequest: updateReactionRequest ?? this.updateReactionRequest,

      // Response objects
      marketProducts: marketProducts ?? this.marketProducts,
      marketComments: marketComments ?? this.marketComments,
      marketTags: marketTags ?? this.marketTags,
      marketReplies: marketReplies ?? this.marketReplies,
      marketReactions: marketReactions ?? this.marketReactions,
      createProductResponse: createProductResponse ?? this.createProductResponse,
      createTagsResponse: createTagsResponse ?? this.createTagsResponse,
      deleteElementResponse: deleteElementResponse ?? this.deleteElementResponse,
      createCommentResponse: createCommentResponse ?? this.createCommentResponse,
      createReplyResponse: createReplyResponse ?? this.createReplyResponse,
      createReactionResponse: createReactionResponse ?? this.createReactionResponse,
      updateProductResponse: updateProductResponse ?? this.updateProductResponse,
      updateTagsResponse: updateTagsResponse ?? this.updateTagsResponse,
      updateCommentResponse: updateCommentResponse ?? this.updateCommentResponse,
      updateReactionResponse: updateReactionResponse ?? this.updateReactionResponse,
    );
  }

  // Helper method to clear all errors
  MarketState clearErrors() {
    return copyWith(
      errorMessage: null,
      failure: null,
    );
  }

  // Helper method to clear all requests
  MarketState clearRequests() {
    return copyWith(
      createProductRequest: null,
      createProductTagsRequest: null,
      deleteElementRequest: null,
      createCommentRequest: null,
      createReplyRequest: null,
      createReactionRequest: null,
      updateProductRequest: null,
      updateTagsRequest: null,
      updateCommentRequest: null,
      updateReactionRequest: null,
    );
  }

  // Helper method to clear all responses
  MarketState clearResponses() {
    return copyWith(
      marketProducts: null,
      marketComments: null,
      marketTags: null,
      marketReplies: null,
      marketReactions: null,
      createProductResponse: null,
      createTagsResponse: null,
      deleteElementResponse: null,
      createCommentResponse: null,
      createReplyResponse: null,
      createReactionResponse: null,
      updateProductResponse: null,
      updateTagsResponse: null,
      updateCommentResponse: null,
      updateReactionResponse: null,
    );
  }

  static const empty = MarketState();
}

class MarketViewModel extends ChangeNotifier {
  MarketState _state = MarketState.empty;
  MarketState get state => _state;

  final ScrollController scrollController = ScrollController();

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  String? get errorMessage => _state.errorMessage;
  Failure? get failure => _state.failure;
  bool get isScrolling => _state.isScrolling;
  String get selectedCategory => _state.selectedCategory;
  List<String> get categories => _state.categories;

  // Request getters and setters
  CreateProductRequest? get createProductRequest => _state.createProductRequest;
  set createProductRequest(CreateProductRequest? value) {
    _setState(_state.copyWith(createProductRequest: value));
  }

  CreateProductTagsRequest? get createProductTagsRequest => _state.createProductTagsRequest;
  set createProductTagsRequest(CreateProductTagsRequest? value) {
    _setState(_state.copyWith(createProductTagsRequest: value));
  }

  DeleteMarketPlaceElementRequest? get deleteElementRequest => _state.deleteElementRequest;
  set deleteElementRequest(DeleteMarketPlaceElementRequest? value) {
    _setState(_state.copyWith(deleteElementRequest: value));
  }

  CreateProductCommentRequest? get createCommentRequest => _state.createCommentRequest;
  set createCommentRequest(CreateProductCommentRequest? value) {
    _setState(_state.copyWith(createCommentRequest: value));
  }

  CreateCommentReplyRequest? get createReplyRequest => _state.createReplyRequest;
  set createReplyRequest(CreateCommentReplyRequest? value) {
    _setState(_state.copyWith(createReplyRequest: value));
  }

  CreateProductCommentReactionsRequest? get createReactionRequest => _state.createReactionRequest;
  set createReactionRequest(CreateProductCommentReactionsRequest? value) {
    _setState(_state.copyWith(createReactionRequest: value));
  }

  UpdateProductDetailsRequest? get updateProductRequest => _state.updateProductRequest;
  set updateProductRequest(UpdateProductDetailsRequest? value) {
    _setState(_state.copyWith(updateProductRequest: value));
  }

  UpdateProductTagsRequest? get updateTagsRequest => _state.updateTagsRequest;
  set updateTagsRequest(UpdateProductTagsRequest? value) {
    _setState(_state.copyWith(updateTagsRequest: value));
  }

  UpdateProductCommentRequest? get updateCommentRequest => _state.updateCommentRequest;
  set updateCommentRequest(UpdateProductCommentRequest? value) {
    _setState(_state.copyWith(updateCommentRequest: value));
  }

  UpdateProductCommentReactionRequest? get updateReactionRequest => _state.updateReactionRequest;
  set updateReactionRequest(UpdateProductCommentReactionRequest? value) {
    _setState(_state.copyWith(updateReactionRequest: value));
  }

  // Response getters and setters
  MarketPlaceProductResponse? get marketproducts => _state.marketProducts;
  set marketproducts(MarketPlaceProductResponse? value) {
    _setState(_state.copyWith(marketProducts: value));
  }

  MarketplaceCommentResponse? get marketComments => _state.marketComments;
  set marketComments(MarketplaceCommentResponse? value) {
    _setState(_state.copyWith(marketComments: value));
  }

  MarketplaceTagResponse? get marketTags => _state.marketTags;
  set marketTags(MarketplaceTagResponse? value) {
    _setState(_state.copyWith(marketTags: value));
  }

  MarketplaceCommentReplyResponse? get marketReplies => _state.marketReplies;
  set marketReplies(MarketplaceCommentReplyResponse? value) {
    _setState(_state.copyWith(marketReplies: value));
  }

  MarketplaceCommentReactionResponse? get marketReactions => _state.marketReactions;
  set marketReactions(MarketplaceCommentReactionResponse? value) {
    _setState(_state.copyWith(marketReactions: value));
  }

  CreateProductResponse? get createProductResponse => _state.createProductResponse;
  set createProductResponse(CreateProductResponse? value) {
    _setState(_state.copyWith(createProductResponse: value));
  }

  CreateProductTagsResponse? get createTagsResponse => _state.createTagsResponse;
  set createTagsResponse(CreateProductTagsResponse? value) {
    _setState(_state.copyWith(createTagsResponse: value));
  }

  DeleteMarketPlaceElementResponse? get deleteElementResponse => _state.deleteElementResponse;
  set deleteElementResponse(DeleteMarketPlaceElementResponse? value) {
    _setState(_state.copyWith(deleteElementResponse: value));
  }

  CreateProductCommentResponse? get createCommentResponse => _state.createCommentResponse;
  set createCommentResponse(CreateProductCommentResponse? value) {
    _setState(_state.copyWith(createCommentResponse: value));
  }

  CreateCommentReplyResponse? get createReplyResponse => _state.createReplyResponse;
  set createReplyResponse(CreateCommentReplyResponse? value) {
    _setState(_state.copyWith(createReplyResponse: value));
  }

  CreateProductCommentReactionsResponse? get createReactionResponse =>
      _state.createReactionResponse;
  set createReactionResponse(CreateProductCommentReactionsResponse? value) {
    _setState(_state.copyWith(createReactionResponse: value));
  }

  UpdateProductDetailsResponse? get updateProductResponse => _state.updateProductResponse;
  set updateProductResponse(UpdateProductDetailsResponse? value) {
    _setState(_state.copyWith(updateProductResponse: value));
  }

  UpdateProductTagsResponse? get updateTagsResponse => _state.updateTagsResponse;
  set updateTagsResponse(UpdateProductTagsResponse? value) {
    _setState(_state.copyWith(updateTagsResponse: value));
  }

  UpdateProductCommentResponse? get updateCommentResponse => _state.updateCommentResponse;
  set updateCommentResponse(UpdateProductCommentResponse? value) {
    _setState(_state.copyWith(updateCommentResponse: value));
  }

  UpdateProductCommentReactionResponse? get updateReactionResponse => _state.updateReactionResponse;
  set updateReactionResponse(UpdateProductCommentReactionResponse? value) {
    _setState(_state.copyWith(updateReactionResponse: value));
  }

  MarketViewModel() {
    scrollController.addListener(_scrollListener);
  }

  void _setState(MarketState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> _handleApiCall(Future<Either<Failure, dynamic>> Function() apiCall) async {
    _setState(_state.copyWith(isLoading: true));
    _clearErrors(); // Clear any existing errors when starting a new call

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (success) {
          _handleSuccess(success);
          _clearErrors(); // Ensure errors are cleared after success
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(_state.copyWith(isLoading: false));
    }
  }

  void _handleSuccess(dynamic response) {
    if (response is MarketplaceCommentReactionResponse) {
      _setState(_state.copyWith(marketReactions: response));
      if (kDebugMode) {
        log('Market Reactions $_state.marketReactions');
      }
    } else if (response is MarketplaceCommentReplyResponse) {
      _setState(_state.copyWith(marketReplies: response));
      if (kDebugMode) {
        log('Market Replies $_state.marketReplies');
      }
    } else if (response is MarketplaceTagResponse) {
      _setState(_state.copyWith(marketTags: response));
      if (kDebugMode) {
        log('Market Tags $_state.marketTags');
      }
    } else if (response is MarketplaceCommentResponse) {
      _setState(_state.copyWith(marketComments: response));
      if (kDebugMode) {
        log('Market Comments $_state.marketComments');
      }
    } else if (response is MarketPlaceProductResponse) {
      _setState(_state.copyWith(marketProducts: response));
      if (kDebugMode) {
        log('Market Products $_state.marketProducts');
      }
    } else if (response is CreateProductResponse) {
      _setState(_state.copyWith(createProductResponse: response));
    } else if (response is CreateProductTagsResponse) {
      _setState(_state.copyWith(createTagsResponse: response));
    } else if (response is DeleteMarketPlaceElementResponse) {
      _setState(_state.copyWith(deleteElementResponse: response));
    } else if (response is CreateProductCommentResponse) {
      _setState(_state.copyWith(createCommentResponse: response));
    } else if (response is CreateCommentReplyResponse) {
      _setState(_state.copyWith(createReplyResponse: response));
    } else if (response is CreateProductCommentReactionsResponse) {
      _setState(_state.copyWith(createReactionResponse: response));
    } else if (response is UpdateProductDetailsResponse) {
      _setState(_state.copyWith(updateProductResponse: response));
    } else if (response is UpdateProductTagsResponse) {
      _setState(_state.copyWith(updateTagsResponse: response));
    } else if (response is UpdateProductCommentResponse) {
      _setState(_state.copyWith(updateCommentResponse: response));
    } else if (response is UpdateProductCommentReactionResponse) {
      _setState(_state.copyWith(updateReactionResponse: response));
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

  Future<bool> getAllMarketElements() async {
    _clearErrors(); // Clear any existing errors when starting refresh
    await getProductTags();
    await getProducts();
    await getProductComments();
    await getProductCommentReplies();
    await getProductCommentReactions();
    return true;
  }

  // Market API Methods
  Future<bool> createProduct() async =>
      _handleApiCall(() => marketPlaceService.createProduct(createProductRequest!));

  Future<bool> createProductTags() async =>
      _handleApiCall(() => marketPlaceService.createProductTags(createProductTagsRequest!));

  Future<bool> getProducts() async => _handleApiCall(
      () => marketPlaceService.getProducts(GetMarketElementsRequest(elementType: 'Products')));
  Future<bool> getProductTags() async => _handleApiCall(
      () => marketPlaceService.getProductTags(GetMarketElementsRequest(elementType: 'Tags')));
  Future<bool> getProductComments() async => _handleApiCall(() =>
      marketPlaceService.getProductComments(GetMarketElementsRequest(elementType: 'Comments')));
  Future<bool> getProductCommentReplies() async => _handleApiCall(() => marketPlaceService
      .getProductCommentReplies(GetMarketElementsRequest(elementType: 'Comment Replies')));
  Future<bool> getProductCommentReactions() async => _handleApiCall(() => marketPlaceService
      .getProductCommentReactions(GetMarketElementsRequest(elementType: 'Comment Reactions')));

  Future<bool> deleteMarketPlaceElement() async =>
      _handleApiCall(() => marketPlaceService.deleteMarketPlaceElement(deleteElementRequest!));

  Future<bool> createProductComment() async =>
      _handleApiCall(() => marketPlaceService.createProductComment(createCommentRequest!));

  Future<bool> createCommentReply() async =>
      _handleApiCall(() => marketPlaceService.createCommentReply(createReplyRequest!));

  Future<bool> createProductCommentReactions() async => _handleApiCall(
      () => marketPlaceService.createProductCommentReactions(createReactionRequest!));

  Future<bool> updateProductDetails() async =>
      _handleApiCall(() => marketPlaceService.updateProductDetails(updateProductRequest!));

  Future<bool> updateProductTags() async =>
      _handleApiCall(() => marketPlaceService.updateProductTags(updateTagsRequest!));

  Future<bool> updateProductComment() async =>
      _handleApiCall(() => marketPlaceService.updateProductComment(updateCommentRequest!));

  Future<bool> updateProductCommentReaction() async =>
      _handleApiCall(() => marketPlaceService.updateProductCommentReaction(updateReactionRequest!));

  void _scrollListener() {
    final isCurrentlyScrollingDown =
        scrollController.position.userScrollDirection == ScrollDirection.reverse;
    final isCurrentlyScrollingUp =
        scrollController.position.userScrollDirection == ScrollDirection.forward;

    if (isCurrentlyScrollingDown && !_state.isScrolling) {
      _setState(_state.copyWith(isScrolling: true));
    } else if (isCurrentlyScrollingUp && _state.isScrolling) {
      _setState(_state.copyWith(isScrolling: false));
    }
  }

  void selectCategory(String category) {
    _setState(_state.copyWith(selectedCategory: category.toLowerCase()));
  }

  void clearSession() {
    _setState(_state.clearRequests().clearResponses().clearErrors());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
