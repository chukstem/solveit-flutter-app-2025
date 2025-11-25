import 'package:flutter/material.dart';
import 'package:solveit/features/home/presentation/viewmodel/notification.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            _buildIconAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationText(context),
                  const SizedBox(height: 5),
                  _buildNotificationDate(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconAvatar() {
    return CircleAvatar(
      backgroundColor: notification.iconColor.withValues(alpha: 0.2),
      child: Icon(notification.icon, color: notification.iconColor),
    );
  }

  Widget _buildNotificationText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "${notification.title} ",
            style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: notification.description,
            style: context.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDate(BuildContext context) {
    return Row(
      children: [
        _buildUnreadIndicator(),
        const SizedBox(width: 5),
        Text(
          notification.date,
          style: context.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return notification.isRead
        ? const SizedBox(width: 8, height: 8) // Empty space if read
        : const Icon(Icons.circle, size: 8, color: Colors.red);
  }
}
