import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/utils/exceptions.dart';
import 'package:solveit/core/network/utils/failures.dart';
import 'package:solveit/features/market/domain/models/requests/requests.dart';
import 'package:solveit/features/market/domain/models/response/comments.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';
import 'package:solveit/features/market/domain/models/response/reactions.dart';
import 'package:solveit/features/market/domain/models/response/replies.dart';
import 'package:solveit/features/market/domain/models/response/tags.dart';
import 'package:solveit/features/market/domain/models/responses.dart';

abstract class MarketPlaceApi {
  Future<Either<Failure, CreateProductResponse>> createProduct(CreateProductRequest request);
  Future<Either<Failure, CreateProductTagsResponse>> createProductTags(CreateProductTagsRequest request);
  Future<Either<Failure, MarketPlaceProductResponse>> getProducts(GetMarketElementsRequest req);
  Future<Either<Failure, MarketplaceCommentResponse>> getProductComments(GetMarketElementsRequest req);
  Future<Either<Failure, MarketplaceTagResponse>> getProductTags(GetMarketElementsRequest req);
  Future<Either<Failure, MarketplaceCommentReplyResponse>> getProductCommentReplies(GetMarketElementsRequest req);
  Future<Either<Failure, MarketplaceCommentReactionResponse>> getProductCommentReactions(GetMarketElementsRequest req);
  Future<Either<Failure, DeleteMarketPlaceElementResponse>> deleteMarketPlaceElement(DeleteMarketPlaceElementRequest request);
  Future<Either<Failure, CreateProductCommentResponse>> createProductComment(CreateProductCommentRequest request);
  Future<Either<Failure, CreateCommentReplyResponse>> createCommentReply(CreateCommentReplyRequest request);
  Future<Either<Failure, CreateProductCommentReactionsResponse>> createProductCommentReactions(CreateProductCommentReactionsRequest request);
  Future<Either<Failure, UpdateProductDetailsResponse>> updateProductDetails(UpdateProductDetailsRequest request);
  Future<Either<Failure, UpdateProductTagsResponse>> updateProductTags(UpdateProductTagsRequest request);
  Future<Either<Failure, UpdateProductCommentResponse>> updateProductComment(UpdateProductCommentRequest request);
  Future<Either<Failure, UpdateProductCommentReactionResponse>> updateProductCommentReaction(UpdateProductCommentReactionRequest request);
}

class MarketPlaceApiImplementation extends MarketPlaceApi {
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

  /// **Generic helper for making API POST requests**
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

  @override
  Future<Either<Failure, CreateCommentReplyResponse>> createCommentReply(request) async {
    return await _postRequest(
      marketPlaceEndpoints.createCommentReply,
      CreateCommentReplyResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, CreateProductResponse>> createProduct(request) async {
    return await _postRequest(
      marketPlaceEndpoints.createProduct,
      CreateProductResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, CreateProductCommentResponse>> createProductComment(request) async {
    return await _postRequest(
      marketPlaceEndpoints.createProductComment,
      CreateProductCommentResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, CreateProductCommentReactionsResponse>> createProductCommentReactions(request) async {
    return await _postRequest(
      marketPlaceEndpoints.createProductCommentReactions,
      CreateProductCommentReactionsResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, CreateProductTagsResponse>> createProductTags(request) async {
    return await _postRequest(
      marketPlaceEndpoints.createProductTags,
      CreateProductTagsResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, DeleteMarketPlaceElementResponse>> deleteMarketPlaceElement(request) async {
    return await _putRequest(
      marketPlaceEndpoints.deleteMarketPlaceElement,
      DeleteMarketPlaceElementResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, UpdateProductCommentResponse>> updateProductComment(request) async {
    return await _putRequest(
      marketPlaceEndpoints.updateProductComment,
      UpdateProductCommentResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, UpdateProductCommentReactionResponse>> updateProductCommentReaction(request) async {
    return await _putRequest(
      marketPlaceEndpoints.updateProductCommentReaction,
      UpdateProductCommentReactionResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, UpdateProductDetailsResponse>> updateProductDetails(request) async {
    return await _putRequest(
      marketPlaceEndpoints.updateProductDetails,
      UpdateProductDetailsResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, UpdateProductTagsResponse>> updateProductTags(request) async {
    return await _putRequest(
      marketPlaceEndpoints.updateProductTags,
      UpdateProductTagsResponse.fromMap,
      data: request.toMap(),
    );
  }

  @override
  Future<Either<Failure, MarketplaceCommentReactionResponse>> getProductCommentReactions(req) async {
    return await _postRequest(marketPlaceEndpoints.getMarketElements, MarketplaceCommentReactionResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<Failure, MarketplaceCommentReplyResponse>> getProductCommentReplies(GetMarketElementsRequest req) async {
    return await _postRequest(marketPlaceEndpoints.getMarketElements, MarketplaceCommentReplyResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<Failure, MarketplaceCommentResponse>> getProductComments(GetMarketElementsRequest req) async {
    return await _postRequest(marketPlaceEndpoints.getMarketElements, MarketplaceCommentResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<Failure, MarketplaceTagResponse>> getProductTags(GetMarketElementsRequest req) async {
    return await _postRequest(marketPlaceEndpoints.getMarketElements, MarketplaceTagResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<Failure, MarketPlaceProductResponse>> getProducts(GetMarketElementsRequest req) async {
    return await _postRequest(marketPlaceEndpoints.getMarketElements, MarketPlaceProductResponse.fromMap, data: req.toMap());
  }
}
