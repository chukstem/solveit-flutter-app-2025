import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void changeNavigationBarColor(BuildContext context) {
  // Get the current theme brightness
  final brightness = Theme.of(context).brightness;
  final backgroundColor = Theme.of(context).colorScheme.surface;

  // Set the navigation bar color and icon brightness dynamically
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: backgroundColor,
    statusBarColor: backgroundColor,
    statusBarBrightness:
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    systemNavigationBarIconBrightness:
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
  ));
}

void changeNavigationBarColorCustomizable(String caller, BuildContext context,
    {Brightness? iconBrightness,
    Brightness? navBrightness,
    Color? navigationBarColor,
    Color? statusBarColor}) {
  // Get the current theme brightness
  debugPrint("Here $caller ${statusBarColor?.toString()}");
  final brightness = iconBrightness ?? MediaQuery.platformBrightnessOf(context);
  final navbrightness =
      navBrightness ?? MediaQuery.platformBrightnessOf(context);
  const backgroundColor = Colors.transparent;
  // Set the navigation bar color and icon brightness dynamically
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: navigationBarColor ?? backgroundColor,
    statusBarColor: statusBarColor,
    statusBarBrightness:
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    statusBarIconBrightness:
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    systemNavigationBarIconBrightness:
        navbrightness == Brightness.dark ? Brightness.light : Brightness.dark,
  ));
}
