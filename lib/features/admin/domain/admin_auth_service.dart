import 'package:dartz/dartz.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/token.dart';

abstract class AdminAuthService {
  Future<Either<Failure, UserToken>> login(String email, String password);
}

class AdminAuthServiceImpl implements AdminAuthService {
  final ApiClient _apiClient;

  AdminAuthServiceImpl(this._apiClient);

  @override
  Future<Either<Failure, UserToken>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/admin/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return Right(UserToken.fromMap(response.data));
    } catch (e) {
      return Left(GenericFailure(message: e.toString()));
    }
  }
}
