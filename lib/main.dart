import 'package:booking_transition_admin/feature/presentation/Dashboard/dashboard_page.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/router/app_pages.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCV8O92zp1HNWT6060M2Mae8OZ5h_I-HEs',
    appId: '1:957626042083:web:18a01d2bb4f94c166167d6',
    messagingSenderId: '957626042083',
    projectId: 'vemientay-6c26c',
    // authDomain: 'booking-transition.firebaseapp.com',
    databaseURL:
        'https://vemientay-6c26c-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'vemientay-6c26c.appspot.com',
    // measurementId: 'G-ZFSTZK4J9V',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ScaffoldWithNavigationRail(
        selectedIndex: 0,
      ),
      // initialRoute: '/',
      // getPages: AppPages.routes,
    );
  }
}
