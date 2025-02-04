import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/auths/forgot_password_page.dart';
import 'package:syncare/pages/screens/home_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, // 4% of screen width
          vertical: 15,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, // 3% of screen width
          vertical: screenWidth * 0.02, // 2% of screen width
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GNav(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            hoverColor: primaryColor,
            haptic: true,
            padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
            gap: 8,
            color: Colors.grey.shade800,
            activeColor: Colors.white,
            tabBackgroundColor: primaryColor.withOpacity(0.9),
            tabMargin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            iconSize: screenWidth * 0.065, // Adaptive icon size
            textStyle: TextStyle(
              fontSize: screenWidth * 0.04, // Adaptive text size
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            onTabChange: _onItemTapped,
            tabs: const [
              GButton(icon: Icons.home_rounded, text: "Home"),
              GButton(icon: Icons.file_copy_rounded, text: "Records"),
              GButton(icon: Icons.location_pin, text: "Maps"),
              GButton(icon: Icons.person_rounded, text: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
