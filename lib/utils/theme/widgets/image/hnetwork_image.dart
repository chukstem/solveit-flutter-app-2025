import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

const avatarImage =
    "https://firebasestorage.googleapis.com/v0/b/trepa-mobile.appspot.com/o/StaticImages%2Favatar.png?alt=media&token=98e9ee2b-18b8-4b00-845b-84eaaf45090b";

class Hnetworkimage extends StatelessWidget {
  const Hnetworkimage({super.key, this.image, this.placeholderSize, this.errorWidget, this.fit, this.width, this.height});
  final String? image;
  final double? placeholderSize;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image ?? avatarImage,
      fit: fit ?? BoxFit.fitHeight,
      errorWidget: (BuildContext context, Object exception, Object stackTrace) {
        return errorWidget ??
            Icon(
              Icons.image,
              size: placeholderSize ?? width,
              color: context.surfaceOnBackground,
            );
      },
      placeholder: (BuildContext context, String stackTrace) {
        return const Center(
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      width: width,
      height: height,
    );
  }
}
