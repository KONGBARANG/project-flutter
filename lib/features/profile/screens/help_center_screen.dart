import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'Support & Help',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Support Options',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            // ប្លុក Group Card ផ្ទុកប៊ូតុងទាំង ៣
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // ១. ប៊ូតុង Help Center
                  _buildSupportTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    onTap: () => _showCustomDialog(
                      context,
                      title: 'Help Center',
                      message: 'Visit support for help with your account and orders.',
                    ),
                  ),
                  const Divider(height: 1, thickness: 0.5, indent: 56, endIndent: 16),
                  
                  // ២. ប៊ូតុង Privacy Policy
                  _buildSupportTile(
                    icon: Icons.security_rounded,
                    title: 'Privacy Policy',
                    onTap: () => _showCustomDialog(
                      context,
                      title: 'Privacy Policy',
                      message: 'View the app privacy policy and data handling details.',
                    ),
                  ),
                  const Divider(height: 1, thickness: 0.5, indent: 56, endIndent: 16),
                  
                  // ៣. ប៊ូតុង Terms of Service
                  _buildSupportTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => _showCustomDialog(
                      context,
                      title: 'Terms of Service',
                      message: 'Read the terms and conditions for using this app.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  // មុខងារបង្ហាញ Dialog រាងមូលស្អាតពណ៌ស្រទន់
  void _showCustomDialog(BuildContext context, {required String title, required String message}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2EBF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}