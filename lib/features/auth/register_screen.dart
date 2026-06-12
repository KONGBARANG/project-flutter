import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

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
              CustomButton(
                label: 'Register',
                onPressed: () async {
                  final name = _nameC.text.trim();
                  final email = _emailC.text.trim();
                  final pass = _passC.text;
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  String? error;
                  if (name.isEmpty) error = 'Name is required';
                  if (error == null && email.isEmpty)
                    error = 'Email is required';
                  if (error == null &&
                      !RegExp(
                        r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}",
                      ).hasMatch(email))
                    error = 'Invalid email';
                  if (error == null && pass.length < 6)
                    error = 'Password must be at least 6 characters';

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
                    SnackBar(content: Text('Registered $name')),
                  );

                  // Navigate to login and prefill email
                  if (!mounted) return;
                  navigator.pushNamed('/login', arguments: {'email': email});
                },
              ),
          ],
        ),
      ),
    );
  }
}
