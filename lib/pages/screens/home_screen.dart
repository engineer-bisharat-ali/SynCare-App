import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/auths/forgot_password_page.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/services/auth_services/auth_services.dart';

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
    return Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.bottomRight,
          
          child: Container(
            margin: EdgeInsets.only(bottom: 105, right: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle
            ),
            
            child:FloatingActionButton(
            onPressed:signOut,
            backgroundColor: primaryColor,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
                    ),
          ),
        ),
      ),
      
    );
  }
}
