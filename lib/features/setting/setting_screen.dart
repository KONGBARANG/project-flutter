import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart'; // import ចូលមក

class SettingScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    // ហៅប្រើ LanguageProvider
    final langProvider = Provider.of<LanguageProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          langProvider.translate('settings'), // ប្ដូរពាក្យ Settings ទៅតាមភាសា
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // --- ផ្នែក Preferences ---
        Text(
          langProvider.translate('preferences'),
          style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        ListTile(
          title: Text(langProvider.translate('push_notif')),
          subtitle: Text(langProvider.translate('receive_updates')),
          trailing: Switch(
            value: isNotificationOn,
            onChanged: (value) {
              setState(() {
                isNotificationOn = value;
              });
            },
            activeThumbColor: Colors.purple,
          ),
        ),
        
        ListTile(
          title: Text(langProvider.translate('dark_mode')),
          subtitle: Text(langProvider.translate('change_theme')),
          trailing: Switch(
            value: widget.isDarkMode,
            onChanged: (value) {
              widget.onThemeChanged(value);
            },
            activeThumbColor: Colors.purple,
          ),
        ),
        
        ListTile(
          title: Text(langProvider.translate('language')),
          subtitle: Text(langProvider.currentLocale == 'en' ? 'English (US)' : 'ភាសាខ្មែរ (Khmer)'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showLanguageDialog(context, langProvider);
          },
        ),
        
        const Divider(),
        const SizedBox(height: 10),
        
        // --- ផ្នែក Support & About ---
        Text(
          langProvider.translate('support_about'),
          style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        ListTile(
          title: Text(langProvider.translate('help_center')),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          title: Text(langProvider.translate('privacy_policy')),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          title: Text(langProvider.translate('terms')),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'App Version 1.0.0',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
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
                  langProvider.changeLanguage('en'); // ដូរជា English
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ភាសាខ្មែរ (Khmer)'),
                trailing: langProvider.currentLocale == 'km' ? const Icon(Icons.check, color: Colors.purple) : null,
                onTap: () {
                  langProvider.changeLanguage('km'); // ដូរជាភាសាខ្មែរ
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