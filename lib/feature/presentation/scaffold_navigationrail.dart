import 'package:booking_transition_admin/feature/presentation/Cities/cities_page.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/dashboard_page.dart';
import 'package:booking_transition_admin/feature/presentation/Route/route_page.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/ticket_page.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/vehicle_page.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaffoldWithNavigationRail extends StatefulWidget {
  late int selectedIndex;

  ScaffoldWithNavigationRail({super.key, required this.selectedIndex});

  @override
  State<StatefulWidget> createState() {
    return StateScaffoldWithNavigationRail();
  }
}

class StateScaffoldWithNavigationRail
    extends State<ScaffoldWithNavigationRail> {
  final List<Widget> _screen = [
    DashBoard(),
    VehiclePage(),
    CityPage(),
    RoutePage(),
    TicketPage()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            shape: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
            title: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'VeMienTay',
                    style: TextStyle(
                        fontFamily: 'Roboto bold',
                        color: AppColor.mainColor,
                        fontSize: 20)),
                const TextSpan(
                    text: 'Admin',
                    style: TextStyle(
                        fontFamily: 'Roboto bold',
                        color: Colors.grey,
                        fontSize: 20)),
              ]),
            )
            // Text(
            //   'VeMienTay',
            //   style: TextStyle(
            //       color: AppColor.mainColor,
            //       fontFamily: 'Roboto bold',
            //       fontSize: 20),
            // ),
            ),
        body: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 6, top: 6),
              decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20))),
              child: NavigationRail(
                backgroundColor: AppColor.mainColor,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.dashboard,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.dashboard,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Dashboard',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.directions_car_rounded,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.directions_car_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Vehicle',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.place_rounded,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.place_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'City Point',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.route_rounded,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.route_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Route',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.receipt_rounded,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.receipt_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Ticket',
                    ),
                  ),
                ],
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: (value) async {
                  setState(() {
                    widget.selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(child: _screen[widget.selectedIndex])
          ],
        ),
      ),
    );
  }
}
