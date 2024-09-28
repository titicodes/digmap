import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:digmap/module/dashboard/controller/home_controller.dart';
import 'package:digmap/routes/app-route-names.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

class MainMapView extends StatefulWidget {
  const MainMapView({super.key});

  @override
  State<MainMapView> createState() => _MainMapViewState();
}

class _MainMapViewState extends State<MainMapView> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.fetchUserLocation();
  }

  void showInfrastructureDetails(Map<String, dynamic> infrastructure) {
    Get.defaultDialog(
      title: infrastructure['name'] ?? 'Details',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (infrastructure['imageUrl'] != null)
            Image.network(
              infrastructure['imageUrl'],
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 10),
          Text("Type: ${infrastructure['type'] ?? 'N/A'}"),
          Text("Latitude: ${infrastructure['latitude'] ?? 'N/A'}"),
          Text("Longitude: ${infrastructure['longitude'] ?? 'N/A'}"),
          // Add more details as needed
        ],
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Close"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<HomeController>(
            builder: (controller) {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.initialPosition.value,
                        zoom: 14.0,
                      ),
                      markers: Set<Marker>.of(controller.markers),
                      onMapCreated: (GoogleMapController mapController) {
                        controller.mapController = mapController;
                      },
                    );
            },
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  Expanded(
                    child: TextField(
                      controller: controller.searchText,
                      onChanged: (value) {
                        controller.updateSearchText(value);
                      },
                      onSubmitted: (value) {
                        controller.searchForInfrastructure();
                      },
                      decoration: const InputDecoration(
                        hintText: "Search for infrastructure...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {
                      // Open filter options
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Filter by Category"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text("Hospitals"),
                                  onTap: () {
                                    controller
                                        .filterInfrastructures("hospital");
                                    Get.back(); // Close the dialog
                                  },
                                ),
                                ListTile(
                                  title: const Text("Schools"),
                                  onTap: () {
                                    controller.filterInfrastructures("school");
                                    Get.back(); // Close the dialog
                                  },
                                ),
                                // Add more categories as needed
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                controller.fetchUserLocation(); // Refresh location
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 15,
            right: 15,
            child: Obx(() {
              if (controller.infrastructureList.isEmpty) {
                return const SizedBox.shrink(); // Don't display anything
              }
              return DottedBorder(
                color: Colors.blue,
                strokeWidth: 2,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                child: Container(
                  height: 200,
                  child: Swiper(
                    itemCount: controller.infrastructureList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final infrastructure =
                          controller.infrastructureList[index];
                      return GestureDetector(
                        onTap: () => showInfrastructureDetails(
                            infrastructure), // Show details on tap
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                infrastructure['imageUrl'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 300,
                                  child: AutoSizeText(
                                    infrastructure['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    autoplay: true,
                    pagination: const SwiperPagination(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
