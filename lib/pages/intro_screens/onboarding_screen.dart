import 'package:flutter/material.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/models/onboarding_model.dart';
import 'package:syncare/pages/auths/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0; // Tracks the current page index
  final PageController controller = PageController(); // Controller for PageView

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        // title: Image.asset(
        //   "Assets/images/syncare-white.png",
        //   width: screenWidth * 0.30,
        // ),
        actions: [
          if (currentIndex < onBordingList.length - 1)
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Background Colored Section (with image and dots)
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      // syncare text
                      Image.asset(
                        "Assets/images/syncare-white.png",
                        width: screenWidth * 0.32,
                      ),

                      const SizedBox(height: 20),

                      // PageView for Onboarding Screens
                      Expanded(
                        child: PageView.builder(
                          controller: controller,
                          onPageChanged: (value) => setState(() {
                            currentIndex = value;
                            print(
                                currentIndex); // Update current index on page change
                          }),
                          itemCount: onBordingList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                // Onboarding Image
                                Image.asset(
                                  onBordingList[index].image,
                                  fit: BoxFit.contain,
                                  width: screenWidth * 0.84,
                                ),
                                const SizedBox(height: 10),

                                // Dots Indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    onBordingList.length,
                                    (dotIndex) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: currentIndex == dotIndex ? 33 : 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: currentIndex == dotIndex
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating White Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Shadow for 3D Effect
                Positioned(
                  bottom: -10, // Negative offset to make shadow visible
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                // White Section
                Container(
                  width: double.infinity,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 15, // Larger blur radius for softer shadow
                        spreadRadius: 2, // Spread for wider shadow
                        offset: const Offset(
                            0, -5), // Negative offset for upward shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Onboarding Title
                      Text(
                        onBordingList[currentIndex].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      // Onboarding Description
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 10),
                        child: Text(
                          onBordingList[currentIndex].subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Longer Button
                      ElevatedButton(
                        onPressed: currentIndex == onBordingList.length - 1
                            ? () {
                                // Navigate to the next screen when it's the last page
                                // Example: Navigator.pushReplacement(...)

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ));
                              }
                            : () {
                                // Move to the next page in PageView
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                          backgroundColor: primaryColor,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.90, // 80% of screen width
                          child: Center(
                            child: Text(
                              currentIndex == onBordingList.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
