import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/pages/screens/home_screen.dart';
import 'package:syncare/services/auth_services/auth_services.dart';
import 'package:syncare/widgets/custom_form_button.dart';
import 'package:syncare/widgets/customtextfield.dart';
import 'package:syncare/widgets/form_footer_section.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthServices _authServices = AuthServices();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // ----------------------------
  // Google Sign-In Method
  // ----------------------------

  signInWIthGoogle() async {
    User? user = await _authServices.signInWithGoogle();

    if (user != null) {
      // Check if the widget is still mounted before pushing a new route
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } else {
      // If registration failed, show an error message (ensure the widget is mounted)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  // ----------------------------
  // Sigup Method
  // ----------------------------
  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;

      try {
        User? user = await _authServices.registerWithEmailAndPassword(
          name,
          email,
          password,
        );

        if (user != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration failed")),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -screenHeight * 0.15,
            left: -screenWidth * 0.4,
            child: Container(
              height: screenWidth * 1.4,
              width: screenWidth * 1.2,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -screenWidth * 1.1,
            child: Container(
              height: screenWidth * 1.5,
              width: screenWidth * 1.5,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.09),
                  SvgPicture.asset(
                    "Assets/icons/ic-SynCare-logo.svg",
                    width: screenWidth * 0.35,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Signup",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Name Input Field with Validation
                        Customtextfield(
                          controller: nameController,
                          obscureText: false,
                          hintText: "Username",
                          textFieldprefixIcon: const Icon(Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Email Input Field with Validation
                        Customtextfield(
                          controller: emailController,
                          obscureText: false,
                          hintText: "Email",
                          textFieldprefixIcon: const Icon(Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password Input Field with Validation
                        Customtextfield(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          hintText: "Password",
                          textFieldprefixIcon: const Icon(Icons.lock),
                          suffixicon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              color: Colors.grey.shade400,
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Signup Button
                        CustomFormButton(
                          onPressed: signUpUser,
                          text: "Signup",
                        ),
                        const SizedBox(height: 20),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              )),
                              SizedBox(width: 10),
                              Text(
                                "or continue with",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: signInWIthGoogle,
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.white,
                            side:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "Assets/images/google-logo.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormFooterSection(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    text1: "Already have an account? ",
                    text2: "Login",
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
