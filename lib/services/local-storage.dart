import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalStorage {

  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // STORE RECENT SEARCH
  Future<void> storeRecentSearchList(String list) async {
    try {
      await _flutterSecureStorage.write(key: "Recent Search", value: list);
      log("Saved list");
    } catch (e) {
      log(e.toString());
      log("Could not save list");
    }
  }

  // FETCH RECENT SEARCH LIST
  Future<String> fetchRecentSearchList() async {
    String list = await _flutterSecureStorage.read(key: "Recent Search") ?? "";
    log("Fetched list successful");
    return list;
  }

  // STORE LOCATION DATA
  Future<void> storeLocationData(String data) async {
    try {
      await _flutterSecureStorage.write(key: "LOCATION", value: data);
      log("Saved Locations");
    } catch (e) {
      log(e.toString());
      log("Could not save Locations");
    }
  }

  // FETCH LOCATION DATA
  Future<String> fetchLocationData() async {
    String data = await _flutterSecureStorage.read(key: "LOCATION") ?? "";
    log("Fetched Location successful");
    return data;
  }

  // STORE REMEMBER ME CHECK
  Future<void> storeIsRememberMeChecked(String isChecked) async {
    try {
      await _flutterSecureStorage.write(key: "ISREMEMBERED", value: isChecked);
      log("Saved check");
    } catch (e) {
      log(e.toString());
      log("Could not save check");
    }
  }

  // FETCH REMEMBER ME CHECK
  Future<String> fetchIsRememberMeChecked() async {
    String isChecked = await _flutterSecureStorage.read(key: "ISREMEMBERED") ?? "";
    log("Fetched check successful");
    return isChecked;
  }

  // STORE EMAIL
  Future<void> storeEmail(String email) async {
    try {
      await _flutterSecureStorage.write(key: "Email", value: email);
      log("Saved Email");
    } catch (e) {
      log(e.toString());
      log("Could not save Email");
    }
  }

  // FETCH EMAIL
  Future<String> fetchEmail() async {
    String email = await _flutterSecureStorage.read(key: "Email") ?? "";
    log("Fetched email successful");
    return email;
  }

  // STORE PASSWORD
  Future<void> storePassword(String password) async {
    try {
      await _flutterSecureStorage.write(key: "Password", value: password);
      log("Saved Password");
    } catch (e) {
      log(e.toString());
      log("Could not save Password");
    }
  }

  // FETCH PASSWORD
  Future<String> fetchPassword() async {
    String password = await _flutterSecureStorage.read(key: "Password") ?? "";
    log("Fetched password successful");
    return password;
  }

  // CHECK IF USER IS AUTHENTICATED USING FIREBASE
  bool isUserAuthenticated() {
    User? currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  // DELETE USER FROM STORAGE
  Future<void> deleteUserStorage() async {
    await _flutterSecureStorage.deleteAll();
    log("Deleted Storage :)");
  }

  // DELETE REMEMBER ME FLAG
  Future<void> deleteUserRemember() async {
    await _flutterSecureStorage.delete(key: "ISREMEMBERED");
    log("Deleted remember me flag :)");
  }

  // SIGN OUT USER (This will also invalidate the Firebase Auth token)
  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
    log("User signed out");
  }
}
