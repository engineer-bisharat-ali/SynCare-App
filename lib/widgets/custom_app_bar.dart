import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';

// A custom reusable AppBar for the Syncare app.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Title text shown in the center
  final VoidCallback? onBack; // Back button action (if any)
  final Color backgroundColor; // Optional background color
  final List<Widget>? actions; // Optional trailing icons

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.backgroundColor = primaryColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,

      // Title Text
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      // Optional back button if `onBack` is provided
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 22,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            )
          : const SizedBox.shrink(),

      // Optional trailing icons (e.g., Share button, settings, etc.)
      actions: actions,
    );
  }

  // Required for AppBar to define its height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
