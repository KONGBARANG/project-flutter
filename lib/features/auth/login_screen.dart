import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

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
            CustomButton(
              label: 'Login',
              onPressed: () {
                final email = _emailC.text.trim();
                final password = _passC.text;
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in email and password')),
                  );
                  return;
                }

                context.read<AuthProvider>().login(email);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged in as $email')),
                );
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
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
