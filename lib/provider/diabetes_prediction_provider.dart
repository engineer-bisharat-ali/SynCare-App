import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiabetesProvider with ChangeNotifier {
  // Form data
  int _age = 25;
  String _gender = 'Male';
  int _hypertension = 0;
  int _heartDisease = 0;
  String _smokingHistory = 'never';
  double _bmi = 25.0;
  double _hbA1cLevel = 5.5;
  double _bloodGlucoseLevel = 100.0;

  // API state
  bool _isLoading = false;
  String _predictionResult = '';
  String _confidenceScore = '';
  bool _hasResult = false;

  // API URL
  static const String _baseUrl = 'https://diabetes-prediction-api.up.railway.app';

  // Getters
  int get age => _age;
  String get gender => _gender;
  int get hypertension => _hypertension;
  int get heartDisease => _heartDisease;
  String get smokingHistory => _smokingHistory;
  double get bmi => _bmi;
  double get hbA1cLevel => _hbA1cLevel;
  double get bloodGlucoseLevel => _bloodGlucoseLevel;
  
  bool get isLoading => _isLoading;
  String get predictionResult => _predictionResult;
  String get confidenceScore => _confidenceScore;
  bool get hasResult => _hasResult;

  // Setters
  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setHypertension(int hypertension) {
    _hypertension = hypertension;
    notifyListeners();
  }

  void setHeartDisease(int heartDisease) {
    _heartDisease = heartDisease;
    notifyListeners();
  }

  void setSmokingHistory(String smokingHistory) {
    _smokingHistory = smokingHistory;
    notifyListeners();
  }

  void setBmi(double bmi) {
    _bmi = bmi;
    notifyListeners();
  }

  void setHbA1cLevel(double hbA1cLevel) {
    _hbA1cLevel = hbA1cLevel;
    notifyListeners();
  }

  void setBloodGlucoseLevel(double bloodGlucoseLevel) {
    _bloodGlucoseLevel = bloodGlucoseLevel;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _age = 25;
    _gender = 'Male';
    _hypertension = 0;
    _heartDisease = 0;
    _smokingHistory = 'never';
    _bmi = 25.0;
    _hbA1cLevel = 5.5;
    _bloodGlucoseLevel = 100.0;
    _hasResult = false;
    _predictionResult = '';
    _confidenceScore = '';
    notifyListeners();
  }

  // API call
  Future<void> predictDiabetes() async {
    _isLoading = true;
    _hasResult = false;
    notifyListeners();

    try {
      final requestBody = {
        'age': _age,
        'gender': _gender,
        'hypertension': _hypertension,
        'heart_disease': _heartDisease,
        'smoking_history': _smokingHistory,
        'bmi': _bmi,
        'HbA1c_level': _hbA1cLevel,
        'blood_glucose_level': _bloodGlucoseLevel,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _predictionResult = data['prediction'] ?? '';
        _confidenceScore = data['confidence_score'] ?? '';
        _hasResult = true;
      } else {
        _predictionResult = 'Error occurred';
        _confidenceScore = '';
        _hasResult = false;
      }
    } catch (e) {
      _predictionResult = 'Network error occurred';
      _confidenceScore = '';
      _hasResult = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}