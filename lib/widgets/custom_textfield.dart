import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
	final TextEditingController? controller;
	final String label;
	final bool obscureText;

	const CustomTextField({super.key, this.controller, required this.label, this.obscureText = false});

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: controller,
			obscureText: obscureText,
			decoration: InputDecoration(
				labelText: label,
				border: const OutlineInputBorder(),
				contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
			),
		);
	}
}

