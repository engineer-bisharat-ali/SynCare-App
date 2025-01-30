import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';

class Customtextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon textFieldprefixIcon;
  final bool obscureText;
  final IconButton? suffixicon;
  final String? Function(String?)? validator; // Add validator property

  const Customtextfield({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.textFieldprefixIcon,
    this.suffixicon,
    this.validator, // Pass validator function
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator, // Attach the validator to TextFormField
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: primaryColor.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: textFieldprefixIcon,
        prefixIconColor: Colors.grey.shade400,
        suffixIcon: suffixicon,
        suffixIconColor: Colors.grey.shade400,
      ),
    );
  }
}
