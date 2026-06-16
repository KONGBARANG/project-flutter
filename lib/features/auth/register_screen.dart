import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../providers/language_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _nameC, label: 'Name'),
            const SizedBox(height: 12),
            CustomTextField(controller: _emailC, label: 'Email'),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _passC,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_loading)
              const CircularProgressIndicator()
            else
              Builder(builder: (context) {
                final langProvider = Provider.of<LanguageProvider>(context);

                // ទាញយកពាក្យបកប្រែ បើគ្មានទេ (null ឬ ទទេ) ឱ្យដាក់ពាក្យ 'Register' ជំនួសដើម្បីការពារកុំឱ្យបាត់អក្សរ
                String registerText = langProvider.translate('register') ?? 'Register';
                if (registerText.trim().isEmpty) {
                  registerText = 'Register';
                }

                return FilledButton(
                  onPressed: () async {
                    final name = _nameC.text.trim();
                    final email = _emailC.text.trim();
                    final pass = _passC.text;
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    String? error;
                    if (name.isEmpty) error = langProvider.translate('name_required') ?? 'Name is required';
                    if (error == null && email.isEmpty) {
                      error = langProvider.translate('email_required') ?? 'Email is required';
                    }
                    if (error == null &&
                        !RegExp(
                          r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}",
                        ).hasMatch(email)) {
                      error = langProvider.translate('invalid_email') ?? 'Invalid email address';
                    }
                    if (error == null && pass.length < 6) {
                      error = langProvider.translate('password_min_6') ?? 'Password must be at least 6 characters';
                    }

                    if (error != null) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }

                    setState(() => _loading = true);
                    // Simulate registering process
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (!mounted) return;
                    setState(() => _loading = false);

                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('${langProvider.translate('registered') ?? 'Registered successfully:'} $name')),
                    );

                    // Navigate to login and prefill email
                    if (!mounted) return;
                    navigator.pushNamed('/login', arguments: {'email': email});
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7), // ពណ៌ស្វាយដិតស្របតាមម៉ូតរបស់បង
                    minimumSize: const Size(double.infinity, 50), // ទទឹងពេញ កម្ពស់ ៥០ ងាយស្រួលចុច
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // ជ្រុងមូលស្អាតសមសួន
                    ),
                  ),
                  child: Text(
                    registerText, // បង្ហាញអក្សរដែលបានផ្ទៀងផ្ទាត់រួច (ធានាថាមិនបាត់អក្សរទៀតឡើយ)
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}