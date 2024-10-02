import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  late GoogleMapController mapController;
  var initialPosition = const LatLng(9.0820, 8.6753).obs; // Default location
  List<Marker> markers = [];
  String _searchTerm = '';
  String _filterType = '';

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
     
    fetchInfrastructure();
  }

  // Search infrastructure by name
  void onSearchChanged(String searchTerm) {
      _searchTerm = searchTerm;
    
    fetchInfrastructure();
  }

  // Filter infrastructure by type
  void onFilterChanged(String type) {
    
      _filterType = type;
    
    fetchInfrastructure();
  }

  void getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    initialPosition.value = LatLng(position.latitude, position.longitude);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLng(initialPosition.value));
  }

  // Fetch infrastructure data from Firestore

  Future<void> fetchInfrastructure() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('infrastructure').get();
    List<Marker> markers = await Future.wait(snapshot.docs.map((doc) async {
      var data = doc.data() as Map<String, dynamic>;
      BitmapDescriptor icon;

      // Load appropriate icon based on the infrastructure type
      if (data['type'] == 'Hospital') {
        icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/hospital.png',
        );
      } else if (data['type'] == 'School') {
        icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/school.png',
        );
      } else {
        icon = BitmapDescriptor.defaultMarker; // Default marker for other types
      }

      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['latitude'], data['longitude']),
        infoWindow: InfoWindow(title: data['name']),
        icon: icon,
      );
    }).toList());

      markers = markers;
    
  } catch (e) {
    print("Error fetching data: $e");
  }
}


}