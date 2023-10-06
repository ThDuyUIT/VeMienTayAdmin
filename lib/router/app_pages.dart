import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Authentication/login.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/cities_page.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/crud_city.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/dashboard_page.dart';
import 'package:booking_transition_admin/feature/presentation/Route/route_page.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/ticket_page.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/vehicle_page.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  static const INITIAL = Routes.DASHBOARD;
  static const AUTHENTICATION = Routes.LOGIN;
  static final routes = [
    // GetPage(
    //   name: Routes.MENU,
    //   page: () => ScaffoldWithNavigationRail(selectedIndex: 0,),
    // ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      // ),
    ),
    GetPage(
        name: Routes.DASHBOARD,
        page: () => ScaffoldWithNavigationRail(
              selectedIndex: 0,
            ),
        transition: Transition.noTransition
        // ),
        ),
    GetPage(
        name: Routes.VEHICLE,
        page: () => ScaffoldWithNavigationRail(
              selectedIndex: 1,
            ),
        transition: Transition.noTransition
        // ),
        ),
    GetPage(
        name: Routes.CITY,
        page: () => ScaffoldWithNavigationRail(
              selectedIndex: 2,
            ),
        transition: Transition.noTransition
        // ),
        ),
    GetPage(
        name: Routes.TRANSITION,
        page: () => ScaffoldWithNavigationRail(
              selectedIndex: 3,
            ),
        transition: Transition.noTransition
        // ),
        ),
    GetPage(
        name: Routes.TICKET,
        page: () => ScaffoldWithNavigationRail(
              selectedIndex: 4,
            ),
        transition: Transition.noTransition
        // ),
        ),
    GetPage(
        name: Routes.CRUDCITY,
        page: () => CrudCity.create(isAddNew: true),
        transition: Transition.noTransition
        // ),
        ),
  ];
}
