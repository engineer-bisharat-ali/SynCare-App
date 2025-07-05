import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:syncare/constants/colors.dart';
import 'package:syncare/services/api_services/maps_service.dart'; // OverpassService

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Set<Marker> _markers = {};
  final TextEditingController _searchCtl = TextEditingController();
  final OverpassService _svc = OverpassService();

  GoogleMapController? _mapCtrl;
  LatLng _curPos = const LatLng(24.8607, 67.0011); // Karachi default

  // ───────── PERMISSION + CURRENT LOC ─────────
  Future<void> _requestPermAndLocate() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return _err('Location permission denied');
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final p = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final loc = LatLng(p.latitude, p.longitude);
      _addOrUpdateMarker(loc, 'current', 'Your Current Location',
          BitmapDescriptor.defaultMarker);
      _moveCamera(loc);
      await _loadHospitals(loc);
    } catch (e) {
      _err('Location error: $e');
    }
  }

  // ───────── SEARCH ─────────
  Future<void> _search(String q) async {
    if (q.trim().isEmpty) return;
    try {
      final res = await locationFromAddress(q);
      if (res.isEmpty) return _err('Location not found');
      final tgt = LatLng(res[0].latitude, res[0].longitude);

      _addOrUpdateMarker(tgt, 'searched', q,
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      _moveCamera(tgt);
      _searchCtl.clear();
      await _loadHospitals(tgt);
    } catch (e) {
      _err('Search failed: $e');
    }
  }

  // ───────── HOSPITALS (TOP 4 NEAREST) ─────────
  Future<void> _loadHospitals(LatLng base) async {
    try {
      final data = await _svc.hospitals(base);
      final sorted = data
          .where((e) =>
              (e['lat'] != null && e['lon'] != null) ||
              (e['center']?['lat'] != null))
          .map((e) {
            final lat = (e['lat'] ?? e['center']['lat']) as num;
            final lon = (e['lon'] ?? e['center']['lon']) as num;
            final d = Geolocator.distanceBetween(
                base.latitude, base.longitude, lat.toDouble(), lon.toDouble());
            return {'d': d, 'e': e};
          })
          .toList()
        ..sort((a, b) {
          final ad = a['d'] as double?;
          final bd = b['d'] as double?;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return ad.compareTo(bd);
        });

      final nearest = sorted.take(4);

      setState(() {
        _markers.removeWhere((m) => m.markerId.value.startsWith('hosp_'));
        for (var item in nearest) {
          final e = item['e'] as Map<String, dynamic>;
          final lat = (e['lat'] ?? e['center']['lat']) as double;
          final lon = (e['lon'] ?? e['center']['lon']) as double;
          final name = e['tags']?['name'] ?? 'Hospital';
          _markers.add(
            Marker(
              markerId: MarkerId('hosp_${e['id']}'),
              position: LatLng(lat, lon),
              infoWindow: InfoWindow(title: name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          );
        }
      });
    } catch (e) {
      _err('Hospitals load error: $e');
    }
  }

  // ───────── MARKER + CAMERA HELPERS ─────────
  void _addOrUpdateMarker(
      LatLng pos, String id, String title, BitmapDescriptor icon) {
    setState(() {
      _curPos = pos;
      _markers.removeWhere((m) => m.markerId.value == id);
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: pos,
          infoWindow: InfoWindow(title: title),
          icon: icon,
        ),
      );
    });
  }

  void _moveCamera(LatLng pos) =>
      _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14));

  void _err(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // ───────── UI ─────────
  @override
  Widget build(BuildContext context) {
    final padTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _curPos, zoom: 14),
            markers: Set<Marker>.of(_markers),
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (c) {
              _mapCtrl = c;
              _requestPermAndLocate();
            },
          ),

          // ── Fancy Search Bar (original design)
          Positioned(
            top: padTop + 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtl,
                onSubmitted: _search,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: _searchCtl.clear,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
          ),

          // ── Round FAB (original position)
          Positioned(
            bottom: 110,
            right: 20,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

