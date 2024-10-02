import 'package:digmap/firebase_options.dart';
import 'package:digmap/module/map/controller/map_controller.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(MapController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digital Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Poppins",
          scaffoldBackgroundColor: Colors.white,
          dividerTheme: const DividerThemeData(color: Color(0xffD9D9D9)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xffFBFBFB), elevation: 0),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xffFBFBFB)),
          iconTheme: const IconThemeData(color: Color(0xff575757)),
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xff009933))),
      // initialRoute: splashScreen,
      initialRoute: mainMapView,
      
    );
  }
}
