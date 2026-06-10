import 'package:flutter/material.dart';

class ApiTestScreen extends StatelessWidget {
  const ApiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: call API service
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('API test tapped')),
            );
          },
          child: const Text('Call API test'),
        ),
      ),
    );
  }
}
