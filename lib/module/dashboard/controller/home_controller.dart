import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digmap/services/infrastructure_service.dart';
import 'package:digmap/services/location_service.dart';
import 'package:digmap/services/nearby_places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  var isMapVisible = false.obs;
  var isSearchActive = false.obs;
  var searchText = TextEditingController();
  var infrastructureList = <Map<String, dynamic>>[].obs;
  var markers = <Marker>[].obs;
  var imageUrls = <String>[].obs;

  late GoogleMapController mapController;
  var initialPosition = const LatLng(0, 0).obs;
  var isLoading = false.obs;

  final InfrastructureService _infrastructureService = InfrastructureService();
  final LocationService _locationService = LocationService();
  final NearbyPlacesService _placesService = NearbyPlacesService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadInfrastructureData();
  }

  void updateSearchText(String text) {
    searchText.text = text;
    update();
  }

  Future<void> loadInfrastructureData() async {
    isLoading.value = true;
    try {
      var data = await _infrastructureService.getInfrastructure();
      infrastructureList.assignAll(data);
      addMarkers();
      if (infrastructureList.isNotEmpty) {
        updateCurrentPosition(
          latitude: infrastructureList[0]['latitude'],
          longitude: infrastructureList[0]['longitude'],
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load infrastructure data: $e");
    }
    isLoading.value = false;
  }

  void addMarkers() {
    markers.clear();
    for (var infrastructure in infrastructureList) {
      var markerId = infrastructure['id'];
      var markerColor = Colors.blue; // Default color
      // Customize the marker color or icon based on infrastructure type
      if (infrastructure['type'] == 'hospital') {
        markerColor = Colors.red;
      } else if (infrastructure['type'] == 'school') {
        markerColor = Colors.green;
      }

      markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(infrastructure['latitude'], infrastructure['longitude']),
          infoWindow: InfoWindow(
            title: infrastructure['name'],
            onTap: () {
              // Show dialog with details about the infrastructure
              Get.dialog(AlertDialog(
                title: Text(infrastructure['name']),
                content: const Text("Details about this infrastructure..."), // Customize this as needed
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text("Close"),
                  ),
                ],
              ));
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor.value as double), // Customize here
        ),
      );
    }
  }

  Future<void> saveInfrastructureToFirebase(Map<String, dynamic> infrastructure) async {
  try {
    await _firestore.collection('infrastructure').add(infrastructure);
    Get.snackbar("Success", "Infrastructure saved to Firebase.");
  } catch (err) {
    Get.snackbar("Error", "Failed to save infrastructure: $err");
  }
}

  void filterInfrastructures(String type) {
    var filteredInfrastructures = infrastructureList.where((infrastructure) {
      return infrastructure['type'] == type;
    }).toList();

    markers.clear();
    for (var infrastructure in filteredInfrastructures) {
      markers.add(Marker(
        markerId: MarkerId(infrastructure['id']),
        position: LatLng(infrastructure['latitude'], infrastructure['longitude']),
        infoWindow: InfoWindow(title: infrastructure['name']),
      ));
    }
    update();
  }



Future<void> fetchNearbyPlaces(double latitude, double longitude, String type) async {
  try {
    final places = await _placesService.fetchNearbyPlaces(latitude, longitude, type);

    final newMarkers = places.map((place) {
      Map<String, dynamic> infrastructureData = {
        'name': place.name,
        'latitude': place.geometry!.location.lat,
        'longitude': place.geometry!.location.lng,
        'type': type,
      };

      // Fetch image URLs if available
      String? imageUrl;
      if (place.photos != null && place.photos!.isNotEmpty) {
        final photoReference = place.photos![0].photoReference; // Use the first photo
        imageUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=AIzaSyBZHjR9a5dgzRqcJ_I1ost9U4dHHro19WA';
        infrastructureData['imageUrl'] = imageUrl; // Add image URL to infrastructure data
      }

      saveInfrastructureToFirebase(infrastructureData); // Save to Firebase

      return Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(
            place.geometry!.location.lat, place.geometry!.location.lng),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.vicinity,
        ),
      );
    }).toList();

    markers.assignAll(newMarkers);
  } catch (e) {
    Get.snackbar("Error", "Failed to fetch nearby places: $e");
  }
}

  void updateCurrentPosition({required double latitude, required double longitude}) {
    initialPosition.value = LatLng(latitude, longitude);
    fetchNearbyPlaces(latitude, longitude, 'hospital'); // Fetch places of a specific type, e.g., 'hospital'
  }

  void searchForInfrastructure() {
    var filteredInfrastructures = infrastructureList.where((infrastructure) {
      return infrastructure['name']
          .toString()
          .toLowerCase()
          .contains(searchText.text.toLowerCase());
    }).toList();

    markers.clear();
    for (var infrastructure in filteredInfrastructures) {
      var markerId = infrastructure["id"].toString();
      markers.add(Marker(
        markerId: MarkerId(markerId),
        position: LatLng(infrastructure["latitude"], infrastructure["longitude"]),
        infoWindow: InfoWindow(title: infrastructure["name"]),
      ));
    }
    update();
  }

  void fetchUserLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      initialPosition.value = LatLng(position.latitude, position.longitude);
      markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: initialPosition.value,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user location: $e");
    }
  }

  Future<void> getLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      // Process the location data
    } catch (e) {
      // Handle exceptions
    }
  }

    Future<void> uploadImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      imageUrls.clear();
      for (var pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        final imageUrl =
            await _infrastructureService.uploadImage(file, pickedFile.name);
        imageUrls.add(imageUrl);
      }
    }
  }
}