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
            try {
              final data = await ApiServices.testGetPosts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Title: ${data['title']}')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text('Call API test_Branch NICH'),
        ),
      ),
    );
  }
}
