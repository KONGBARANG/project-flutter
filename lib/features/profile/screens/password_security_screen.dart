import 'package:flutter/material.dart';

class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  // បង្កើត Controller សម្រាប់ចាប់យកទិន្នន័យលេខសម្ងាត់
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ប្រែប្រួលសម្រាប់ បិទ/បើក មើលលេខសម្ងាត់ (Show/Hide Password)
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'Password & Security',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your current password to change to a new one.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // ១. ប្រអប់បញ្ចូល លេខសម្ងាត់បច្ចុប្បន្ន
            _buildPasswordField(
              label: 'Current Password',
              controller: _currentPasswordController,
              obscureText: _obscureCurrent,
              onToggleVisibility: () {
                setState(() => _obscureCurrent = !_obscureCurrent);
              },
            ),
            const SizedBox(height: 20),

            // ២. ប្រអប់បញ្ចូល លេខសម្ងាត់ថ្មី
            _buildPasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              obscureText: _obscureNew,
              onToggleVisibility: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            const SizedBox(height: 20),

            // ៣. ប្រអប់បញ្ចូល បញ្ជាក់លេខសម្ងាត់ថ្មី
            _buildPasswordField(
              label: 'Confirm New Password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              onToggleVisibility: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
            ),
            const SizedBox(height: 40),

            // ៤. ប៊ូតុង Update Password
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // កន្លែងដាក់ Logic ផ្ទៀងផ្ទាត់ និងផ្ញើទៅកាន់ Backend/Provider
                  if (_newPasswordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Update Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ជំនួយសម្រាប់បង្កើតប្រអប់ Password ដែលមានរូបភ្នែកបិទបើក
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}