import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // 1. Logo ឬ Icon របស់ App
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple.withOpacity(0.1),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 50,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our App Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 32),

            // 2. សំណេររៀបរាប់ពីក្រុមហ៊ុន/App (Our Story)
            _buildSectionCard(
              context,
              title: 'Our Story',
              icon: Icons.history,
              content:
                  'Welcome to our platform! Founded with a vision to simplify daily lives, our app provides a seamless and innovative solution tailored to your needs. We are dedicated to delivering the best user experience through cutting-edge technology and constant improvement.',
            ),
            const SizedBox(height: 16),

            // 3. បេសកកម្ម និង ចក្ខុវិស័យ (Mission & Vision)
            _buildSectionCard(
              context,
              title: 'Our Mission',
              icon: Icons.lightbulb_outline,
              content:
                  'To empower individuals and businesses by providing intuitive, reliable, and secure digital tools that enhance efficiency and connectedness.',
            ),
            const SizedBox(height: 16),

            // 4. ព័ត៌មានទំនាក់ទំនង (Contact Us)
            _buildSectionCard(
              context,
              title: 'Contact Us',
              icon: Icons.connect_without_contact,
              child: Column(
                children: [
                  _buildContactTile(Icons.email_outlined, 'support@example.com'),
                  const Divider(height: 20, thickness: 0.5),
                  _buildContactTile(Icons.phone_android_outlined, '+855 12 345 678'),
                  const Divider(height: 20, thickness: 0.5),
                  _buildContactTile(Icons.location_on_outlined, 'Phnom Penh, Cambodia'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 5. រក្សាសិទ្ធិខាងក្រោម (Footer)
            Center(
              child: Text(
                '© 2026 Your Company. All rights reserved.',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ជំនួយការបង្កើត Card សម្រាប់ផ្នែកនីមួយៗ
  Widget _buildSectionCard(BuildContext context,
      {required String title, required IconData icon, String? content, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  // ជំនួយការបង្កើតជួរព័ត៌មានទំនាក់ទំនង
  Widget _buildContactTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}