import 'dart:typed_data';

import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/mycupertinodialog.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/remove_controller.dart';
import 'package:booking_transition_admin/feature/controller/trigger_controller.dart';
import 'package:booking_transition_admin/feature/controller/upload_controller.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/item_city_data.dart';
import 'package:booking_transition_admin/feature/presentation/Route/item_route_data.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class CrudRoute extends StatefulWidget {
  bool isAddNew = false;
  late RouteRowData route;

  CrudRoute.update({super.key, required this.route});
  CrudRoute.create({super.key, required this.isAddNew});
  @override
  State<StatefulWidget> createState() {
    return StateCrudRoute();
  }
}

class StateCrudRoute extends State<CrudRoute> {
  late int valueFeatured;
  late int valueStatus;
  late TextEditingController _dateEditingController;
  late TextEditingController _timeEditingController;
  late TextEditingController _pricesEditingController;
  late String _selectedFrom;
  late String _selectedWhere;
  late String _selectedVehicle;
  static List<City> cities = [];
  //static List<City> filterCities = [];
  List<Vehicle> filteredVehicle = [];
  static List<Vehicle> vehicles = [];
  static List<String> upcomingRouteVehicles = [];
  bool imageFromFile = false;
  late Uint8List imageFile;
  final _appSnackbar = AppSnackbar();
  String idNewRoute = '';

  final _cupertinoDialog = MyCupertinoDialog();
  final _removeController = RemoveController();
  final _triggerController = TriggerController();

