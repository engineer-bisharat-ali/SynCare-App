import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/pages/helper_classess/onboarding_helper.dart';
import 'package:syncare/pages/intro_screens/onboarding_screen.dart';
import 'package:syncare/pages/screens/home_screen.dart';
import 'package:syncare/widgets/bottom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    // Add a delay to show the splash screen
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // await FirebaseAuth.instance.signOut();

    bool isOnboardingCompleted = await OnboardingHelper.isOnboardingCompleted();
    User? user = FirebaseAuth.instance.currentUser;

    //for ensure the value to validate
    print("Onboarding Completed: $isOnboardingCompleted"); // 🔍 Debug line
    print("User: $user");


    if (user != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      }
    } else {
      if (isOnboardingCompleted) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // To access the Screen size we use MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SizedBox(
          // Responsive width and height adjust
          height: screenWidth * 0.3, // 50% of screen width
          width: screenheight * 0.4, // 50% of screen height
          child: SvgPicture.asset("Assets/icons/ic-SynCare-logo.svg"),
        ),
      ),
    );
  }
}
