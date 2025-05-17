import 'package:flutter/material.dart';
import 'package:syncare/models/symptom_model.dart';
import 'package:syncare/services/api_services/symptoms_api_service.dart';

class SymptomProvider with ChangeNotifier {
  List<SymptomModel> _allSymptoms = [];
  List<SymptomModel> _filteredSymptoms = [];
  String _prediction = '';
  bool _loading = false;
  String? _error;

  // Getters
  List<SymptomModel> get symptoms => _filteredSymptoms;
  List<SymptomModel> get filteredSymptoms => _filteredSymptoms;
  String get prediction => _prediction;
  bool get loading => _loading;
  String? get error => _error;

  // Load all symptoms from API and initialize filtered list
  Future<void> loadSymptoms() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final symptomList = await SymptomsApiService.fetchSymptoms();
      _allSymptoms =
          symptomList.map((s) => SymptomModel(name: s.name)).toList();
      _filteredSymptoms = List.from(_allSymptoms); // Initially show all
    } catch (e) {
      _error = 'Failed to load symptoms: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Filter symptoms based on user search input
  void filterSymptoms(String query) {
    if (query.isEmpty) {
      _filteredSymptoms = List.from(_allSymptoms);
    } else {
      _filteredSymptoms = _allSymptoms
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Toggle selection state of a symptom by name
  void toggleSymptomByName(String name) {
    final index = _allSymptoms.indexWhere((s) => s.name == name);
    if (index != -1) {
      _allSymptoms[index].isSelected = !_allSymptoms[index].isSelected;

      // Also update the filtered list if the symptom is present there
      final filteredIndex = _filteredSymptoms.indexWhere((s) => s.name == name);
      if (filteredIndex != -1) {
        _filteredSymptoms[filteredIndex].isSelected =
            _allSymptoms[index].isSelected;
      }

      notifyListeners();
    }
  }

  // Deselect all symptoms
  void clearAllSelectedSymptoms() {
    for (var symptom in _allSymptoms) {
      symptom.isSelected = false;
    }
    notifyListeners();
  }

  // Call prediction API with selected symptoms
  Future<void> predict() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final selectedSymptoms =
          _allSymptoms.where((s) => s.isSelected).map((s) => s.name).toList();

      if (selectedSymptoms.isEmpty) {
        _error = 'Please select at least one symptom.';
        _loading = false;
        notifyListeners();
        return;
      }

      _prediction = await SymptomsApiService.predictDisease(selectedSymptoms);
    } catch (e) {
      _error = 'Prediction failed: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Clear the prediction result
  void clearPrediction() {
    _prediction = '';
    notifyListeners();
  }

  // Clear any error after it's displayed
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Returns the count of selected symptoms
  int getSelectedCount() {
    return _allSymptoms.where((symptom) => symptom.isSelected).length;
  }

  // Returns the list of selected symptoms
  List<SymptomModel> getSelectedSymptoms() {
    return _allSymptoms.where((symptom) => symptom.isSelected).toList();
  }

  // Reset all selections, filters, and prediction result
  void resetAll() {
    clearAllSelectedSymptoms();
    _filteredSymptoms = List.from(_allSymptoms);
    _prediction = '';
    _error = null;
    notifyListeners();
  }
}
// This class is responsible for managing the state of symptoms, including loading, filtering, and predicting diseases based on selected symptoms.
// It uses ChangeNotifier to notify listeners about changes in the state.