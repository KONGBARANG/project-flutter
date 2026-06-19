import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/theme_provider.dart';
import '../notification/notification_screen.dart';

// 🔥 ដំណោះស្រាយ៖ កែតម្រូវផ្លូវ Import ឱ្យត្រឹមត្រូវ (ដក /screens/ ចេញ ព្រោះស្ថិតក្នុង Folder ជាមួយគ្នាស្រាប់)
import './screens/manage_profile_screen.dart';
import './screens/password_security_screen.dart';
import './screens/about_us_screen.dart';
import './screens/appointments_screen.dart'; 
import './screens/help_center_screen.dart';
import './screens/privacy_policy_screen.dart';
import './screens/terms_of_service_screen.dart';
 // 🔥 កែតម្រូវផ្លូវ Import ឱ្យត្រឹមត្រូវ

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final String userName = authProvider.email?.split('@').first ?? 'Guest User';
    final String userEmail = authProvider.email ?? 'user@example.com';
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          langProvider.translate('profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Header Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      return GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            profileProvider.setAvatar(File(pickedFile.path));
                          }
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: const Color.fromRGBO(103, 58, 183, 0.1),
                              child: profileProvider.avatar == null
                                  ? const Icon(Icons.person, size: 40, color: Colors.deepPurple)
                                  : ClipOval(
                                      child: Image.file(
                                        profileProvider.avatar!,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.deepPurple,
                                child: const Icon(Icons.edit, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. ផ្នែក Account (Manage Profile ដំណើរការបានយ៉ាងរលូន)
            _buildSectionTitle('Account'),
            _buildGroupCard([
              _buildListTile(Icons.person_outline, 'Manage Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageProfileScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(Icons.lock_open_outlined, 'Password & Security', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PasswordSecurityScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(Icons.notifications_none_outlined, 'Notifications', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(
                Icons.translate, 
                'Language', 
                () => _showLanguageDialog(context, langProvider),
                trailingText: langProvider.currentLocale == 'en' ? 'English' : 'Khmer',
              ),
            ]),
            const SizedBox(height: 20),

            // 3. ផ្នែក Preferences
            _buildSectionTitle('Preferences'),
            _buildGroupCard([
              _buildListTile(Icons.assignment_outlined, 'About Us', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(
                Icons.brightness_6_outlined, 
                'Theme', 
                () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
                trailingText: themeProvider.isDarkMode ? 'Dark' : 'Light',
              ),
              _buildDivider(),
              _buildListTile(Icons.calendar_today_outlined, 'Appointments', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
                );
              }),
            ]),
            const SizedBox(height: 20),

            // 4. ផ្នែក Support
            _buildSectionTitle('Support'),
            
            _buildGroupCard([
              _buildListTile(Icons.help_outline, 'Help Center', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                );
              }),
              _buildDivider(),
              _buildListTile(Icons.description_outlined, 'Terms of Service', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
                );
              }),
            ]),
            const SizedBox(height: 24),

            // 5. ប៊ូតុង Log Out
            Center(
              child: TextButton.icon(
                onPressed: () {
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, {String? trailingText}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: Colors.grey[700], size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[300], size: 14),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 54,
      color: const Color.fromRGBO(238, 238, 238, 0.5),
    );
  }

  void _showProfileInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider langProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language / ជ្រើសរើសភាសា'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English (US)'),
                trailing: langProvider.currentLocale == 'en' ? const Icon(Icons.check, color: Colors.purple) : null,
                onTap: () {
                  langProvider.changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ភាសាខ្មែរ (Khmer)'),
                trailing: langProvider.currentLocale == 'km' ? const Icon(Icons.check, color: Colors.purple) : null,
                onTap: () {
                  langProvider.changeLanguage('km');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}