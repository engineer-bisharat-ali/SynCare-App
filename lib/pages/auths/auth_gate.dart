import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncare/pages/intro_screens/splash_screen.dart';
import '../../pages/helper_classess/onboarding_helper.dart';
import '../../widgets/bottom_navbar.dart';
import '../../pages/auths/login_screen.dart';
import '../../pages/intro_screens/onboarding_screen.dart';
import '../../provider/records_provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  late Widget _next;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    // allow splash to animate at least 5 s
    await Future.delayed(const Duration(seconds: 5));

    final user = FirebaseAuth.instance.currentUser;
    final doneOnboarding = await OnboardingHelper.isOnboardingCompleted();

    if (user != null) {
      // open Hive box for signed‑in user
      if (!mounted) return;
      await context.read<RecordsProvider>().initBoxForUser(user.uid);
      _next = const BottomNavbar();
    } else {
      _next = doneOnboarding ? const LoginScreen() : const OnboardingScreen();
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) =>
      _loading ? const SplashScreen() : _next;
}
