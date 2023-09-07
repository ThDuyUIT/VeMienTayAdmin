import 'package:booking_transition_admin/feature/presentation/Dashboard/dashboard_page.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static const INITIAL = Routes.DASHBOARD;
  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashBoard(),
    ),
    // GetPage(
    //   name: Routes.TICKET,
    //   page: () => MyTicket(),
    // ),
    // GetPage(
    //   name: Routes.MYACCOUNT,
    //   page: () => MyAccount(),
    // ),
  ];
}
