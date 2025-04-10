import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:syncare/constants/colors.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(24.8607, 67.0011);
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        _showErrorSnackbar('Location services are disabled. Please enable them');
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (mounted) {
          _showErrorSnackbar('Location permissions are required');
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        _showErrorSnackbar('Location permissions are permanently denied');
      }
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        _updateCameraAndMarker(
          LatLng(position.latitude, position.longitude),
          'Your Current Location',
          BitmapDescriptor.defaultMarker,
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error getting location: $e');
      }
    }
  }

  Future<void> _searchLocation(String address) async {
    if (address.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        if (mounted) {
          _showErrorSnackbar('Location not found');
        }
        return;
      }
      if (mounted) {
        _updateCameraAndMarker(
          LatLng(locations[0].latitude, locations[0].longitude),
          address,
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          isSearchResult: true,
        );
        _searchController.clear();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error searching location: $e');
      }
    }
  }

  void _updateCameraAndMarker(LatLng position, String infoText,
      BitmapDescriptor icon, {bool isSearchResult = false}) {
    final markerId = MarkerId(isSearchResult ? 'searchedLocation' : 'currentLocation');

    setState(() {
      _currentPosition = position;
      _markers.removeWhere((marker) => marker.markerId == markerId);
      _markers.add(Marker(
        markerId: markerId,
        position: position,
        icon: icon,
        infoWindow: InfoWindow(title: infoText),
      ));
    });

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, 14),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              mapController = controller;
              await _requestLocationPermission();
            },
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                ),
                onSubmitted: _searchLocation,
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: 110,
            right: 20,
            child: FloatingActionButton(
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