  @override
  void initState() {
    if (widget.isAddNew == false) {
      _selectedFrom = widget.route.from.idCity;
      _selectedWhere = widget.route.where.idCity;
      //filterCities = cities.where((element) => element.idCity != _selectedFrom).toList();

      _selectedVehicle = widget.route.idVehicle;
      if (widget.route.statusActive == '1') {
        filteredVehicle = vehicles
            .where((element) => element.location == _selectedWhere)
            .toList();

        // filteredVehicle = filteredVehicle
        //     .where((element) => !upcomingRouteVehicles.contains(element))
        //     .toList();
      } else {
        filteredVehicle = vehicles
            .where((element) => element.location == _selectedFrom)
            .toList();

        filteredVehicle = filteredVehicle
            .where(
                (element) => !upcomingRouteVehicles.contains(element.idVehicle))
            .toList();

        vehicles.forEach((element) {
          if (element.idVehicle == _selectedVehicle) {
            filteredVehicle.add(element);
          }
        });
      }

      valueFeatured = widget.route.featured == '0' ? 0 : 1;
      valueStatus = widget.route.statusActive == '0'
          ? 0
          : widget.route.statusActive == '1'
              ? 1
              : 2;
      _dateEditingController =
          TextEditingController(text: widget.route.departureDate);
      _timeEditingController =
          TextEditingController(text: widget.route.departureTime);
      _pricesEditingController =
          TextEditingController(text: widget.route.price);
    } else {
      try {
        _selectedFrom = cities[0].idCity;
        _selectedWhere = cities[0].idCity;
        //filterCities = cities.where((element) => element.idCity != _selectedFrom).toList();
        filteredVehicle = vehicles
            .where((element) => element.location == _selectedFrom)
            .toList();

        filteredVehicle = filteredVehicle
            .where(
                (element) => !upcomingRouteVehicles.contains(element.idVehicle))
            .toList();

        filteredVehicle.isEmpty
            ? _selectedVehicle = ''
            : _selectedVehicle = filteredVehicle[0].idVehicle;
      } catch (e) {
        print("index is over");
      }
      _dateEditingController = TextEditingController();
      _timeEditingController = TextEditingController();
      _pricesEditingController = TextEditingController();
      valueFeatured = 0;
      valueStatus = 0;
      idNewRoute = 'CX${DateTime.now().millisecondsSinceEpoch}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filteredVehicle.forEach((element) {
      print(element.idVehicle);
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: AppColor.mainColor,
        title: const Text(
          'Go back',
          style: TextStyle(fontFamily: 'Roboto bold', fontSize: 20),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isAddNew == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Add new route',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            color: AppColor.mainColor,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 300,
                          //flex: 1,
                          child: Text(
                            idNewRoute,
                            style: TextStyle(
                                fontFamily: 'Roboto bold',
                                color: AppColor.mainColor,
                                fontSize: 25),
                          )
                          // TextField(
                          //   //controller: _idVehicleEditingController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Enter route\'s ID',
                          //     hintStyle: TextStyle(color: AppColor.mainColor),
                          //     //icon: const Icon(Icons.account_circle_outlined),
                          //     label: Text(
                          //       'ID',
                          //       style: TextStyle(color: AppColor.mainColor),
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     enabledBorder: OutlineInputBorder(
                          //       // Change the default border color
                          //       borderRadius: BorderRadius.circular(5),
                          //       borderSide: BorderSide(
                          //           color: AppColor.mainColor,
                          //           width: 2), // Change color and width
                          //     ),
                          //   ),
                          // ),
                          ),
                      //Expanded(flex: 4, child: SizedBox())
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Edit route - ID: ${widget.route.idRoute}',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            color: AppColor.mainColor,
                            fontSize: 25),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColor.mainColor),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold',
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 2, color: AppColor.mainColor)),
                                child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    isExpanded: true,
                                    value: _selectedFrom,
                                    items: cities
                                        .map((e) => DropdownMenuItem(
                                              value: e.idCity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(e.nameCity),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) async {
                                      if (widget.isAddNew) {
                                        setState(() {
                                          _selectedFrom = value!;
                                          //filterCities = cities.where((element) => element.idCity != _selectedFrom).toList();
                                          filteredVehicle = vehicles
                                              .where((element) =>
                                                  element.location ==
                                                  _selectedFrom)
                                              .toList();

                                          filteredVehicle = filteredVehicle
                                              .where((element) =>
                                                  !upcomingRouteVehicles
                                                      .contains(
                                                          element.idVehicle))
                                              .toList();
                                          _selectedVehicle =
                                              filteredVehicle[0].idVehicle;
                                        });
                                      } else {
                                        final isTrigger =
                                            await _triggerController
                                                .checkBookedRoute(
                                                    widget.route.idRoute);

                                        if (widget.route.statusActive != '0') {
                                          _appSnackbar.buildSnackbar(context,
                                              "The route is finished. Can\'t update!");
                                          return;
                                        }

                                        if (isTrigger) {
                                          _appSnackbar.buildSnackbar(context,
                                              "Exist booked ticket. Can\'t update!");
                                        } else {
                                          setState(() {
                                            _selectedFrom = value!;
                                            filteredVehicle = vehicles
                                                .where((element) =>
                                                    element.location ==
                                                    _selectedFrom)
                                                .toList();

                                            filteredVehicle = filteredVehicle
                                                .where((element) =>
                                                    !upcomingRouteVehicles
                                                        .contains(
                                                            element.idVehicle))
                                                .toList();

                                            if (_selectedFrom ==
                                                widget.route.from.idCity) {
                                              vehicles.forEach((element) {
                                                if (element.idVehicle ==
                                                    widget.route.idVehicle) {
                                                  filteredVehicle.add(element);
                                                }
                                              });
                                            } else {
                                              filteredVehicle.removeWhere(
                                                  (element) =>
                                                      element.idVehicle ==
                                                      widget.route.idVehicle);
                                            }
                                            // vehicles.forEach((element) {
                                            //   if (element.idVehicle ==
                                            //       _selectedVehicle) {
                                            //     filteredVehicle.add(element);
                                            //   }
                                            // });
                                            if (filteredVehicle.isEmpty) {
                                              _appSnackbar.buildSnackbar(
                                                  context,
                                                  "Don\'t find suitable vehicle!");
                                              return;
                                            }
                                            _selectedVehicle =
                                                filteredVehicle[0].idVehicle;
                                          });
                                        }
                                      }
                                    }),
                              ),
                            ],
                          )),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Where',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold',
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 2, color: AppColor.mainColor)),
                                child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    isExpanded: true,
                                    value: _selectedWhere,
                                    items: cities
                                        .map((e) => DropdownMenuItem(
                                              value: e.idCity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(e.nameCity),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) async {
                                      if (widget.isAddNew) {
                                        setState(() {
                                          _selectedWhere = value!;
                                        });
                                      } else {
                                        final isTrigger =
                                            await _triggerController
                                                .checkBookedRoute(
                                                    widget.route.idRoute);

                                        if (widget.route.statusActive != '0') {
                                          _appSnackbar.buildSnackbar(context,
                                              "The route is finished. Can\'t update!");
                                          return;
                                        }

                                        if (isTrigger) {
                                          _appSnackbar.buildSnackbar(context,
                                              "Exist booked ticket. Can\'t update!");
                                        } else {
                                          setState(() {
                                            _selectedWhere = value!;
                                          });
                                        }
                                      }
                                    }),
                              ),
                            ],
                          )),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      fontFamily: 'Roboto bold',
                                      fontSize: 18,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  onTap: () async {
                                    DateTime? foramtedDate;
                                    if (widget.isAddNew) {
                                      foramtedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2030));

                                      if (foramtedDate != null) {
                                        setState(() {
                                          _dateEditingController.text =
                                              '${foramtedDate?.day}/${foramtedDate?.month}/${foramtedDate?.year}';
                                        });
                                      }
                                    } else {
                                      final isTrigger = await _triggerController
                                          .checkBookedRoute(
                                              widget.route.idRoute);

                                      if (widget.route.statusActive != '0') {
                                        _appSnackbar.buildSnackbar(context,
                                            "The route is finished. Can\'t update!");
                                        return;
                                      }

                                      if (isTrigger) {
                                        _appSnackbar.buildSnackbar(context,
                                            "Exist booked ticket. Can\'t update!");
                                      } else {
                                        foramtedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030));

                                        if (foramtedDate != null) {
                                          setState(() {
                                            _dateEditingController.text =
                                                '${foramtedDate?.day}/${foramtedDate?.month}/${foramtedDate?.year}';
                                          });
                                        }
                                      }
                                    }
                                  },
                                  readOnly: true,
                                  controller: _dateEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Choose departure date',
                                    hintStyle:
                                        TextStyle(color: AppColor.mainColor),
                                    //icon: const Icon(Icons.account_circle_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      // Change the default border color
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: AppColor.mainColor,
                                          width: 2), // Change color and width
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                      fontFamily: 'Roboto bold',
                                      fontSize: 18,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? timeOfDay;
                                    if (widget.isAddNew) {
                                      timeOfDay = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, childWidget) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        // Using 24-Hour format
                                                        alwaysUse24HourFormat:
                                                            true),
                                                // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                                                child: childWidget!);
                                          });

                                      setState(() {
                                        _timeEditingController.text = timeOfDay
                                            .toString()
                                            .substring(10, 15);
                                      });
                                    } else {
                                      final isTrigger = await _triggerController
                                          .checkBookedRoute(
                                              widget.route.idRoute);

                                      if (widget.route.statusActive != '0') {
                                        _appSnackbar.buildSnackbar(context,
                                            "The route is finished. Can\'t update!");
                                        return;
                                      }

                                      if (isTrigger) {
                                        _appSnackbar.buildSnackbar(context,
                                            "Exist booked ticket. Can\'t update!");
                                      } else {
                                        timeOfDay = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                            builder: (context, childWidget) {
                                              return MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          // Using 24-Hour format
                                                          alwaysUse24HourFormat:
                                                              true),
                                                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                                                  child: childWidget!);
                                            });

                                        setState(() {
                                          _timeEditingController.text =
                                              timeOfDay
                                                  .toString()
                                                  .substring(10, 15);
                                        });
                                      }
                                    }
                                  },
                                  controller: _timeEditingController,
                                  //style: ,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    //prefixIcon: Icon(Icons.done),
                                    hintText: 'Choose departure time',
                                    hintStyle:
                                        TextStyle(color: AppColor.mainColor),
                                    //icon: const Icon(Icons.account_circle_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      // Change the default border color
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: AppColor.mainColor,
                                          width: 2), // Change color and width
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(
                                      width: 2, color: AppColor.mainColor)),
                              child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: _selectedVehicle,
                                  items: filteredVehicle
                                      .map((e) => DropdownMenuItem(
                                            value: e.idVehicle,
                                            child: Text(e.idVehicle),
                                          ))
                                      .toList(),
                                  onChanged: (value) async {
                                    if (widget.isAddNew) {
                                      setState(() {
                                        _selectedVehicle = value!;
                                      });
                                    } else {
                                      final isTrigger = await _triggerController
                                          .checkBookedRoute(
                                              widget.route.idRoute);

                                      if (widget.route.statusActive != '0') {
                                        _appSnackbar.buildSnackbar(context,
                                            "The route is finished. Can\'t update!");
                                        return;
                                      }

                                      if (isTrigger) {
                                        _appSnackbar.buildSnackbar(context,
                                            "Exist booked ticket. Can\'t update!");
                                      } else {
                                        setState(() {
                                          _selectedVehicle = value!;
                                        });
                                      }
                                    }
                                  }),
                            ),
                          ],
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Prices(VND)',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold',
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                readOnly: widget.isAddNew
                                    ? false
                                    : widget.route.statusActive != '0'
                                        ? true
                                        : false,
                                controller: _pricesEditingController,
                                //style: ,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  //prefixIcon: Icon(Icons.done),
                                  hintText: 'Enter route\'s prices',
                                  hintStyle:
                                      TextStyle(color: AppColor.mainColor),
                                  //icon: const Icon(Icons.account_circle_outlined),
                                  // label: Text(
                                  //   'Prices',
                                  //   style: TextStyle(color: AppColor.mainColor),
                                  // ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // Change the default border color
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: AppColor.mainColor,
                                        width: 2), // Change color and width
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Featured',
                          style: TextStyle(
                              fontFamily: 'Roboto bold',
                              fontSize: 18,
                              color: Colors.grey),
                        ),
                        Container(
                          // height: 50,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppColor.mainColor),
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio(
                                      activeColor: Colors.redAccent,
                                      value: 0,
                                      groupValue: valueFeatured,
                                      onChanged: (Value) {
                                        setState(() {
                                          valueFeatured = Value!;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Not featured',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio(
                                      activeColor: Colors.greenAccent,
                                      value: 1,
                                      groupValue: valueFeatured,
                                      onChanged: (Value) {
                                        setState(() {
                                          valueFeatured = Value!;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Featured',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.isAddNew
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Route Status',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold',
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              Container(
                                //height: 50,
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: AppColor.mainColor),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Radio(
                                            activeColor: Colors.yellow,
                                            value: 0,
                                            groupValue: valueStatus,
                                            onChanged: (Value) {
                                              if (widget.route.statusActive !=
                                                  '0') {
                                                _appSnackbar.buildSnackbar(
                                                    context,
                                                    "The route is finished. Can\'t update!");
                                                return;
                                              }
                                              setState(() {
                                                valueStatus = Value!;
                                              });
                                            }),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Upcomming',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    )),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Radio(
                                            activeColor: Colors.greenAccent,
                                            value: 1,
                                            groupValue: valueStatus,
                                            onChanged: (Value) {
                                              if (valueStatus != 0) {
                                                _appSnackbar.buildSnackbar(
                                                    context,
                                                    "The route is finished. Can\'t update!");
                                                return;
                                              }
                                              setState(() {
                                                valueStatus = Value!;
                                              });
                                            }),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Complete',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    )),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Radio(
                                            activeColor: Colors.redAccent,
                                            value: 2,
                                            groupValue: valueStatus,
                                            onChanged: (Value) {
                                              if (valueStatus != 0) {
                                                _appSnackbar.buildSnackbar(
                                                    context,
                                                    "The route is finished. Can\'t update!");
                                                return;
                                              }
                                              setState(() {
                                                valueStatus = Value!;
                                              });
                                            }),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () async {
                              final _uploadController = UploadController();
                              final _appCircleprogressbar =
                                  AppCircleprogressbar();
                              // ignore: use_build_context_synchronously
                              _appCircleprogressbar
                                  .buildCirclerprogessbar(context);

                              if (_pricesEditingController.text.isEmpty) {
                                // ignore: use_build_context_synchronously
                                _appSnackbar.buildSnackbar(context,
                                    'Please fill in route\'s prices field!');
                                Navigator.of(context).pop();
                                return;
                              }

                              if (_selectedVehicle == '') {
                                // ignore: use_build_context_synchronously
                                _appSnackbar.buildSnackbar(
                                    context, 'Don\'t find a suitable vehicle!');
                                Navigator.of(context).pop();
                                return;
                              }

                              Transitions newRoute = Transitions(
                                  keyRoute: widget.isAddNew
                                      ? idNewRoute
                                      : widget.route.idRoute,
                                  from: _selectedFrom,
                                  where: _selectedWhere,
                                  departureDate: _dateEditingController.text,
                                  departureTime: _timeEditingController.text,
                                  idVehicle: _selectedVehicle,
                                  prices: _pricesEditingController.text,
                                  featured: valueFeatured.toString(),
                                  statusActive: widget.isAddNew
                                      ? '0'
                                      : valueStatus.toString());

                              late bool isSuccessed;
                              isSuccessed =
                                  await _uploadController.updateRoute(newRoute);

                              Navigator.of(context).pop();
                              if (isSuccessed == true) {
                                await _uploadController
                                    .updateStatusTicket(newRoute);
                                if (valueStatus == 1)
                                  await _uploadController
                                      .updateLocationVehicle(newRoute);
                                Get.offAll(ScaffoldWithNavigationRail(
                                  selectedIndex: 3,
                                ));
                                _appSnackbar.buildSnackbar(
                                    context, 'Successfully!');
                              } else {
                                _appSnackbar.buildSnackbar(
                                    context, 'Upload fail!');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                foregroundColor: Colors.white),
                            icon: const Icon(
                              Icons.save,
                              size: 25,
                            ),
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold', fontSize: 18),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        widget.isAddNew
                            ? const SizedBox()
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  bool shouldVerify = await _cupertinoDialog
                                      .createCupertinoDialog(
                                          AppColor.mainColor,
                                          'Delete',
                                          'Delete this route?',
                                          context);

                                  if (shouldVerify) {
                                    try {
                                      final _appCircleprogressbar =
                                          AppCircleprogressbar();
                                      _appCircleprogressbar
                                          .buildCirclerprogessbar(context);

                                      final isRemove = await _removeController
                                          .removeARoute(widget.route.idRoute);

                                      Navigator.of(context).pop();

                                      if (isRemove) {
                                        _appSnackbar.buildSnackbar(
                                            context, 'Delete Successfully!');

                                        Get.offAll(ScaffoldWithNavigationRail(
                                            selectedIndex: 3));
                                      } else {
                                        _appSnackbar.buildSnackbar(context,
                                            'Delete fail! Exist booked ticket.');
                                      }
                                    } catch (e) {
                                      _appSnackbar.buildSnackbar(context,
                                          'Delete fail! Exist booked ticket.');
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white),
                                icon: const Icon(
                                  Icons.delete,
                                  size: 25,
                                ),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontFamily: 'Roboto bold', fontSize: 18),
                                )),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}
