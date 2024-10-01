import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  late GoogleMapController mapController;
  var initialPosition = const LatLng(9.0820, 8.6753).obs; // Default location

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
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
}