import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InfrastructureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getInfrastructure() async {
    var snapshot = await _firestore.collection('infrastructure').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addInfrastructure(Map<String, dynamic> infrastructureData) async {
    await _firestore.collection('infrastructure').add(infrastructureData);
  }

  Future<String> uploadImage(File imageFile, String fileName) async {
    final storageRef = FirebaseStorage.instance.ref().child('infrastructure/$fileName');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }
}
