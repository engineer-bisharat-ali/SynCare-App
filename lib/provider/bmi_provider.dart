import 'package:flutter/material.dart';

class BMIProvider with ChangeNotifier {
  double _height = 170.0;
  double _weight = 70.0;
  int _age = 25;
  String _gender = 'male';
  double _bmi = 0.0;
  String _bmiCategory = '';
  String _healthTips = '';

  // Getters
  double get height => _height;
  double get weight => _weight;
  int get age => _age;
  String get gender => _gender;
  double get bmi => _bmi;
  String get bmiCategory => _bmiCategory;
  String get healthTips => _healthTips;

  // Setters
  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  // Calculate BMI
  void calculateBMI() {
    double heightInMeters = _height / 100;
    _bmi = _weight / (heightInMeters * heightInMeters);
    _setBMICategory();
    _setHealthTips();
    notifyListeners();
  }

  // Set BMI Category
  void _setBMICategory() {
    if (_bmi < 18.5) {
      _bmiCategory = 'Underweight';
    } else if (_bmi >= 18.5 && _bmi < 25) {
      _bmiCategory = 'Normal';
    } else if (_bmi >= 25 && _bmi < 30) {
      _bmiCategory = 'Overweight';
    } else {
      _bmiCategory = 'Obese';
    }
  }

  // Set Health Tips
  void _setHealthTips() {
    switch (_bmiCategory) {
      case 'Underweight':
        _healthTips = 'Consider eating more calories and consulting a nutritionist.';
        break;
      case 'Normal':
        _healthTips = 'Great! Maintain your healthy lifestyle.';
        break;
      case 'Overweight':
        _healthTips = 'Consider regular exercise and a balanced diet.';
        break;
      case 'Obese':
        _healthTips = 'Consult a healthcare provider for a proper weight management plan.';
        break;
      default:
        _healthTips = '';
    }
  }

  // Get BMI Color
  Color getBMIColor() {
    switch (_bmiCategory) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Reset all values
  void reset() {
    _height = 170.0;
    _weight = 70.0;
    _age = 25;
    _gender = 'male';
    _bmi = 0.0;
    _bmiCategory = '';
    _healthTips = '';
    notifyListeners();
  }
}