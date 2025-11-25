abstract interface class AbstractSolveitRoutes {
  final String route;
  final String? routeWithArgs;
  final String? title;
  final String? fullPath;

  const AbstractSolveitRoutes.create(this.route, this.fullPath, {this.title, this.routeWithArgs});

  factory AbstractSolveitRoutes(String route, {String? routeWithArgs, String? title, String? fullPath}) =>
      _SolveitRoutes(route, routeWithArgs: routeWithArgs, title: title, fullPath: fullPath);
}

class _SolveitRoutes implements AbstractSolveitRoutes {
  @override
  final String route;
  @override
  final String? title;
  @override
  final String? routeWithArgs;
  @override
  final String? fullPath;

  const _SolveitRoutes(this.route, {this.title, this.routeWithArgs, this.fullPath}) : super();
  @override
  String toString() {
    return 'Route: $route, Title: $title, RouteWithArgs: $routeWithArgs, full path: $fullPath';
  }
}

class SolveitRoutes {
  static final onboardingHomeScreen = AbstractSolveitRoutes("/");

  /// AUTHENTICATION SCREENS
  static final registrationScreen = AbstractSolveitRoutes("/registration");
  static final registrationScreenHome = AbstractSolveitRoutes("/registrationHome");
  static final loginScreen = AbstractSolveitRoutes("/login");

  static final resetPassword = AbstractSolveitRoutes("/reset_password");
  static final resetPasswordContinue = AbstractSolveitRoutes("/reset_password_continue");
  static final verifyEmailScreen = AbstractSolveitRoutes("/verify_email_screen");

  static final instituteRegistrationRoute = AbstractSolveitRoutes("/register/institute", routeWithArgs: "/register/institute/:$idParam");

  static final resetpasswordContinueRoute = AbstractSolveitRoutes("/reset_password_continue");
  static final singlePostScreen = AbstractSolveitRoutes("/single_post");
  static final previewSelectedMediaScreen = AbstractSolveitRoutes("/preview_media_screen");

  /// MESSAGES SREENS
  static final messageScreen1 = AbstractSolveitRoutes("/message");
  static final messageScreen2 = AbstractSolveitRoutes("/chatScreen");

  ///Home screens
  static final servicesScreen = AbstractSolveitRoutes("/services");
  static final forumsScreen = AbstractSolveitRoutes("/forums");
  static final marketPlace = AbstractSolveitRoutes("/marketplace");
  static final homeScreen = AbstractSolveitRoutes("/home_screen");

  static final notificationScreen = AbstractSolveitRoutes("/notifications_screen");
  static final homeScreenSearch = AbstractSolveitRoutes("/home_search");

  ///Profile Screen
  static final profileScreen = AbstractSolveitRoutes("/profile_screen");

  ///Markets Routes
  static final marketSearchScreen = AbstractSolveitRoutes('/market_search');
  static final marketProductDetails = AbstractSolveitRoutes('/market_product_details');
  static final reportProductOrVendor = AbstractSolveitRoutes('/report_screen');

  static final vendorProfile = AbstractSolveitRoutes('/vendor_profile_screen');

  static final vendorReview = AbstractSolveitRoutes('/vendor_reviews_screen');

  ///Service Routes
  static final serviceSearchScreen = AbstractSolveitRoutes('/service_search_screen');
  static final serviceProviderProfileScreen = AbstractSolveitRoutes('/service_provider_profile_screen');

  static final serviceDetailsScreen = AbstractSolveitRoutes('/service_provider_details_screen');

  ///Forum Routes
  static final forumChatScreen = AbstractSolveitRoutes('/forum_chat_screen');

  ///Admin Routes
  static final adminLoginScreen = AbstractSolveitRoutes("/admin_login");
  static final adminDashboard = AbstractSolveitRoutes("/admin_dashboard");
}

const orderIdParam = "orderId";
const idParam = "idParam";
const urlParam = "urlParam";
const userIdParam = "userId";
const fileParams = "file";
const bankNameParams = "bankName";
const accountNameParams = "accountName";
const accountNumberParams = "accountNumber";
const bankImageParams = "bankImage";
const bankIdParams = "bankId";
const type = "type";
