import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/market/presentation/viewmodel/details.dart';
import 'package:solveit/features/market/presentation/viewmodel/filter.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_search.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_viewmodel.dart';
import 'package:solveit/features/market/presentation/viewmodel/report_viewmodel.dart';
import 'package:solveit/features/market/presentation/viewmodel/vendor_profile.dart';

final marketViewModels = <SingleChildWidget>[
  ChangeNotifierProvider<MarketViewModel>(create: (_) => sl<MarketViewModel>()),
  ChangeNotifierProvider<MarketSearchViewModel>(create: (_) => sl<MarketSearchViewModel>()),
  ChangeNotifierProvider<ProductDetailViewModel>(create: (_) => sl<ProductDetailViewModel>()),
  ChangeNotifierProvider<MarketPlaceFilterViewModel>(create: (_) => sl<MarketPlaceFilterViewModel>()),
  ChangeNotifierProvider<ReportViewModel>(create: (_) => sl<ReportViewModel>()),
  ChangeNotifierProvider<VendorViewModel>(create: (_) => sl<VendorViewModel>()),
  ChangeNotifierProvider<ReviewFilterViewModel>(create: (_) => sl<ReviewFilterViewModel>()),
];
