import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfrastructureMapView extends StatefulWidget {
  double longitude;
  double latitude;
  String name;
  InfrastructureMapView(
      {super.key,
      required this.longitude,
      required this.latitude,
      required this.name});

  @override
  State<InfrastructureMapView> createState() => _InfrastructureMapViewState();
}

class _InfrastructureMapViewState extends State<InfrastructureMapView> {
  GoogleMapController? mapController;
  LatLng _initialPosition = LatLng(0, 0);
  Set<Marker> _markers = {};

  void updateCurrentPosition() async {
    setState(() {
      _initialPosition = LatLng(widget.latitude, widget.longitude);

      _markers.add(
        Marker(
          markerId: const MarkerId('initialPosition'),
          position: _initialPosition,
          infoWindow: InfoWindow(title: widget.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    updateCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition.latitude == 0 && _initialPosition.longitude == 0
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapToolbarEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              trafficEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
    );
  }
}
