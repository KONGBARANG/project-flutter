import 'package:flutter/material.dart';

// 1. បង្កើត Model ដើម្បីងាយស្រួលគ្រប់គ្រងទិន្នន័យ
class NotificationModel {
  final String id;
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = true,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // ប្រើ Data ពី Model
  List<NotificationModel> notifications = [
    NotificationModel(id: '1', icon: Icons.local_shipping, color: Colors.blue, title: 'Order Shipped!', message: 'Your order #12345 has been shipped.', time: '2 hours ago'),
    NotificationModel(id: '2', icon: Icons.local_offer, color: Colors.orange, title: 'Summer Sale Ending', message: 'Your 50% off coupon expires tonight.', time: '5 hours ago'),
    NotificationModel(id: '3', icon: Icons.check_circle, color: Colors.green, title: 'Payment Successful', message: 'We received your payment.', time: '1 day ago', isUnread: false),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n.isUnread = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Notifications", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text("Mark all as read"),
          )
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey.shade300),
                  const Text("No new notifications"),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (ctx, index) {
                final notif = notifications[index];
                
                return Dismissible(
                  key: Key(notif.id),
                  background: Container(
                    color: Colors.red.shade400,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() => notifications.removeAt(index));
                  },
                  child: Container(
                    color: notif.isUnread ? Colors.deepPurple.shade50.withOpacity(0.3) : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: notif.color.withOpacity(0.1),
                        child: Icon(notif.icon, color: notif.color),
                      ),
                      title: Text(notif.title, style: TextStyle(fontWeight: notif.isUnread ? FontWeight.bold : FontWeight.w500)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif.message),
                          const SizedBox(height: 4),
                          Text(notif.time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                      trailing: notif.isUnread ? const Icon(Icons.circle, size: 10, color: Colors.deepPurple) : null,
                      onTap: () {
                        setState(() => notif.isUnread = false);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}