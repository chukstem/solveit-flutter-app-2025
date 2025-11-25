const _baseUrl = "https://solve-it-backend-v2.onrender.com/api/v1/";

extension BaseUrlExtension on String {
  String get base => '$_baseUrl$this';
}

final authEndpoints = _AuthEndpoints();
final schoolEndpoints = _SchoolEndpoints();
final postEndpoints = _PostEndpoints();
final adminEndpoints = _AdminEndpoints();

final generalEndpoints = _GeneralEndpoints();

final marketPlaceEndpoints = _MarketPlaceEndpoints();
final servicesEndpoints = _ServicesEndpoints();

class _ServicesEndpoints {
  final getCoreServices = "core-services/getCoreServices".base;
  final createCoreService = "core-services/createCoreService".base;
  final updateCoreService = "core-services/updateCoreService".base;

  final getCoreServiceRatings = "core-services/getCoreServiceRatings".base;
  final createCoreServiceRating = "core-services/createCoreServiceRating".base;
  final updateCoreServiceRating = "core-services/updateCoreServiceRating".base;

  final getCoreServicePayments = "core-services/getCoreServicePayments".base;
  final updateCoreServicePayment = "core-services/updateCoreServicePayment".base;
  final updateCoreServicePaymentStatus = "core-services/updateCoreServicePaymentStatus".base;
  final createCoreServicePayment = "core-services/createCoreServicePayment".base;

  final getCoreServiceCategories = "core-services/getCoreServiceCategories".base;
  final updateCoreServiceCategory = "core-services/updateCoreServiceCategory".base;
  final createCoreServiceCategory = "core-services/createCoreServiceCategory".base;

  final getCoreServiceBookings = "core-services/getCoreServiceBookings".base;
  final createCoreServiceBooking = "core-services/createCoreServiceBooking".base;
  final updateCoreServiceBooking = "core-services/updateCoreServiceBooking".base;
  final updateCoreServiceBookingStatus = "core-services/updateCoreServiceBookingStatus".base;

  final getCoreServiceEscrows = "core-services/getCoreServiceEscrows".base;
  final updateCoreServiceEscrows = "core-services/updateCoreServiceEscrows".base;
  final createCoreServiceEscrows = "core-services/createCoreServiceEscrows".base;
  final updateCoreServiceEscrowsStatus = "core-services/updateCoreServiceEscrowsStatus".base;
}

class _MarketPlaceEndpoints {
  final createProduct = "market-place/createProduct".base;
  final createProductTags = "market-place/createProductTag".base;
  final getMarketElements = "market-place/getMarketElement".base;
  final deleteMarketPlaceElement = "market-place/deleteMarketElement".base;
  final createProductComment = "market-place/createProductComment".base;
  final createCommentReply = "market-place/createProductCommentReply".base;
  final createProductCommentReactions = "market-place/createProductCommentReaction".base;
  final updateProductDetails = "market-place/updateProduct".base;
  final updateProductTags = "market-place/updateProductTag".base;
  final updateProductComment = "market-place/updateProductComment".base;
  final updateProductCommentReaction = "market-place/updateProductCommentReaction".base;
}

class _GeneralEndpoints {
  String retrieveFile(String file) => "uploads/$file".base;
}

class _AuthEndpoints {
  final signUpUser = "auth/register".base;
  final signUpStudent = "auth/register".base;
  final getUsers = "user/getAllUsers".base;
  final getStudents = "user/getAllUsers".base;
  String getStudent(s) => "user/getUserProfile/$s".base;
  String getUser(s) => "user/getUserProfile/$s".base;
  final resendCode = "auth/resend-code".base;
  final verifyEmail = "auth/verify-email".base;
  final loginUrl = "auth/login".base; // Supports both email and phone
  final loginEmailUrl = "auth/login".base; // Same endpoint
  final loginPhoneUrl = "auth/login".base; // Same endpoint
  final forgotPassword = "auth/forgot-password".base;
  final resetPassword = "auth/reset-password".base;
  final logout = "auth/logout".base;
  final logoutAll = "auth/logout-all".base;
  final me = "auth/me".base;
  final refreshProfile = "auth/profile/refresh".base;
  final updateAvatar = "auth/update-avatar".base;
  final deleteAvatar = "auth/delete-avatar".base;
  final changePassword = "auth/change-password".base;
  final getSettings = "auth/settings".base;
  final updateSettings = "auth/settings".base;
  final getUserForums = "auth/profile/forums".base;
  final updateLevel = "auth/profile/update-level".base;
  final updateFcmToken = "auth/update-fcm-token".base;
}

