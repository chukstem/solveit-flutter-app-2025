import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/strings.dart';

hErrorSnackbar(String message, BuildContext context) => SnackBar(
    backgroundColor: context.errorColor,
    content: Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(color: context.errorColor),
        child: Row(
          children: [
            FaIcon(
              Icons.cancel,
              size: 25.w,
              color: context.onPrimary,
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: Text(
                message == unknownErrorString ? context.getLocalization()!.something_went_wrong : message,
                style: context.titleSmall?.copyWith(color: context.onPrimary),
              ),
            )
          ],
        ),
      );
    }));

hSuccessSnackbar(String message, BuildContext context) => SnackBar(
      backgroundColor: Colors.green,
      content: Container(
        decoration: const BoxDecoration(color: Colors.green),
        child: Row(
          children: [
            FaIcon(
              Icons.check_circle,
              size: 25.w,
              color: context.onPrimary,
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: Text(
                message,
                style: context.titleSmall?.copyWith(color: context.onPrimary),
              ),
            )
          ],
        ),
      ),
    );
