import 'package:flutter/material.dart';

class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // បង្កើត Controller សម្រាប់គ្រប់គ្រងទិន្នន័យ (អ្នកអាចភ្ជាប់ជាមួយ Provider នៅពេលក្រោយ)
    final TextEditingController nameController = TextEditingController(text: "GUEST USER");
    final TextEditingController emailController = TextEditingController(text: "guest@example.com");
    final TextEditingController phoneController = TextEditingController(text: "+855 12 345 678");

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'Manage Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ១. ផ្នែកបង្ហាញរូបថត Profile និងប៊ូតុងប្តូររូប
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.deepPurple,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      onPressed: () {
                        // មុខងារជ្រើសរើសរូបថត
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ២. ផ្នែកប្រអប់បញ្ចូលទិន្នន័យ (Input Fields)
            _buildInputField(
              label: 'Full Name',
              controller: nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Email Address',
              controller: emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Phone Number',
              controller: phoneController,
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),

            // ៣. ប៊ូតុងរក្សាទុកការផ្លាស់ប្តូរ (Save Button)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // បន្ថែម Logic រក្សាទុកទិន្នន័យនៅត្រង់នេះ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
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
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ជំនួយសម្រាប់បង្កើត Input Field ស្អាតៗ
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.deepPurple, size: 20),
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