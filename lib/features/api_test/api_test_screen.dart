import 'package:flutter/material.dart';
import '../../services/api_services.dart';

class ApiTestScreen extends StatelessWidget {
  const ApiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              final data = await ApiServices.testGetPosts();
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Title: ${data['title']}')),
              );
            } catch (e) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text('Call API test_Branch NICH12344'),
        ),
      ),
    );
  }
}
