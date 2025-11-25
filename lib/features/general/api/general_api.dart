import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/utils/exceptions.dart';
import 'package:solveit/core/network/utils/failures.dart';

abstract class GeneralApi {
  Future<Either<Failure, File>> retrieveFile(String query);
}

class GeneralApiImplementation extends GeneralApi {
  Future<Either<ApiFailure, T>> _getRequest<T>(String url) async {
    try {
      final response = await apiClient.get(url);
      return right(response.data);
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<Failure, File>> retrieveFile(String query) async {
    return await _getRequest(generalEndpoints.retrieveFile(query));
  }
}
