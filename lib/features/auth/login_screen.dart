import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../services/local_data_service.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['email'] != null && _emailC.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _emailC.text = args['email'];
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _emailC, label: 'Email'),
            const SizedBox(height: 12),
            CustomTextField(controller: _passC, label: 'Password', obscureText: true),
            const SizedBox(height: 20),
            
            // ប្រើប្រាស់ Builder ដើម្បីទាញយកភាសាមកដាក់លើប៊ូតុង
            Builder(builder: (context) {
              final langProvider = Provider.of<LanguageProvider>(context);
              
              // ទាញយកពាក្យបកប្រែ បើគ្មានទេ (null ឬ ទទេ) ឱ្យដាក់ពាក្យ 'Login' ជំនួសដើម្បីកុំឱ្យបាត់អក្សរ
              String loginText = langProvider.translate('login') ?? 'Login';
              if (loginText.trim().isEmpty) {
                loginText = 'Login';
              }

              return FilledButton(
                onPressed: () async {
                  final email = _emailC.text.trim();
                  final password = _passC.text;
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          langProvider.translate('please_fill_email_pass') ?? 'Please fill in email and password'
                        ),
                      ),
                    );
                    return;
                  }

                  // Validate credentials against database
                  final user = await LocalDataService.validateLogin(email, password);
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          langProvider.translate('invalid_credentials') ?? 'Invalid email or password'
                        ),
                      ),
                    );
                    return;
                  }

                  // Update last login date
                  user['lastLoginDate'] = DateTime.now().toIso8601String();
                  await LocalDataService.addOrUpdateUser(user);

                  if (!mounted) return;
                  context.read<AuthProvider>().login(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${langProvider.translate('logged_in_as') ?? 'Logged in as'} $email'
                      ),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7), // ពណ៌ស្វាយដិតស្របតាមម៉ូតរបស់បង
                  minimumSize: const Size(double.infinity, 50), // ទទឹងពេញ កម្ពស់ ៥០ ងាយស្រួលចុច
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // ជ្រុងមូលស្អាតសមសួន
                  ),
                ),
                child: Text(
                  loginText, // បង្ហាញអក្សរដែលបានផ្ទៀងផ្ទាត់រួច (ធានាថាមិនបាត់អក្សរទៀតឡើយ)
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            // ប៊ូតុង Quick Login សម្រាប់ចូលដោយមិនបញ្ចូលទិន្នន័យ
            Builder(builder: (context) {
              final langProvider = Provider.of<LanguageProvider>(context);
              return TextButton(
                onPressed: () {
                  const guestEmail = 'guest@example.com';
                  context.read<AuthProvider>().login(guestEmail);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${langProvider.translate('logged_in_as') ?? 'Logged in as'} $guestEmail'
                      ),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Quick Login'),
              );
            }),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}