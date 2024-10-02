import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfrastructureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchInfrastructure() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('infrastructure').get();
      List<Marker> markers = await Future.wait(snapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/${data['icon']}',
        );
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(data['latitude'], data['longitude']),
          infoWindow: InfoWindow(title: data['name']),
          icon: customIcon,
        );
      }).toList());

      markers = markers;
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> addInfrastructure(
      Map<String, dynamic> infrastructureData) async {
    await _firestore.collection('infrastructure').add(infrastructureData);
  }

  Future<String> uploadImage(File imageFile, String fileName) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('infrastructure/$fileName');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  // Fetch infrastructure data from Firestore
  Future<List<Map<String, dynamic>>> getInfrastructure() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('infrastructure').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching infrastructure data: $e");
      return [];
    }
  }
}
