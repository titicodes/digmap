import 'dart:convert';
import 'dart:developer';
import 'package:digmap/routes/app-route-names.dart';
import 'package:digmap/services/local-storage.dart';
import 'package:digmap/widget/location-sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentStep = 0;

  Future<void> getLocation() async {
    setState(() {
      _currentStep = 20; // Update progress to 20%
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationWarningSheet().show(context,
        title: "Location services are disabled",
        subtitle: "Please open settings to enable location services",
        buttonName: "Open settings",
        action: () {
          Geolocator.openLocationSettings();
        });
    }

    setState(() {
      _currentStep = 40; // Update progress to 40%
    });

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return LocationWarningSheet().show(context,
          title: "Location services are disabled",
          subtitle: "Please open settings to enable location services",
          buttonName: "Open settings",
          action: () {
            Geolocator.openLocationSettings();
          });
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return LocationWarningSheet().show(context,
          title: "Location access denied",
          subtitle: "Location access is needed to proceed to the application",
          buttonName: "Request access",
          action: () async {
            await Geolocator.requestPermission();
          });
      }
    }

    setState(() {
      _currentStep = 60; // Update progress to 60%
    });

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    setState(() {
      _currentStep = 80; // Update progress to 80%
    });

    // Get placemarks from coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String country = placemarks.first.country ?? '';
    String state = placemarks.first.administrativeArea ?? '';
    String address = placemarks.first.street ?? '';

    Map<String, dynamic> locationData = {
      "longitude": position.longitude,
      "latitude": position.latitude,
      "country": country,
      "state": state,
      "address": address,
    };
    log(locationData.toString());

    // Store location data
    String encodedData = jsonEncode(locationData);
    await LocalStorage().storeLocationData(encodedData);

    setState(() {
      _currentStep = 100;
    });

    // Check user authentication status
    User? currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      Get.toNamed(onboardingScreen); // Not authenticated, redirect to onboarding
    } else {
      Get.toNamed(dashboard); // Authenticated, go to dashboard
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/FuelAlert Logo.svg"),
            Visibility(
              visible: _currentStep > 20,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: StepProgressIndicator(
                      totalSteps: 100,
                      currentStep: _currentStep,
                      size: 8,
                      padding: 0,
                      selectedColor: const Color(0xff009933),
                      unselectedColor: const Color(0xffF0F2F5),
                      roundedEdges: const Radius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}