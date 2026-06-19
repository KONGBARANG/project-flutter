import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  bool isUnread;

  NotificationModel({
    required this.id, required this.icon, required this.color,
    required this.title, required this.message, required this.time,
    this.isUnread = true,
  });
}