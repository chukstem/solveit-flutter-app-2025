import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/market.dart';
import 'package:solveit/core/network/utils/failures.dart';
import 'package:solveit/features/market/domain/models/requests/requests.dart';
import 'package:solveit/features/market/domain/models/response/comments.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';
import 'package:solveit/features/market/domain/models/response/reactions.dart';
import 'package:solveit/features/market/domain/models/response/replies.dart';
import 'package:solveit/features/market/domain/models/response/tags.dart';
import 'package:solveit/features/market/domain/models/responses.dart';

abstract class MarketPlaceService {
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

class MarketPlaceServiceImplementation extends MarketPlaceService {
  @override
  Future<Either<Failure, CreateCommentReplyResponse>> createCommentReply(request) {
    return marketPlaceApi.createCommentReply(request);
  }

  @override
  Future<Either<Failure, CreateProductResponse>> createProduct(request) {
    return marketPlaceApi.createProduct(request);
  }

  @override
  Future<Either<Failure, CreateProductCommentResponse>> createProductComment(request) {
    return marketPlaceApi.createProductComment(request);
  }

  @override
  Future<Either<Failure, CreateProductCommentReactionsResponse>> createProductCommentReactions(request) {
    return marketPlaceApi.createProductCommentReactions(request);
  }

  @override
  Future<Either<Failure, CreateProductTagsResponse>> createProductTags(request) {
    return marketPlaceApi.createProductTags(request);
  }

  @override
  Future<Either<Failure, DeleteMarketPlaceElementResponse>> deleteMarketPlaceElement(request) {
    return marketPlaceApi.deleteMarketPlaceElement(request);
  }

  @override
  Future<Either<Failure, UpdateProductCommentResponse>> updateProductComment(request) {
    return marketPlaceApi.updateProductComment(request);
  }

  @override
  Future<Either<Failure, UpdateProductCommentReactionResponse>> updateProductCommentReaction(request) {
    return marketPlaceApi.updateProductCommentReaction(request);
  }

  @override
  Future<Either<Failure, UpdateProductDetailsResponse>> updateProductDetails(request) {
    return marketPlaceApi.updateProductDetails(request);
  }

  @override
  Future<Either<Failure, UpdateProductTagsResponse>> updateProductTags(request) {
    return marketPlaceApi.updateProductTags(request);
  }

  @override
  Future<Either<Failure, MarketplaceCommentReactionResponse>> getProductCommentReactions(req) {
    return marketPlaceApi.getProductCommentReactions(req);
  }

  @override
  Future<Either<Failure, MarketplaceCommentReplyResponse>> getProductCommentReplies(GetMarketElementsRequest req) {
    return marketPlaceApi.getProductCommentReplies(req);
  }

  @override
  Future<Either<Failure, MarketplaceCommentResponse>> getProductComments(GetMarketElementsRequest req) {
    return marketPlaceApi.getProductComments(req);
  }

  @override
  Future<Either<Failure, MarketplaceTagResponse>> getProductTags(GetMarketElementsRequest req) {
    return marketPlaceApi.getProductTags(req);
  }

  @override
  Future<Either<Failure, MarketPlaceProductResponse>> getProducts(GetMarketElementsRequest req) {
    return marketPlaceApi.getProducts(req);
  }
}
