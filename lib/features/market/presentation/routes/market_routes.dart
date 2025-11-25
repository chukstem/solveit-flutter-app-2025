import 'package:go_router/go_router.dart';
import 'package:solveit/features/market/presentation/pages/market_search.dart';
import 'package:solveit/features/market/presentation/pages/product_details.dart';
import 'package:solveit/features/market/presentation/pages/report_screen.dart';
import 'package:solveit/features/market/presentation/pages/vendor_profile.dart';
import 'package:solveit/features/market/presentation/pages/vendor_reviews.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';

final marketRoutes = [
  GoRoute(
    path: SolveitRoutes.marketSearchScreen.route,
    pageBuilder: (context, state) =>
        getTransition(const MarketSearchScreen(), state),
  ),
  GoRoute(
    path: SolveitRoutes.marketProductDetails.route,
    pageBuilder: (context, state) =>
        getTransition(const ProductDetailsScreen(), state),
  ),
  GoRoute(
    path: SolveitRoutes.reportProductOrVendor.route,
    pageBuilder: (context, state) => getTransition(const ReportScreen(), state),
  ),
  GoRoute(
    path: SolveitRoutes.vendorProfile.route,
    pageBuilder: (context, state) =>
        getTransition(const VendorProfileContent(), state),
  ),
  GoRoute(
    path: SolveitRoutes.vendorReview.route,
    pageBuilder: (context, state) =>
        getTransition(const ReviewsScreenContent(), state),
  ),
];
