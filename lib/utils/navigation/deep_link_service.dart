import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  static StreamSubscription? _subscription;
  static bool _initialUriIsHandled = false;
  static GoRouter? _router;
  static final _appLinks = AppLinks();

  static void setRouter(GoRouter router) {
    _router = router;
  }

  static Future<void> initDeepLinks() async {
    // Handle links when the app is started from a link
    if (!_initialUriIsHandled) {
      try {
        final initialUri = await _appLinks.getInitialLink();
        if (initialUri != null) {
          _handleDeepLink(initialUri);
        }
      } catch (e) {
        // Handle invalid links
      }
      _initialUriIsHandled = true;
    }

    // Handle links when the app is already running
    _subscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      // Handle errors
    });
  }

  static void _handleDeepLink(Uri uri) {
    if (uri.scheme != 'solveit' || _router == null) return;

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    final resourceType = pathSegments[0];
    final resourceId = pathSegments.length > 1 ? pathSegments[1] : null;

    if (resourceId == null) return;

    switch (resourceType) {
      case 'posts':
        // Navigate to the post details screen
        _router!.go('/posts/$resourceId');
        break;
      // Add more cases for other resource types as needed
      default:
        // Handle unknown resource types
        break;
    }
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
