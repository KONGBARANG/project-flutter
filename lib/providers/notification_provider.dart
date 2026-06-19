import 'package:flutter/material.dart';
import '../models/notification_model.dart'; // យក Model មកដាក់ទីនេះ

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    // ... data របស់អ្នក ...
  ];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => n.isUnread).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isUnread = false;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) n.isUnread = false;
    notifyListeners();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}