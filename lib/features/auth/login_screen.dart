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
  bool _isLoading = false; // បន្ថែម Loading State ដើម្បីការពារការចុចប៊ូតុងស្ទួន

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
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _emailC, label: 'Email'),
            const SizedBox(height: 12),
            CustomTextField(controller: _passC, label: 'Password', obscureText: true),
            const SizedBox(height: 20),
            
            Builder(builder: (context) {
              final langProvider = Provider.of<LanguageProvider>(context);
              
              String loginText = langProvider.translate('login') ?? 'Login';
              if (loginText.trim().isEmpty) {
                loginText = 'Login';
              }

              return FilledButton(
                onPressed: _isLoading ? null : () async {
                  final email = _emailC.text.trim();
                  final password = _passC.text;
                  
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          langProvider.translate('please_fill_email_pass') ?? 'Please fill in email and password'
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  // ផ្ទៀងផ្ទាត់ការ Login ចេញពី Local File ផ្ទាល់ដែលបានដូរលេខកូដរួច
                  final user = await LocalDataService.validateLogin(email, password);
                  
                  if (user == null) {
                    if (mounted) setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          langProvider.translate('invalid_credentials') ?? 'Invalid email or password'
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // ធ្វើបច្ចុប្បន្នភាពកាលបរិច្ឆេទ Login ចុងក្រោយដោយសុវត្ថិភាព មិនឱ្យប៉ះពាល់លេខកូដសម្ងាត់ថ្មី
                  user['lastLoginDate'] = DateTime.now().toIso8601String();
                  await LocalDataService.addOrUpdateUser(user);

                  if (!mounted) return;
                  
                  // រក្សាទុកស្ថានភាព Login ទៅក្នុង AuthProvider
                  context.read<AuthProvider>().login(email);
                  
                  setState(() => _isLoading = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${langProvider.translate('logged_in_as') ?? 'Logged in as'} $email'
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7), // ពណ៌ស្វាយដិត
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        loginText,
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
                      behavior: SnackBarBehavior.floating,
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