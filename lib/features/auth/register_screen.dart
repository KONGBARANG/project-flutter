import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/language_provider.dart';
import '../../services/local_data_service.dart';

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
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
            
            Builder(builder: (context) {
              final langProvider = Provider.of<LanguageProvider>(context);
              String registerText = langProvider.translate('register') ?? 'Register';
              if (registerText.trim().isEmpty) {
                registerText = 'Register';
              }

              return FilledButton(
                onPressed: _loading ? null : () async {
                  final name = _nameC.text.trim();
                  final email = _emailC.text.trim();
                  final pass = _passC.text;
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  // --- ផ្ទៀងផ្ទាត់ទិន្នន័យបញ្ចូល (Validation) ---
                  String? error;
                  if (name.isEmpty) error = langProvider.translate('name_required') ?? 'Name is required';
                  if (error == null && email.isEmpty) {
                    error = langProvider.translate('email_required') ?? 'Email is required';
                  }
                  if (error == null && !RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(email)) {
                    error = langProvider.translate('invalid_email') ?? 'Invalid email address';
                  }
                  if (error == null && pass.length < 6) {
                    error = langProvider.translate('password_min_6') ?? 'Password must be at least 6 characters';
                  }

                  if (error != null) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  setState(() => _loading = true);
                  
                  // ក្លែងធ្វើជា Loading បន្តិចដើម្បីឱ្យមើលទៅរលូនសមសួន
                  await Future.delayed(const Duration(milliseconds: 600));

                  // --- រក្សាទុកទិន្នន័យចូលក្នុងប្រព័ន្ធ Local ---
                  try {
                    // បង្កើត ID ថ្មីដោយស្វ័យប្រវត្តិផ្អែកលើពេលវេលា
                    final int newId = DateTime.now().millisecondsSinceEpoch;

                    await LocalDataService.addOrUpdateUser({
                      'id': newId,
                      'name': name,
                      'email': email,
                      'password': pass,
                      'registrationDate': DateTime.now().toIso8601String(),
                      'lastLoginDate': '',
                      'isActive': true,
                      'profile': {
                        'avatar': null,
                        'phone': '',
                        'address': '',
                        'city': '',
                        'country': ''
                      }
                    });

                    if (!mounted) return;
                    setState(() => _loading = false);

                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('${langProvider.translate('registered') ?? 'Registered successfully:'} $name'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    // ត្រលប់ទៅកាន់ផ្ទាំង Login វិញ និងបោះទិន្នន័យ Email ទៅបំពេញដោយស្វ័យប្រវត្តិ
                    navigator.pushReplacementNamed('/login', arguments: {'email': email});

                  } catch (e) {
                    if (!mounted) return;
                    setState(() => _loading = false);
                    
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7), // ពណ៌ស្វាយដិតស្របតាម Theme
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        registerText,
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