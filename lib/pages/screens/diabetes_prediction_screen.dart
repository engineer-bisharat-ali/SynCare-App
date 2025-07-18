import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncare/provider/diabetes_prediction_provider.dart';

// Primary color constant for consistent theming throughout the app
const primaryColor = Color(0x9C00BCD3);

class DiabetesPredictionScreen extends StatefulWidget {
  const DiabetesPredictionScreen({super.key});

  @override
  _DiabetesPredictionScreenState createState() =>
      _DiabetesPredictionScreenState();
}

class _DiabetesPredictionScreenState extends State<DiabetesPredictionScreen> {
  // PageController to handle navigation between different question pages
  final PageController _pageController = PageController();
  
  // Current page index tracker (0-7 for 8 total pages)
  int _currentPage = 0;

  @override
  void dispose() {
    // Clean up the page controller when widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  // Navigate to next page with smooth animation
  void _nextPage() {
    if (_currentPage < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Navigate to previous page with smooth animation
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<DiabetesProvider>(
        builder: (context, provider, child) {
          // Show result screen if prediction is complete
          if (provider.hasResult) {
            return _buildResultScreen(provider);
          }

          // Show questionnaire if no result yet
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildProgressBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildAgePage(provider),           // Page 0: Age input
                      _buildGenderPage(provider),        // Page 1: Gender selection
                      _buildHypertensionPage(provider),  // Page 2: Hypertension status
                      _buildHeartDiseasePage(provider),  // Page 3: Heart disease status
                      _buildSmokingPage(provider),       // Page 4: Smoking history
                      _buildBmiPage(provider),           // Page 5: BMI input
                      _buildHbA1cPage(provider),         // Page 6: HbA1c level
                      _buildBloodGlucosePage(provider),  // Page 7: Blood glucose level
                    ],
                  ),
                ),
                _buildNavigationButtons(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build header with back button and title
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          ),
          const Expanded(
            child: Text(
              'Diabetes Risk Assessment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // Balance the back button width
        ],
      ),
    );
  }

