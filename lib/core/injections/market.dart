import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/market/data/market_api.dart';
import 'package:solveit/features/market/domain/market_service.dart';
import 'package:solveit/features/market/presentation/viewmodel/details.dart';
import 'package:solveit/features/market/presentation/viewmodel/filter.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_search.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_viewmodel.dart';
import 'package:solveit/features/market/presentation/viewmodel/report_viewmodel.dart';
import 'package:solveit/features/market/presentation/viewmodel/vendor_profile.dart';

final marketPlaceApi = sl<MarketPlaceApi>();
final marketPlaceService = sl<MarketPlaceService>();
final marketSearchViewModel = sl<MarketSearchViewModel>();
final marketViewModel = sl<MarketViewModel>();
final productDetailViewModel = sl<ProductDetailViewModel>();
final marketPlacefilterViewModel = sl<MarketPlaceFilterViewModel>();
final reportViewModel = sl<ReportViewModel>();
final vendorViewModel = sl<VendorViewModel>();
final reviewFilterViewModel = sl<ReviewFilterViewModel>();

class MarketInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<MarketPlaceApi>(() => MarketPlaceApiImplementation());
    sl.registerLazySingleton<MarketPlaceService>(() => MarketPlaceServiceImplementation());

    sl.registerFactory<MarketSearchViewModel>(() => MarketSearchViewModel());
    sl.registerLazySingleton<MarketViewModel>(() => MarketViewModel());
    sl.registerFactory<ProductDetailViewModel>(() => ProductDetailViewModel());
    sl.registerFactory<MarketPlaceFilterViewModel>(() => MarketPlaceFilterViewModel());
    sl.registerFactory<ReportViewModel>(() => ReportViewModel());
    sl.registerFactory<VendorViewModel>(() => VendorViewModel());
    sl.registerFactory<ReviewFilterViewModel>(() => ReviewFilterViewModel());
  }
}