class _AdminEndpoints {
  final createSchool = "admin/school/createSchool".base;
  final createFaculty = "admin/school/createFaculty".base;
  final createDepartment = "admin/school/createDepartment".base;
  final createLevel = "admin/school/createLevel".base;
  final getSchoolElements = "admin/school/getSchoolElements".base;

  final createPost = "posts/createPost".base;
  final deletePost = "admin/post/deletePost".base;
  final updatePost = "admin/post/updatePost".base;

  final createCategory = "admin/category/createPostCategory".base;

  final createRole = "admin/roles/getPermissions".base;
  final getRoles = "admin/roles/getRoles".base;
  final createPermission = "admin/roles/createPermission".base;
  final getPermission = "admin/roles/getPermissions".base;
}

class _SchoolEndpoints {
  final getSchools = "admin/school/".base;

  final getSchoolElements = 'admin/school/getSchoolElements'.base;

  String getFaculties(String id) => "admin/school/faculty/$id".base;
  String getDepartments(String id) => "admin/school/department/$id".base;
}

class _PostEndpoints {
  final getCategories = "posts/getCategories".base;
  final getPosts = "posts/getPostElements".base;
  String getPost(String id) => "posts/getPostElements/$id".base;
  final searchPosts = "posts/searchPosts".base;
  String addComment(String postId) => "posts/createPostComment/$postId".base;
  String getComments(String postId) => "posts/getComments/$postId".base;
  String getCommentReplies(String commentId) => "posts/getCommentReplies/$commentId".base;
  String likeComment(String commentId) => "posts/likeComment/$commentId".base;
  String unlikeComment(String commentId) => "posts/unlikeComment/$commentId".base;
  String updateComment(String commentId) => "posts/updateComment/$commentId".base;
  String deleteComment(String commentId) => "posts/deleteComment/$commentId".base;
  String createPostReaction(String postId) => "posts/createPostReaction/$postId".base;
  String deletePostReaction(String postId) => "posts/deletePostReaction/$postId".base;
  String getReactions(String postId) => "posts/getReactions/$postId".base;
  String savePost(String postId) => "posts/savePost/$postId".base;
  final getSavedPosts = "posts/getSavedPosts".base;
  final createPost = "posts/createPost".base;
  String updatePost(String id) => "posts/updatePost/$id".base;
  String deletePost(String id) => "posts/deletePost/$id".base;
}

// KYC Endpoints
final kycEndpoints = _KycEndpoints();

class _KycEndpoints {
  final submit = "kyc/submit".base;
}

// Support Endpoints
final supportEndpoints = _SupportEndpoints();

class _SupportEndpoints {
  final support = "support".base;
  final replySupport = "support/reply".base;
  final closeTicket = "support/close".base;
  final supportUser = "support/user".base;
}

// Order Endpoints
final orderEndpoints = _OrderEndpoints();

class _OrderEndpoints {
  final orderUrl = "order".base;
  final riderOrderUrl = "order/rider".base;
  final customerOrderUrl = "order/sender".base;
  final calculateFare = "order/calculate".base;
  final updatePaymentReceived = "order/update-payment".base;
  final cancelOrder = "order/cancel".base;
}

// Package Endpoints
final packageEndpoints = _PackageEndpoints();

class _PackageEndpoints {
  final getPackageType = "package-type".base;
}

// Payment Endpoints
final paymentEndpoints = _PaymentEndpoints();

class _PaymentEndpoints {
  final getActivePaymentType = "active-payment-type/active".base;
}

// Transaction Endpoints
final transactionEndpoints = _TransactionEndpoints();

class _TransactionEndpoints {
  final transactionUrl = "transaction".base;
  final transactionUserUrl = "transaction/user".base;
}

// Reviews Endpoints
final reviewsEndpoints = _ReviewsEndpoints();

class _ReviewsEndpoints {
  final reviewsUrl = "reviews".base;
}

// Wallet Endpoints
final walletEndpoints = _WalletEndpoints();

