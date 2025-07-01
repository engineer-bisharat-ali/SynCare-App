import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/pages/helper_classess/onboarding_helper.dart';
import 'package:syncare/pages/intro_screens/onboarding_screen.dart';
import 'package:syncare/services/api_services/symptoms_api_service.dart';
import 'package:syncare/widgets/bottom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const primaryColor = Color(0x9C00BCD3);
  
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late AnimationController _heartbeatController;
  late AnimationController _dnaController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _heartbeatAnimation;
  late Animation<double> _dnaAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _dnaController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Initialize animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _heartbeatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _heartbeatController,
      curve: Curves.easeInOut,
    ));

    _dnaAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _dnaController,
      curve: Curves.linear,
    ));

    // Start animations
    _startAnimations();
    _navigateAfterDelay();
    SymptomsApiService.predictDisease([
      'itching',
      'skin_rash',
      'nodal_skin_eruptions',
      'headache',
      'fatigue',
      'back_pain',
      'cramps'
    ]);
  }

  void _startAnimations() {
    _logoController.forward();
    _backgroundController.repeat();
    _pulseController.repeat(reverse: true);
    _heartbeatController.repeat(reverse: true);
    _dnaController.repeat();
  }

  void _navigateAfterDelay() async {
    // Add a delay to show the splash screen
    await Future.delayed(const Duration(seconds: 8));
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
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _pulseController.dispose();
    _heartbeatController.dispose();
    _dnaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Healthcare gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E8), // Light mint green
                  Color(0xFFE1F5FE), // Light cyan
                  Color(0xFFF3E5F5), // Light purple
                ],
              ),
            ),
          ),

          // Animated medical pattern overlay
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: MedicalPatternPainter(
                  _backgroundAnimation.value,
                  primaryColor,
                ),
                size: Size(screenWidth, screenHeight),
              );
            },
          ),

          // DNA Helix Animation
          AnimatedBuilder(
            animation: _dnaAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: DNAHelixPainter(
                  _dnaAnimation.value,
                  primaryColor,
                ),
                size: Size(screenWidth, screenHeight),
              );
            },
          ),

          // Floating medical particles
          ...List.generate(15, (index) {
            return AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                final offset = _backgroundAnimation.value * 2 * math.pi;
                final icons = ['💊', '🩺', '❤️', '🧬', '⚕️'];
                return Positioned(
                  left: screenWidth * 0.1 + 
                      (screenWidth * 0.8 * math.sin(offset + index * 0.4)),
                  top: screenHeight * 0.15 + 
                      (screenHeight * 0.7 * math.cos(offset + index * 0.3)),
                  child: Opacity(
                    opacity: 0.3,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * math.sin(offset + index),
                      child: Text(
                        icons[index % icons.length],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main logo section
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _logoScaleAnimation,
                _logoFadeAnimation,
                _pulseAnimation,
                _heartbeatAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value * _pulseAnimation.value,
                  child: Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Heartbeat pulse rings
                          Transform.scale(
                            scale: _heartbeatAnimation.value,
                            child: Container(
                              height: screenWidth * 0.45,
                              width: screenWidth * 0.45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          
                          // Medical cross background
                          Container(
                            height: screenWidth * 0.35,
                            width: screenWidth * 0.35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.9),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                                width: 3,
                              ),
                            ),
                          ),
                          
                          // Logo
                          SizedBox(
                            height: screenWidth * 0.35,
                            width: screenWidth * 0.35,
                            child: SvgPicture.asset(
                              "Assets/icons/ic-SynCare-logo.svg",
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Health-themed loading section
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _logoFadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Column(
                    children: [
                      // Custom health-themed progress indicator
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                                backgroundColor: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: primaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Caring for Your Health...',
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'SynCare • Healthcare Redefined',
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Health stats visualization
          Positioned(
            top: 80,
            right: 30,
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.3,
                  child: CustomPaint(
                    painter: HealthStatsPainter(
                      _backgroundAnimation.value,
                      primaryColor,
                    ),
                    size: const Size(100, 80),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalPatternPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  MedicalPatternPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw medical cross patterns
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        final centerX = (size.width / 4) * (i + 0.5);
        final centerY = (size.height / 3) * (j + 0.5);
        final sizeCross = 20 + 5 * math.sin(animationValue * 2 * math.pi + i + j);
        
        // Draw cross
        canvas.drawLine(
          Offset(centerX - sizeCross, centerY),
          Offset(centerX + sizeCross, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX, centerY - sizeCross),
          Offset(centerX, centerY + sizeCross),
          paint,
        );
      }
    }

    // Draw EKG/heartbeat pattern
    paint.strokeWidth = 2;
    paint.color = primaryColor.withOpacity(0.15);
    
    final path = Path();
    final heartbeatPattern = [0, 0.2, 0.8, -0.5, 1.2, -0.8, 0.3, 0];
    
    for (int line = 0; line < 3; line++) {
      final y = size.height * (0.2 + 0.3 * line);
      path.reset();
      
      for (int i = 0; i < size.width ~/ 20; i++) {
        final x = i * 20.0 + (animationValue * 40) % 40;
        final patternIndex = i % heartbeatPattern.length;
        final heartY = y + heartbeatPattern[patternIndex] * 30;
        
        if (i == 0) {
          path.moveTo(x, heartY);
        } else {
          path.lineTo(x, heartY);
        }
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DNAHelixPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  DNAHelixPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw DNA helix on the left side
    final path1 = Path();
    final path2 = Path();
    
    for (int i = 0; i < 50; i++) {
      final progress = i / 50.0;
      final x1 = 50 + 30 * math.sin(progress * 4 * math.pi + animationValue);
      final x2 = 50 - 30 * math.sin(progress * 4 * math.pi + animationValue);
      final y = size.height * progress;
      
      if (i == 0) {
        path1.moveTo(x1, y);
        path2.moveTo(x2, y);
      } else {
        path1.lineTo(x1, y);
        path2.lineTo(x2, y);
      }
      
      // Draw connecting lines
      if (i % 5 == 0) {
        canvas.drawLine(
          Offset(x1, y),
          Offset(x2, y),
          Paint()
            ..color = primaryColor.withOpacity(0.1)
            ..strokeWidth = 1,
        );
      }
    }
    
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HealthStatsPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  HealthStatsPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {

    // Draw animated bar chart representing health stats
    final bars = [0.6, 0.8, 0.4, 0.9, 0.7];
    final barWidth = size.width / bars.length;
    
    for (int i = 0; i < bars.length; i++) {
      final animatedHeight = size.height * bars[i] * 
          (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi + i * 0.5));
      
      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth + 5,
          size.height - animatedHeight,
          barWidth - 10,
          animatedHeight,
        ),
        Paint()
          ..color = primaryColor.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}