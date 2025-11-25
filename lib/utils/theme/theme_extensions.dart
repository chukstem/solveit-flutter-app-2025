import 'package:flutter/material.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';

/// Extension on BuildContext to provide easy access to theme properties
extension ThemeContext on BuildContext {
  // Colors - Light Theme
  Color get primaryColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.primaryColor
      : SolveitColorsDark.primaryColor;
  Color get primaryColor100 => SolveitColors.primaryColor100;
  Color get primaryColor200 => SolveitColors.primaryColor200;
  Color get primaryColor300 => SolveitColors.primaryColor300;
  Color get primaryColor400 => SolveitColors.primaryColor400;

  Color get secondaryColor => SolveitColors.secondaryColor;
  Color get secondaryColor100 => SolveitColors.secondaryColor100;
  Color get secondaryColor200 => SolveitColors.secondaryColor200;
  Color get secondaryColor300 => SolveitColors.secondaryColor300;
  Color get secondaryColor400 => SolveitColors.secondaryColor400;

  Color get tertiaryColor => SolveitColors.tertiaryColor;
  Color get tertiaryColor100 => SolveitColors.tertiaryColor100;
  Color get tertiaryColor200 => SolveitColors.tertiaryColor200;
  Color get tertiaryColor300 => SolveitColors.tertiaryColor300;
  Color get tertiaryColor400 => SolveitColors.tertiaryColor400;

  Color get successColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.successColor
      : SolveitColorsDark.successColor;
  Color get successColor100 => SolveitColors.successColor100;
  Color get successColor200 => SolveitColors.successColor200;
  Color get successColor300 => SolveitColors.successColor300;
  Color get successColor400 => SolveitColors.successColor400;

  Color get errorColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.errorColor
      : SolveitColorsDark.errorColor;
  Color get errorColor100 => SolveitColors.errorColor100;
  Color get errorColor200 => SolveitColors.errorColor200;
  Color get errorColor300 => SolveitColors.errorColor300;
  Color get errorColor400 => SolveitColors.errorColor400;

  Color get surfaceOnBackground => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.surfaceOnBackground
      : SolveitColorsDark.surfaceOnBackground;
  Color get gradientPrimary => SolveitColors.gradientPrimary;
  Color get textHeaderColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.textHeaderColor
      : SolveitColorsDark.textHeaderColor;
  Color get backgroundColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.backgroundColor
      : SolveitColorsDark.backgroundColor;
  Color get cardColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.cardColor
      : SolveitColorsDark.cardColor;
  Color get textColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.textColor
      : SolveitColorsDark.textColor;
  Color get textColorHint => SolveitColors.textColorHint;
  Color get primaryBlue => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.primaryBlue
      : SolveitColorsDark.primaryBlue;
  Color get onPrimary => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.onPrimary
      : SolveitColorsDark.onPrimary;
  Color get orangeColor => Theme.of(this).brightness == Brightness.light
      ? SolveitColors.orangeColor
      : SolveitColorsDark.orangeColor;
  Color get pendingColor => SolveitColors.pendingColor;

  // ColorScheme Convenience Getters
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;
  Color get onErrorContainer => Theme.of(this).colorScheme.onErrorContainer;
  Color get surfaceContainer => Theme.of(this).colorScheme.surfaceContainer;

  // Text Styles
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  // Theme Data
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppBarTheme get appBarTheme => Theme.of(this).appBarTheme;
  IconThemeData get iconTheme => Theme.of(this).iconTheme;
  InputDecorationTheme get inputDecorationTheme => Theme.of(this).inputDecorationTheme;
  ButtonThemeData get buttonTheme => Theme.of(this).buttonTheme;
  FilledButtonThemeData get filledButtonTheme => Theme.of(this).filledButtonTheme;
  OutlinedButtonThemeData get outlinedButtonTheme => Theme.of(this).outlinedButtonTheme;
  SwitchThemeData get switchTheme => Theme.of(this).switchTheme;
  IconButtonThemeData get iconButtonTheme => Theme.of(this).iconButtonTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Spacing and Dimensions
  double get spacing => 8.0;
  double get spacingSmall => 4.0;
  double get spacingLarge => 16.0;
  double get spacingXLarge => 24.0;
  double get spacingXXLarge => 32.0;

  // Border Radius
  BorderRadius get borderRadius => BorderRadius.circular(8.0);
  BorderRadius get borderRadiusSmall => BorderRadius.circular(4.0);
  BorderRadius get borderRadiusLarge => BorderRadius.circular(12.0);
  BorderRadius get borderRadiusXLarge => BorderRadius.circular(16.0);
  BorderRadius get borderRadiusCircular => BorderRadius.circular(100.0);

  // Shadows
  List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
  List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
  List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  // Durations
  Duration get durationFast => const Duration(milliseconds: 200);
  Duration get durationNormal => const Duration(milliseconds: 300);
  Duration get durationSlow => const Duration(milliseconds: 500);
}
