import 'package:booking_transition_admin/feature/presentation/Authentication/login.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/dashboard_page.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/router/app_pages.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:url_strategy/url_strategy.dart';

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
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static late double widthScreen;
  MyApp({super.key});
  //static late bool isLogin;

  FirebaseAuth auth = FirebaseAuth.instance;

// Check if a user is currently signed in
  User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //if (LoginPage.isLogin) {
    try {
      user = auth.currentUser!;
    } catch (e) {
      user = null;
    }

    //print(user?.uid);
    // }

    widthScreen = MediaQuery.of(context).size.width;
    print(widthScreen);
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:
          //LoginPage()
          user?.uid != 'Fv4mfoOUoTQnx9YCkYRhad63WhB2' || user == null
              ? LoginPage()
              : ScaffoldWithNavigationRail(
                  selectedIndex: 0,
                ),
      // initialRoute: user?.uid != 'Fv4mfoOUoTQnx9YCkYRhad63WhB2' || user == null
      //     ? AppPages.AUTHENTICATION
      //     : AppPages.INITIAL,
      // getPages: AppPages.routes,
    );
  }
}