class _WalletEndpoints {
  final getAllBanks = "wallet/list-banks".base;
  final getMyAccounts = "wallet/list-accounts".base;
  final addNewBank = "wallet/add-bank".base;
  final withdrawFunds = "wallet/withdraw".base;
  final repayFunds = "wallet/repay".base;
  final fundWallet = "wallet/fund".base;
}

// Statistics Endpoints
final statsEndpoints = _StatsEndpoints();

class _StatsEndpoints {
  final riderStats = "stats/rider-stats".base;
}

// External Endpoints
final externalEndpoints = _ExternalEndpoints();

class _ExternalEndpoints {
  final getAllStates = "https://nga-states-lga.onrender.com/fetch";
  final getAllCityInStates = "https://nga-states-lga.onrender.com/";
}

// Forum Endpoints
final forumEndpoints = _ForumEndpoints();

class _ForumEndpoints {
  final getForums = "forums/".base;
  final createForum = "forums/".base;
  final searchForums = "forums/search".base;
  final getUnreadCount = "forums/unread-count".base;
  String getForum(String id) => "forums/$id".base;
  String updateForum(String id) => "forums/$id".base;
  String deleteForum(String id) => "forums/$id".base;
  String joinForum(String id) => "forums/$id/join".base;
  String leaveForum(String id) => "forums/$id/leave".base;
  String toggleMute(String id) => "forums/$id/toggle-mute".base;
  String markAsRead(String id) => "forums/$id/mark-as-read".base;
  String getMembers(String id) => "forums/$id/members".base;
  String getMedia(String id) => "forums/$id/media".base;
  String getMessages(String id) => "forums/$id/messages".base;
  String sendMessage(String id) => "forums/$id/messages".base;
  String updateMessage(String messageId) => "forums/messages/$messageId".base;
  String deleteMessage(String messageId) => "forums/messages/$messageId".base;
  String removeMember(String id) => "forums/$id/remove-member".base;
  String makeModerator(String id) => "forums/$id/make-moderator".base;
  String removeModerator(String id) => "forums/$id/remove-moderator".base;
  String makeAdmin(String id) => "forums/$id/make-admin".base;
  String removeAdmin(String id) => "forums/$id/remove-admin".base;
}

// Message Endpoints (Private Chats)
final messageEndpoints = _MessageEndpoints();

class _MessageEndpoints {
  final getConversations = "messages/conversations".base;
  String getMessages(String conversationId) => "messages/conversations/$conversationId/messages".base;
  final sendMessage = "messages/send".base;
  final findOrCreateConversation = "messages/conversations/find-or-create".base;
  final createGroupConversation = "messages/conversations/group".base;
  final typingIndicator = "messages/typing".base;
  String markConversationAsRead(String conversationId) => "messages/conversations/$conversationId/read".base;
  String markMessageAsDelivered(String messageId) => "messages/$messageId/delivered".base;
  final markMessagesAsDelivered = "messages/delivered".base;
  String updateMessage(String messageId) => "messages/$messageId".base;
  String deleteMessage(String messageId) => "messages/$messageId".base;
  String addParticipants(String conversationId) => "messages/conversations/$conversationId/participants".base;
  String removeParticipants(String conversationId) => "messages/conversations/$conversationId/participants".base;
  final getUnreadCount = "messages/unread-count".base;
  final searchMessages = "messages/search".base;
  final checkContacts = "contacts/check".base;
}

// Notification Endpoints
final notificationEndpoints = _NotificationEndpoints();

class _NotificationEndpoints {
  final getNotifications = "notifications/".base;
  final createNotification = "notifications/".base;
  final getUnreadCount = "notifications/unread-count".base;
  String markAsRead(String id) => "notifications/mark-as-read/$id".base;
  final markAllAsRead = "notifications/mark-all-as-read".base;
  String deleteNotification(String id) => "notifications/$id".base;
  final deleteAllNotifications = "notifications/".base;
}

// General Endpoints (update existing)
class _GeneralEndpoints {
  String retrieveFile(String file) => "general/retrieveFile/$file".base;
  final getAllStates = "general/getAllStates".base;
  final getAllCities = "general/getAllCityInStates".base;
  final getStats = "general/stats".base;
  final getAppInfo = "general/app-info".base;
  final search = "general/search".base;
}
