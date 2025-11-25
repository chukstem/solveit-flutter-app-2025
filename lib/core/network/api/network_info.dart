import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImpl({required this.internetConnectionChecker}) : super();

  @override
  Future<bool> get isConnected async => internetConnectionChecker.hasConnection;
}

class NetworkInfoWeb implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Always return true for web, as the app wouldn't load without a connection.
    // The actual API call failure will handle true offline scenarios.
    return true;
  }
}
