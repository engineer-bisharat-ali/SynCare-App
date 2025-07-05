
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OverpassService {
  static const _url = 'https://overpass-api.de/api/interpreter';

  Future<List<Map<String, dynamic>>> hospitals(LatLng loc, {int radius = 5000}) async {
    final query = '''
      [out:json][timeout:25];
      nwr(around:$radius,${loc.latitude},${loc.longitude})["amenity"="hospital"];
      out center;
    ''';

    final res = await http.post(
      Uri.parse(_url),
      body: {'data': query},
    );

    if (res.statusCode != 200) {
      throw Exception('Overpass HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['elements']);
  }
}

