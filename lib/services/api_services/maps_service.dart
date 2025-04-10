import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsService {
  final String apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  Future<List<Map<String, dynamic>>> getNearbyHospitals(LatLng location) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=5000&type=hospital&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data["results"]);
    } else {
      throw Exception("Failed to load hospitals");
    }
  }
}
