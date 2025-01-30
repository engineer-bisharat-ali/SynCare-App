import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/services/auth_services/auth_services.dart';

// import '../../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthServices _authServices = AuthServices();

  void signOut() async {
  await _authServices.logout();
  
  if (mounted) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: ElevatedButton(onPressed:signOut,
       child: const Text("logout")),
    );
  }
}