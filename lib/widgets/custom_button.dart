import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
	final VoidCallback onPressed;
	final String label;
	final Color? color;

	const CustomButton({super.key, required this.onPressed, required this.label, this.color});

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: double.infinity,
			child: ElevatedButton(
				style: ElevatedButton.styleFrom(
					backgroundColor: color ?? Theme.of(context).colorScheme.primary,
					padding: const EdgeInsets.symmetric(vertical: 14),
				),
				onPressed: onPressed,
				child: Text(label, style: const TextStyle(fontSize: 16)),
			),
		);
	}
}