  // Build progress bar showing current page progress
  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: LinearProgressIndicator(
        value: (_currentPage + 1) / 8, // Progress from 1/8 to 8/8
        backgroundColor: Colors.grey[300],
        valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
      ),
    );
  }

  // Reusable question card widget for consistent UI across all pages
  Widget _buildQuestionCard({
    required String question,
    required String subtitle,
    required Widget content,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Health icon for visual consistency
              const Icon(
                Icons.health_and_safety,
                size: 60,
                color: primaryColor,
              ),
              const SizedBox(height: 30),
              // Main question text
              Text(
                question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Subtitle/description text
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Dynamic content (slider, buttons, etc.)
              content,
            ],
          ),
        ),
      ),
    );
  }

  // Page 0: Age input using slider
  Widget _buildAgePage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "What's your age?",
      subtitle: "Please enter your current age",
      content: Column(
        children: [
          // Display current age value
          Text(
            '${provider.age} years',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // Age slider (18-100 years)
          Slider(
            value: provider.age.toDouble(),
            min: 18,
            max: 100,
            divisions: 82,
            activeColor: primaryColor,
            onChanged: (value) {
              provider.setAge(value.round());
            },
          ),
        ],
      ),
    );
  }

  // Page 1: Gender selection
  Widget _buildGenderPage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "What's your gender?",
      subtitle: "Please select your gender",
      content: Column(
        children: [
          _buildOptionButton(
            'Male',
            provider.gender == 'Male',
            () => provider.setGender('Male'),
          ),
          const SizedBox(height: 15),
          _buildOptionButton(
            'Female',
            provider.gender == 'Female',
            () => provider.setGender('Female'),
          ),
        ],
      ),
    );
  }

  // Page 2: Hypertension status
  Widget _buildHypertensionPage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "Do you have hypertension?",
      subtitle: "High blood pressure condition",
      content: Column(
        children: [
          _buildOptionButton(
            'Yes',
            provider.hypertension == 1,
            () => provider.setHypertension(1),
          ),
          const SizedBox(height: 15),
          _buildOptionButton(
            'No',
            provider.hypertension == 0,
            () => provider.setHypertension(0),
          ),
        ],
      ),
    );
  }

  // Page 3: Heart disease status
  Widget _buildHeartDiseasePage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "Do you have heart disease?",
      subtitle: "Any cardiac conditions or history",
      content: Column(
        children: [
          _buildOptionButton(
            'Yes',
            provider.heartDisease == 1,
            () => provider.setHeartDisease(1),
          ),
          const SizedBox(height: 15),
          _buildOptionButton(
            'No',
            provider.heartDisease == 0,
            () => provider.setHeartDisease(0),
          ),
        ],
      ),
    );
  }

  // Page 4: Smoking history selection
  Widget _buildSmokingPage(DiabetesProvider provider) {
    // Define smoking options with their values and labels
    final smokingOptions = [
      {'value': 'never', 'label': 'Never'},
      {'value': 'former', 'label': 'Former Smoker'},
      {'value': 'current', 'label': 'Current Smoker'},
      {'value': 'not current', 'label': 'Not Current'},
    ];

    return _buildQuestionCard(
      question: "What's your smoking history?",
      subtitle: "Select your smoking status",
      content: Column(
        children: smokingOptions.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionButton(
              option['label']!,
              provider.smokingHistory == option['value'],
              () => provider.setSmokingHistory(option['value']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Page 5: BMI input using slider
  Widget _buildBmiPage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "What's your BMI?",
      subtitle: "Body Mass Index",
      content: Column(
        children: [
          // Display current BMI value
          Text(
            provider.bmi.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // BMI slider (15.0-50.0)
          Slider(
            value: provider.bmi,
            min: 15.0,
            max: 50.0,
            divisions: 350,
            activeColor: primaryColor,
            onChanged: (value) {
              provider.setBmi(value);
            },
          ),
          // Show BMI category (Underweight, Normal, Overweight, Obese)
          Text(
            _getBmiCategory(provider.bmi),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Page 6: HbA1c level input using slider
  Widget _buildHbA1cPage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "What's your HbA1c level?",
      subtitle: "Average blood sugar level (%)",
      content: Column(
        children: [
          // Display current HbA1c value
          Text(
            '${provider.hbA1cLevel.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // HbA1c slider (4.0-15.0%)
          Slider(
            value: provider.hbA1cLevel,
            min: 4.0,
            max: 15.0,
            divisions: 110,
            activeColor: primaryColor,
            onChanged: (value) {
              provider.setHbA1cLevel(value);
            },
          ),
        ],
      ),
    );
  }

  // Page 7: Blood glucose level input using slider
  Widget _buildBloodGlucosePage(DiabetesProvider provider) {
    return _buildQuestionCard(
      question: "What's your blood glucose level?",
      subtitle: "Current blood sugar level (mg/dL)",
      content: Column(
        children: [
          // Display current blood glucose value
          Text(
            '${provider.bloodGlucoseLevel.toStringAsFixed(0)} mg/dL',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // Blood glucose slider (70.0-300.0 mg/dL)
          Slider(
            value: provider.bloodGlucoseLevel,
            min: 70.0,
            max: 300.0,
            divisions: 230,
            activeColor: primaryColor,
            onChanged: (value) {
              provider.setBloodGlucoseLevel(value);
            },
          ),
        ],
      ),
    );
  }

  // Reusable option button widget for Yes/No and multiple choice questions
  Widget _buildOptionButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          // Change color based on selection state
          color: isSelected ? primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // Change text color based on selection state
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Navigation buttons at the bottom of each page
  Widget _buildNavigationButtons(DiabetesProvider provider) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Previous button (only show if not on first page)
            if (_currentPage > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Previous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 15),
            // Next/Submit button
            Expanded(
              child: ElevatedButton(
                onPressed: _currentPage == 7
                    ? () => provider.predictDiabetes() // Submit on last page
                    : _nextPage,                       // Next on other pages
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(_currentPage == 7 ? 'Get Prediction' : 'Next' , style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Result screen showing prediction outcome
  Widget _buildResultScreen(DiabetesProvider provider) {
    // Determine if result is positive for diabetes
    final isPositive =
        provider.predictionResult.toLowerCase().contains('diabetes') &&
            !provider.predictionResult.toLowerCase().contains('no');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Result icon (warning for positive, check for negative)
                    Icon(
                      isPositive ? Icons.warning_amber : Icons.check_circle,
                      size: 80,
                      color: isPositive ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(height: 20),
                    // Result title
                    Text(
                      'Prediction Result',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Prediction result text
                    Text(
                      provider.predictionResult,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.orange : Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    // Confidence score (if available)
                    if (provider.confidenceScore.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Confidence: ${provider.confidenceScore}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    // Recommendation text based on result
                    Text(
                      isPositive
                          ? 'Please consult with a healthcare professional for proper diagnosis and treatment.'
                          : 'Great! Keep maintaining a healthy lifestyle.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Action buttons
            Row(
              children: [
                // Test Again button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.resetForm();
                      setState(() {
                        _currentPage = 0; // Reset to first page
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Test Again'),
                  ),
                ),
                const SizedBox(width: 15),
                // Done button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset form before going back
                      provider.resetForm();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper function to categorize BMI values
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}