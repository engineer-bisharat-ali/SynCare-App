import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncare/models/symptom_model.dart';

// A service class responsible for handling all API requests related to symptoms
class SymptomsApiService {
  static const String _baseUrl = 'https://syncare-symptom-api-production.up.railway.app/';

  // Fetch list of symptoms from the API and convert to List<SymptomModel>
  static Future<List<SymptomModel>> fetchSymptoms() async {
    final response = await http.get(Uri.parse('$_baseUrl/symptoms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Convert each symptom string to a SymptomModel object
      return data
          .map((symptomName) => SymptomModel.fromJson(symptomName))
          .toList();
    } else {
      throw Exception('Failed to load symptoms');
    }
  }

  // Send selected symptoms to API and return the predicted disease
  static Future<String> predictDisease(List<String> selectedSymptoms) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'symptoms': selectedSymptoms}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['predicted_disease'] ??
          'Unknown'; // Fallback if key is missing
    } else {
      throw Exception('Prediction API failed'); 
    }
  }
}
