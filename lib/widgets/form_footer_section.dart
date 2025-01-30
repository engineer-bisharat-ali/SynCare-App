import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';

class FormFooterSection extends StatelessWidget {
  const FormFooterSection({
    super.key,
    required this.onTap,
    required this.text1,
    required this.text2,
    });

    final VoidCallback onTap;
    final String text1;
    final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          text1,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        GestureDetector(
          onTap:onTap,
          child: Text(
            text2,
            style: const TextStyle(
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
