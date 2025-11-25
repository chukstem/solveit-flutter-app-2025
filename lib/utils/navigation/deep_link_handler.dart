import 'package:flutter/material.dart';

class DeepLinkHandler {
  static void handleDeepLink(BuildContext context, Uri uri) {
    if (uri.scheme != 'solveit') return;

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    final resourceType = pathSegments[0];
    final resourceId = pathSegments.length > 1 ? pathSegments[1] : null;

    if (resourceId == null) return;

    switch (resourceType) {
      case 'posts':
        // Navigate to the post details screen
        Navigator.pushNamed(
          context,
          '/single-post',
          arguments: {'postId': int.tryParse(resourceId)},
        );
        break;
      // Add more cases for other resource types as needed
      default:
        // Handle unknown resource types
        break;
    }
  }
}
