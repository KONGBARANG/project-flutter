import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;             // អក្សរដែលត្រូវបង្ហាញលើប៊ូតុង
  final VoidCallback onPressed;  // Action ពេលចុចលើប៊ូតុង
  final bool isLoading;          // ស្ថានភាពកំពុង Loading (បើ true វានឹងវិលជុំវិញជំនួសអក្សរ)
  final Color? backgroundColor;   // ពណ៌ផ្ទៃប៊ូតុង (បើមិនបោះមកទេ វានឹងយកពណ៌ស្វាយលំនាំដើម)

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // បើកំពុង Loading គឺមិនឱ្យអ្នកប្រើចុចជាន់គ្នាបានទេ (onPressed = null)
      onPressed: isLoading ? null : onPressed, 
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFF673AB7), // ពណ៌ស្វាយដិត
        minimumSize: const Size(double.infinity, 50), // ទទឹងពេញ កម្ពស់ ៥០ ស្អាតសមសួន
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // ជ្រុងមូល ១២px
        ),
        // ប្តូរពណ៌ស្រមោល និងពណ៌ទឹកបាញ់ពេលចុចឱ្យមើលទៅកាន់តែ Modern
        disabledBackgroundColor: (backgroundColor ?? const Color(0xFF673AB7)).withAlpha(128),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5, // កម្រាស់រង្វង់វិល
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}