import 'package:digmap/module/map/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapView extends StatelessWidget {
  const MainMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (MapController controller) => Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.initialPosition.value,
                zoom: 14.0,
              ),
              myLocationEnabled: true, // Enable the location button on the map
            )
          ],
        ),
      ),
    );
  }
}
