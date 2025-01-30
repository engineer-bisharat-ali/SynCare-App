import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncare/pages/intro_screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen(),)),);
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
