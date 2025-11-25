import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';

class HRatingBar extends StatelessWidget {
  final double initialRating;
  final double? itemSize;
  final Function(double rating) onRatingChanged;

  const HRatingBar(
      {super.key,
      this.itemSize,
      required this.onRatingChanged,
      this.initialRating = 0})
      : super();

  @override
  Widget build(BuildContext context) {
    return RatingBar(
        initialRating: initialRating,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        ratingWidget: RatingWidget(
          full: SvgPicture.asset(
            ratingStarSvg,
            width: 20.w,
            height: 20.h,
          ),
          half: SvgPicture.asset(
            ratingHalfEmptySvg,
            width: 20.w,
            height: 20.h,
          ),
          empty: SvgPicture.asset(
            ratingEmptySvg,
            width: 20.w,
            height: 20.h,
          ),
        ),
        itemSize: itemSize ?? 20.w,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        onRatingUpdate: (rating) {
          onRatingChanged(rating);
        });
  }
}
