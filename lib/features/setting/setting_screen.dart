import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // These variables keep track of whether the switches are ON or OFF
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // 1. Preferences Section
            _buildSectionHeader("Preferences"),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text("Receive updates on orders and sales"),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value; // Updates the toggle visually
                });
              },
            ),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text("Change app theme"),
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value; // Updates the toggle visually
                });
                // Your team can add real theme switching logic here later
              },
            ),
            ListTile(
              title: const Text("Language", style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text("English (US)"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Language Settings...'), duration: Duration(seconds: 1)),
                );
              },
            ),
            
            const Divider(height: 32),
            
            // 2. Support & About Section
            _buildSectionHeader("Support & About"),
            ListTile(
              title: const Text("Help Center", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Terms of Service", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            
            const SizedBox(height: 40),
            
            // 3. App Version
            Center(
              child: Text(
                "App Version 1.0.0",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // A helper method to create the purple section titles
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}