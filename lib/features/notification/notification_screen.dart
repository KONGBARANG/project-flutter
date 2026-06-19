import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications
    final List<Map<String, dynamic>> notifications = [
      {
        'icon': Icons.local_shipping,
        'color': Colors.blue,
        'title': 'Order Shipped!',
        'message': 'Your order #12345 has been shipped and is on the way.',
        'time': '2 hours ago',
        'isUnread': true,
      },
      {
        'icon': Icons.local_offer,
        'color': Colors.orange,
        'title': 'Summer Sale Ending',
        'message': 'Don\'t miss out! Your 50% off coupon expires tonight.',
        'time': '5 hours ago',
        'isUnread': true,
      },
      {
        'icon': Icons.check_circle,
        'color': Colors.green,
        'title': 'Payment Successful',
        'message': 'We received your payment for the Fjallraven Backpack.',
        'time': '1 day ago',
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Logic to mark all as read
            },
            child: const Text("Mark all as read"),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          
          return Container(
            // Gives a slight purple tint to unread notifications
            color: notif['isUnread'] ? Colors.deepPurple.shade50.withOpacity(0.4) : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: (notif['color'] as Color).withOpacity(0.1),
                child: Icon(notif['icon'] as IconData, color: notif['color'] as Color),
              ),
              title: Text(
                notif['title'] as String,
                style: TextStyle(
                  fontWeight: notif['isUnread'] ? FontWeight.bold : FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    notif['message'] as String,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notif['time'] as String,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              // Shows a small dot if the notification hasn't been read
              trailing: notif['isUnread']
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox.shrink(),
              onTap: () {
                // TODO: Navigate to the order details or promo page
              },
            ),
          );
        },
      ),
    );
  }
}