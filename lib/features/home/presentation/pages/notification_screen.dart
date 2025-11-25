import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/viewmodel/notification.dart';
import 'package:solveit/features/home/presentation/widgets/notification_tile.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/button/houtlined_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, _) {
        final notifications = viewModel.state.notifications;

        return Scaffold(
          appBar: AppBar(
            leading: backButton(context),
          ),
          body: Column(
            children: [
              _buildHeader(context, viewModel),
              Expanded(
                child: _buildNotificationsList(context, notifications),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, NotificationsViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Notifications", style: context.titleSmall),
          TextButton(
            onPressed: () => _showMarkAllReadDialog(context, viewModel),
            child: Text(
              "Mark all as read",
              style: context.bodySmall?.copyWith(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, List<NotificationItem> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationTile(
          notification: notifications[index],
          onTap: () {
            // Handle notification tap - navigate to relevant screen or mark as read
          },
        );
      },
    );
  }

  /// Show Confirmation Bottom Sheet
  void _showMarkAllReadDialog(BuildContext context, NotificationsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Mark all as read",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to mark all notifications as read? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildDialogButtons(context, viewModel),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogButtons(BuildContext context, NotificationsViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Houtlinedbutton(
            onPressed: () => Navigator.pop(context),
            text: "Cancel",
            textColor: context.colorScheme.outline,
            borderColor: context.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: HFilledButton(
            onPressed: () {
              viewModel.markAllAsRead();
              Navigator.pop(context);
            },
            text: "Mark as read",
          ),
        ),
      ],
    );
  }
}
