import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/general.dart';
import 'package:solveit/core/network/utils/failures.dart';

abstract class GeneralService {
  Future<Either<Failure, File>> retrieveFile(String query);
}

class GeneralServiceImplementation extends GeneralService {
  @override
  Future<Either<Failure, File>> retrieveFile(String query) async {
    return await generalApi.retrieveFile(query);
  }
}
