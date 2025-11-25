import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';

const Map<int, Color> colorSwatch = {
  50: Color.fromRGBO(131, 7, 78, .1),
  100: Color.fromRGBO(131, 7, 78, .2),
  200: Color.fromRGBO(131, 7, 78, .3),
  300: Color.fromRGBO(131, 7, 78, .4),
  400: Color.fromRGBO(131, 7, 78, .5),
  500: Color.fromRGBO(131, 7, 78, .6),
  600: Color.fromRGBO(131, 7, 78, .7),
  700: Color.fromRGBO(131, 7, 78, .8),
  800: Color.fromRGBO(131, 7, 78, .9),
  900: Color.fromRGBO(131, 7, 78, 1),
};

int getMaterialColorInt(Color color) {
  return (color.a.toInt() << 24) |
      (color.r.toInt() << 16) |
      (color.g.toInt() << 8) |
      color.b.toInt();
}

final solveitThemeLight = ThemeData(
    colorScheme: ColorScheme(
      primary: SolveitColors.primaryColor,
      primaryContainer: colorSwatch[500],
      secondary: SolveitColors.secondaryColor,
      surface: SolveitColors.backgroundColor,
      error: SolveitColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: SolveitColors.onPrimary,
      onSurface: SolveitColors.textColor,
      onSurfaceVariant: SolveitColors.textHeaderColor,
      onError: Colors.white,
      surfaceContainer: SolveitColors.surfaceOnBackground,
      onErrorContainer: SolveitColors.onPrimary,
      tertiary: SolveitColors.successColor,
      errorContainer: SolveitColors.errorColor.withValues(alpha: (0.6)),
      brightness: Brightness.light,
    ),
    primaryColor: SolveitColors.primaryColor,
    scaffoldBackgroundColor: SolveitColors.backgroundColor,
    cardColor: SolveitColors.cardColor,
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(getMaterialColorInt(SolveitColors.primaryColor), colorSwatch),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppinsTextTheme().titleLarge?.copyWith(
          fontSize: 25.sp,
          fontFamilyFallback: ["Roboto"],
          color: SolveitColors.textHeaderColor,
          fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.poppinsTextTheme().titleMedium?.copyWith(
          fontSize: 19.sp,
          fontFamilyFallback: ["Roboto"],
          color: SolveitColors.textHeaderColor,
          fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppinsTextTheme().titleSmall?.copyWith(
          fontSize: 14.sp,
          fontFamilyFallback: ["Roboto"],
          color: SolveitColors.textHeaderColor,
          fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppinsTextTheme().headlineSmall?.copyWith(
          fontSize: 12.sp, fontFamilyFallback: ["Roboto"], color: SolveitColors.textColor),
      headlineMedium: GoogleFonts.poppinsTextTheme().headlineMedium?.copyWith(
          fontSize: 14.sp, fontFamilyFallback: ["Roboto"], color: SolveitColors.textColor),
      headlineLarge: GoogleFonts.poppinsTextTheme().headlineLarge?.copyWith(
          fontSize: 16.sp, fontFamilyFallback: ["Roboto"], color: SolveitColors.textHeaderColor),
      bodyLarge: GoogleFonts.poppinsTextTheme().bodyLarge?.copyWith(
            fontSize: 16.sp,
            fontFamilyFallback: ["Roboto"],
            color: SolveitColors.textColor,
          ),
      bodyMedium: GoogleFonts.poppinsTextTheme().bodyMedium?.copyWith(
          fontSize: 14.sp,
          fontFamilyFallback: ["Roboto"],
          color: SolveitColors.textColor,
          fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.poppinsTextTheme().bodySmall?.copyWith(
            fontSize: 12.sp,
            fontFamilyFallback: ["Roboto"],
            color: SolveitColors.textColor,
          ),
      labelSmall: GoogleFonts.poppinsTextTheme().labelSmall?.copyWith(
            fontSize: 12.sp,
            fontFamilyFallback: ["Roboto"],
            color: SolveitColors.textHeaderColor,
          ),
      labelMedium: GoogleFonts.poppinsTextTheme().labelMedium?.copyWith(
            fontSize: 14.sp,
            fontFamilyFallback: ["Roboto"],
            color: SolveitColors.textHeaderColor,
          ),
      labelLarge: GoogleFonts.poppinsTextTheme().labelLarge?.copyWith(
            fontSize: 14.sp,
            fontFamilyFallback: ["Roboto"],
            color: SolveitColors.textColor,
          ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: SolveitColors.surfaceOnBackground,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: SolveitColors.primaryColor),
      ),
      labelStyle: GoogleFonts.poppinsTextTheme().labelSmall?.copyWith(
            fontSize: 12.sp,
            color: SolveitColors.textColor,
          ),
      hintStyle: TextStyle(
        color: SolveitColors.textColor.withValues(alpha: (0.6)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: SolveitColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
            foregroundColor: SolveitColors.textHeaderColor,
            textStyle: GoogleFonts.poppinsTextTheme().bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: SolveitColors.textHeaderColor,
                ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.w)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
            foregroundColor: SolveitColors.primaryColor,
            textStyle: GoogleFonts.poppinsTextTheme().bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: SolveitColors.primaryColor,
                ),
            side: const BorderSide(color: SolveitColors.primaryColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.w)))),
    iconTheme: IconThemeData(color: SolveitColors.textColor, size: 22.w),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: const WidgetStatePropertyAll(SolveitColors.textColor),
            iconSize: WidgetStatePropertyAll(20.w))),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return SolveitColors.successColor; // Active track color
          }
          return SolveitColors.textColor; // Inactive track color
        },
      ),
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // Active thumb color
          }
          return Colors.white; // Inactive thumb color
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue.withValues(alpha: (0.5)); // Active overlay color
          }
          return Colors.grey.withValues(alpha: (0.5)); // Inactive overlay color
        },
      ),
    ),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: SolveitColors.backgroundColor,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.w),
      ),
    ),
    canvasColor: SolveitColors.backgroundColor);
