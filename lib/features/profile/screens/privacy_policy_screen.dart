import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: _buildDialogContent(context, isDark),
        ),
      ),
    );
  }

  // បង្កើតផ្ទាំងបង្ហាញរាងមូលស្រទន់ដូចរូបភាពគំរូ
  Widget _buildDialogContent(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2EBF9), // ពណ៌ផ្ទៃស្រទន់
        borderRadius: BorderRadius.circular(28.0), // គែមមូលខ្លាំង
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Text(
            'View the app privacy policy and data handling details.',
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.4),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 15), // ពណ៌ប៊ូតុង
              ),
            ),
          ),
        ],
      ),
    );
  }
}