import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/pages/auths/login_screen.dart';
import 'package:syncare/services/auth_services/auth_services.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen>
    with SingleTickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    
    _fetchUserData();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      if (user?.uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        
        if (mounted) {
          setState(() {
            userData = doc.exists ? doc.data() : null;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

 Future<void> _logout() async {
  final shouldLogout = await _showStyledDialog(
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    icon: Icons.logout,
    color: Colors.red,
    showActions: true,
  );

  if (shouldLogout == true) {
    if (!mounted) return;
    await AuthServices().logout(context); 

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}


  Future<dynamic> _showStyledDialog({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    bool showActions = false,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: !showActions,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Actions
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Row(
                  children: showActions
                      ? [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: Text(title),
                            ),
                          ),
                        ]
                      : [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Got it'),
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$feature coming soon!'),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(height: 16),
                Text(
                  'Loading Profile...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(child: _buildMenuList()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor.withOpacity(0.9), primaryColor.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            userData?['name'] ?? user?.displayName ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              userData?['email'] ?? user?.email ?? 'No email',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: user?.photoURL != null 
                ? NetworkImage(user!.photoURL!) 
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    final menuItems = [
      MenuItemData(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        color: Colors.orange,
        content: 'Stay updated with personalized health reminders, medication alerts, and important updates from your healthcare providers.',
        onTap: () => _showComingSoon('Notifications'),
      ),
      MenuItemData(
        icon: Icons.description_outlined,
        title: 'Terms & Conditions',
        color: Colors.blue,
        content: 'By using SynCare, you agree to our terms of service. This includes responsible use of our health management platform, compliance with applicable laws, and respectful interaction with healthcare providers.',
        onTap: () => _showStyledDialog(
          title: 'Terms & Conditions',
          content: 'By using SynCare, you agree to our terms of service. This includes responsible use of our health management platform, compliance with applicable laws, and respectful interaction with healthcare providers.',
          icon: Icons.description_outlined,
          color: Colors.blue,
        ),
      ),
      MenuItemData(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        color: Colors.green,
        content: 'We protect your personal information and health data with industry-standard security measures. Your data is encrypted, never sold, and only shared with your explicit consent.',
        onTap: () => _showStyledDialog(
          title: 'Privacy Policy',
          content: 'We protect your personal information and health data with industry-standard security measures. Your data is encrypted, never sold, and only shared with your explicit consent.',
          icon: Icons.privacy_tip_outlined,
          color: Colors.green,
        ),
      ),
      MenuItemData(
        icon: Icons.contact_support_outlined,
        title: 'Contact Us',
        color: Colors.purple,
        content: 'Need help? Our support team is here for you!\n\n📧 support@syncare.com\n📞 +1 (555) 123-4567\n💬 24/7 Live Chat Available',
        onTap: () => _showStyledDialog(
          title: 'Contact Us',
          content: 'Need help? Our support team is here for you!\n\n📧 support@syncare.com\n📞 +1 (555) 123-4567\n💬 24/7 Live Chat Available',
          icon: Icons.contact_support_outlined,
          color: Colors.purple,
        ),
      ),
      MenuItemData(
        icon: Icons.logout,
        title: 'Logout',
        color: Colors.red,
        content: 'Are you sure you want to logout?',
        onTap: _logout,
      ),
    ];

    return Container(
      color: Colors.grey.shade50,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length + 1,
        itemBuilder: (context, index) {
          if (index == menuItems.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Version 1.1.1',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }
          
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: item.title == 'Logout' ? item.color : Colors.black87,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: item.onTap,
            ),
          );
        },
      ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final Color color;
  final String content;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.color,
    required this.content,
    required this.onTap,
  });
}