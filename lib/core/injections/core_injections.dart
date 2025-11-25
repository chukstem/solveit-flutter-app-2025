import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/forum.dart';
import 'package:solveit/core/injections/home.dart';
import 'package:solveit/core/injections/market.dart';
import 'package:solveit/core/injections/media.dart';
import 'package:solveit/core/injections/messages.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/core/injections/school.dart';
import 'package:solveit/core/injections/services.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/authentication/domain/user_token.dart';
import 'package:solveit/firebase_options.dart';
import 'package:solveit/main.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:solveit/utils/navigation/deep_link_service.dart';

final sl = GetIt.instance;

final apiClient = sl<ApiClient>();
final userTokenRepository = sl<UserTokenRepository>();

class CoreInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<GoRouter>(() => solveitRouter);
    sl.registerLazySingleton<Location>(() => Location());
    sl.registerLazySingleton<Geolocator>(() => Geolocator());
    if (kIsWeb) {
      // Register the Web implementation
      sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoWeb());
      // DO NOT register InternetConnectionChecker here
    } else {
      // Register the Mobile/Desktop implementation
      sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
      sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: sl()));
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton<UserTokenRepository>(() => UserTokenRepositoryImpl(sharedPreferences: sl()));
    sl.registerLazySingleton<ApiClient>(() => ApiClient(userTokenRepository: sl(), networkInfo: sl()));
    sl.registerLazySingleton<SocketClient>(() => SocketClient(userTokenRepository: sl()));

    AuthInjectionContainer.initialize();
    SchoolInjectionContainer.initialize();
    AdminInjectionContainer.initialize();
    PostsInjectionContainer.initialize();
    MessagesInjectionContainer.initialize();
    HomeInjectionContainer.initialize();
    MediaInjectionContainer.initialize();
    MarketInjectionContainer.initialize();
    ServicesInjectionContainer.initialize();
    ForumInjectionContainer.initialize();
    if (!kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    DeepLinkService.setRouter(router);
    DeepLinkService.initDeepLinks();
  }
}
