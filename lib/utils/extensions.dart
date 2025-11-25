import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/dialog/halert_dialog.dart';
import 'package:solveit/utils/snackbars/snackbars.dart';
import 'package:solveit/utils/utils/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toastification/toastification.dart';

final defRadius = 16.sp;

Future<String?> selectDate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 16),
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime.now());

  if (pickedDate != null) {
    final date = DateFormat('yyyy-MM-dd').format(pickedDate);
    return date;
  }
  return null;
}

extension BuildContextExtensions on BuildContext {
  AppLocalizations? getLocalization() {
    return AppLocalizations.of(this);
  }

  Future<T?> goToScreen<T extends Object?>(AbstractSolveitRoutes route,
      {List<String>? params}) async {
    return params != null ? push("${route.route}/${params.join("/")}") : push(route.route);
  }

  void replaceScreen(AbstractSolveitRoutes route, {List<String>? params}) {
    params != null ? replace("${route.route}/${params.join("/")}") : replace(route.route);
  }

  void popToScreen(AbstractSolveitRoutes route) {
    go(route.route);
  }

  Size getSize() {
    return MediaQuery.sizeOf(this);
  }

  double getBottomPadding() {
    return MediaQuery.of(this).padding.bottom;
  }

  double getTopPadding() {
    return MediaQuery.of(this).padding.top;
  }

  double getBottomInsets() {
    return MediaQuery.of(this).viewInsets.bottom;
  }

  double getCombinedBottomPadding() {
    return getBottomPadding() + getBottomInsets();
  }

  double getWidth() {
    return getSize().width;
  }

  double getHeight() {
    return getSize().height;
  }

  Future<T?> showBottomSheet<T>(Widget sheet,
      {double maxHeightFactor = 0.85, bool isDismissible = true}) {
    return showModalBottomSheet<T?>(
      useRootNavigator: true,
      context: this,
      isDismissible: isDismissible,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: cardColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.getBottomPadding()),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * maxHeightFactor,
                  ),
                  child: Wrap(
                    children: [
                      sheet,
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> showError(String error) async {
    ScaffoldMessenger.of(this).showSnackBar(hErrorSnackbar(error, this));
  }

  Future<void> showSuccess(String message) async {
    ScaffoldMessenger.of(this).showSnackBar(hSuccessSnackbar(message, this));
  }

  void dismissKeybaord() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// shows a predefined toast widget base on the parameters
  ///
  /// you can use this method to show a built-in toasts
  ///
  /// the return value is a [ToastificationItem] that you can use to dismiss the notification
  /// or find the notification details by its [id]
  /// 0 is success, 1 is error and 2 is info when passed in type
  ///
  /// ```
  Future<void> showToast(String message, ToastType type) async {
    final onForeground = type == ToastType.info ? surfaceOnBackground : onPrimary;
    toastification.show(
      context: this,
      title: Text(message, style: bodySmall?.copyWith(color: onForeground)),
      icon: FaIcon(FontAwesomeIcons.circleInfo, size: 25.w, color: onForeground),
      backgroundColor: type == ToastType.info
          ? cardColor
          : type == ToastType.error
              ? errorColor
              : tertiaryColor,
      showProgressBar: false,
      primaryColor: primaryColor,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  showCustomDialog(Widget dialogChild) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(scale: curve, child: Dialog(child: dialogChild));
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
    );
  }

  Future<Object?> getAlertDialog(String title, String description,
      {String? icon,
      String? iconpng,
      String? buttonText,
      bool shouldPop = true,
      bool hideNegative = false,
      required VoidCallback onPositiveClick,
      VoidCallback? onDismiss}) async {
    return showGeneralDialog(
      context: this,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Dialog(
            child: HAlertDialog(
              title: title,
              icon: icon,
              iconpng: iconpng,
              hideNegative: hideNegative,
              description: description,
              buttonText: buttonText ?? getLocalization()!.continuee,
              onButtonClikced: () {
                try {
                  if (GoRouter.of(ctx).canPop() && shouldPop) {
                    Navigator.of(ctx).pop(true);
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
                onPositiveClick.call();
              },
              onCancelClikced: () {
                if (GoRouter.of(ctx).canPop()) {
                  onDismiss?.call();
                  Navigator.of(ctx).pop(false);
                }
              },
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
    );
  }
}

extension StringExtension2 on String? {
  bool isUser() {
    return this == "user";
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String parseError(BuildContext context) {
    return this == unknownErrorString
        ? context.getLocalization()!.something_went_wrong
        : this == kTimeOutError
            ? context.getLocalization()!.poor_slow_network
            : this == kInternetConnectionError
                ? context.getLocalization()!.you_are_offline
                : this;
  }

  String formatDate() {
    try {
      DateTime parsedDate = DateTime.parse(this);

      // Convert to local time zone if needed
      DateTime localDate = parsedDate.toLocal();

      // Format the DateTime object into a readable format
      return DateFormat('MMMM d, yyyy, h:mm a').format(localDate);
    } catch (e) {
      return this;
    }
  }

  String formatDateTimeAgo() {
    try {
      DateTime parsedDate = DateTime.parse(this);

      // Convert to local time zone if needed
      DateTime localDate = parsedDate.toLocal();

      // Format the DateTime object into a readable format
      return timeago.format(localDate);
    } catch (e) {
      return this;
    }
  }
}

enum ToastType { success, error, info }

void dismissKeybaord() {
  FocusManager.instance.primaryFocus?.unfocus();
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension IndexedIterable<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension ListGetOrNull<T> on List<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

extension ColorExtension on Color {
  /// Creates a new color with the specified alpha value.
  Color withValues({double? red, double? green, double? blue, double? alpha}) {
    return Color.fromRGBO(
      (red != null) ? (red * 255).round() : r.toInt(),
      (green != null) ? (green * 255).round() : g.toInt(),
      (blue != null) ? (blue * 255).round() : b.toInt(),
      alpha ?? a,
    );
  }
}
