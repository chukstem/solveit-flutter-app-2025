import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final Color iconColor;
  final bool isRead;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? title,
    String? description,
    String? date,
    IconData? icon,
    Color? iconColor,
    bool? isRead,
  }) {
    return NotificationItem(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsState {
  final List<NotificationItem> notifications;

  const NotificationsState({
    this.notifications = const [],
  });

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }

  static NotificationsState get initial => const NotificationsState(
        notifications: [
          NotificationItem(
            title: "MalvinNice",
            description: "published a new product in the marketplace",
            date: "Today",
            icon: Icons.storefront,
            iconColor: Colors.orange,
          ),
          NotificationItem(
            title: "MalvinNice",
            description: "posted a new service you may need",
            date: "Yesterday",
            icon: Icons.business_center,
            iconColor: Colors.purple,
          ),
          NotificationItem(
            title: "MalvinNice",
            description: "published a new product in the marketplace",
            date: "28 March",
            icon: Icons.chat,
            iconColor: Colors.green,
          ),
          NotificationItem(
            title: "Your shop is getting noticed",
            description: "You have 120 shop visitors this week",
            date: "2 days",
            icon: Icons.storefront,
            iconColor: Colors.orange,
          ),
          NotificationItem(
            title: "N2,000 deposited",
            description: "has been deposited in your wallet",
            date: "2 days",
            icon: Icons.account_balance_wallet,
            iconColor: Colors.green,
          ),
          NotificationItem(
            title: "Your items",
            description: "have been updated",
            date: "2 days",
            icon: Icons.store,
            iconColor: Colors.green,
          ),
        ],
      );
}

class NotificationsViewModel extends ChangeNotifier {
  NotificationsState _state = NotificationsState.initial;
  NotificationsState get state => _state;

  List<NotificationItem> get notifications => _state.notifications;

  void _setState(NotificationsState state) {
    _state = state;
    notifyListeners();
  }

  void markAllAsRead() {
    final updatedNotifications = _state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();

    _setState(_state.copyWith(notifications: updatedNotifications));
  }
}
