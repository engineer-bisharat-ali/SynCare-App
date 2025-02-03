import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';

class CustomFormButton extends StatelessWidget {
  const CustomFormButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Trigger the signup method
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: primaryColor, // Primary button color
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