final solveitThemeDark = ThemeData(
    colorScheme: solveitThemeLight.colorScheme.copyWith(
      primary: SolveitColorsDark.primaryColor,
      surface: SolveitColorsDark.backgroundColor,
      error: SolveitColorsDark.errorColor,
      onPrimary: Colors.white,
      surfaceContainer: SolveitColorsDark.surfaceOnBackground,
      onSecondary: SolveitColors.textHeaderColor,
      onSurface: SolveitColorsDark.textColor,
      onSurfaceVariant: SolveitColorsDark.textHeaderColor,
      onError: Colors.white,
      onErrorContainer: SolveitColorsDark.onPrimary,
      errorContainer: SolveitColorsDark.errorColor.withValues(alpha: (0.6)),
      brightness: Brightness.dark,
    ),
    primaryColor: SolveitColorsDark.primaryColor,
    scaffoldBackgroundColor: SolveitColorsDark.backgroundColor,
    cardColor: SolveitColorsDark.cardColor,
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(getMaterialColorInt(SolveitColorsDark.primaryColor), colorSwatch),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      titleLarge: solveitThemeLight.textTheme.titleLarge?.copyWith(
        color: SolveitColorsDark.textHeaderColor,
      ),
      titleMedium: solveitThemeLight.textTheme.titleMedium?.copyWith(
        color: SolveitColorsDark.textHeaderColor,
      ),
      titleSmall: solveitThemeLight.textTheme.titleSmall?.copyWith(
        color: SolveitColorsDark.textHeaderColor,
      ),
      headlineSmall:
          solveitThemeLight.textTheme.headlineSmall?.copyWith(color: SolveitColorsDark.textColor),
      headlineMedium:
          solveitThemeLight.textTheme.headlineMedium?.copyWith(color: SolveitColors.textColor),
      headlineLarge: solveitThemeLight.textTheme.headlineLarge
          ?.copyWith(color: SolveitColorsDark.textHeaderColor),
      bodyLarge: solveitThemeLight.textTheme.bodyLarge?.copyWith(
        color: SolveitColors.textColor,
      ),
      bodyMedium: solveitThemeLight.textTheme.bodyMedium?.copyWith(
        color: SolveitColorsDark.textColor,
      ),
      bodySmall: GoogleFonts.poppinsTextTheme().bodySmall?.copyWith(
            fontSize: 12.sp,
            color: SolveitColorsDark.textColor,
          ),
      labelSmall: GoogleFonts.poppinsTextTheme().labelSmall?.copyWith(
            fontSize: 12.sp,
            color: SolveitColorsDark.textColor,
          ),
      labelMedium: GoogleFonts.poppinsTextTheme().labelMedium?.copyWith(
            fontSize: 14.sp,
            color: SolveitColorsDark.textColor,
          ),
      labelLarge: GoogleFonts.poppinsTextTheme().labelLarge?.copyWith(
            fontSize: 14.sp,
            color: SolveitColorsDark.textColor,
          ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: SolveitColorsDark.surfaceOnBackground,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: SolveitColorsDark.primaryColor),
      ),
      labelStyle: GoogleFonts.poppinsTextTheme().labelSmall?.copyWith(
            fontSize: 12.sp,
            color: SolveitColorsDark.textColor,
          ),
      hintStyle: GoogleFonts.poppinsTextTheme().bodySmall?.copyWith(
            color: SolveitColorsDark.textColor.withValues(alpha: (0.6)),
          ),
    ),
    iconTheme: IconThemeData(color: SolveitColorsDark.textColor, size: 22.w),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: const WidgetStatePropertyAll(SolveitColorsDark.textColor),
            iconSize: WidgetStatePropertyAll(20.w))),
    filledButtonTheme: solveitThemeLight.filledButtonTheme,
    outlinedButtonTheme: solveitThemeLight.outlinedButtonTheme,
    buttonTheme: solveitThemeLight.buttonTheme,
    canvasColor: SolveitColorsDark.backgroundColor);

final horizontalPadding = EdgeInsets.symmetric(horizontal: 16.w);
final defCornerRadius = 10.w;
