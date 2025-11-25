import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:solveit/features/authentication/presentation/widgets/generic_bottom_sheet.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';

void showYouAreOfflineSheet(BuildContext context) {
  void popScreen() {
    context.pop();
  }

  context.showBottomSheet(
      GenericBottomSheet(
        title: context.getLocalization()!.you_are_offline,
        icon: networkIcon,
        body: context.getLocalization()!.turn_on_your_internet_connection,
        actionText: context.getLocalization()!.turn_on_data,
        onAction: () async {
          switch (OpenSettingsPlus.shared) {
            case OpenSettingsPlusAndroid settings:
              {
                await settings.dataRoaming();
                try {
                  popScreen();
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            case OpenSettingsPlusIOS settings:
              {
                await settings.cellular();
                try {
                  popScreen();
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
          }
        },
      ),
      maxHeightFactor: 0.8);
}

void showPoorNetworkSheet(BuildContext context, VoidCallback onRetry) {
  context.showBottomSheet(
      GenericBottomSheet(
        title: context.getLocalization()!.poor_slow_network,
        icon: networkIcon,
        body: context
            .getLocalization()!
            .your_internet_connection_seems_to_be_poor,
        actionText: context.getLocalization()!.retry,
        onAction: () async {
          onRetry();
        },
      ),
      maxHeightFactor: 0.8);
}
