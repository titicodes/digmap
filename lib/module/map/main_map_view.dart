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
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search infrastructure...',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
            onChanged:
                controller.onSearchChanged, // Call search method on text change
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: controller.onFilterChanged,
              itemBuilder: (BuildContext context) {
                return ['Hospital', 'School', 'Fire Station', 'Police Station']
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.initialPosition.value,
                zoom: 14.0,
              ),
              myLocationEnabled: true, // Enable the location button on the map
              markers: Set<Marker>.of(controller.markers),
            )
          ],
        ),
      ),
    );
  }
}
