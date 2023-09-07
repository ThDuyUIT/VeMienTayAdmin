import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/controller/upload_controller.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Route/item_route_data.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_16_seats.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_29_seat.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/feature/services/insert_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTicket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateAddTicket();
  }
}

class StateAddTicket extends State<AddTicket> {
  static List<String> selectedSeats = [];
  late String _selectedFrom;
  late String _selectedWhere;

  late TextEditingController _dateEditingController;
  late TextEditingController _selectedSeatEditingController;
  late TextEditingController _totalPricesEditingController;
  late TextEditingController _nameEditingController;
  late TextEditingController _phoneEditingController;

  final _appSnackbar = AppSnackbar();

  static List<City> cities = [];
  LoadingController _loadingController = LoadingController();
  List<RouteRowData> routeRow = [];
  String selectedRoute = '';
  String idRoute = '';
  int totalSeat = 16;
  int methodPayment = 1;
  int index = 0;
  int pricesATicket = 0;
  int totalPrices = 0;

  @override
  void initState() {
    _selectedFrom = cities[0].idCity;
    _selectedWhere = cities[0].idCity;
    _dateEditingController = TextEditingController();
    _totalPricesEditingController = TextEditingController();
    _nameEditingController = TextEditingController();
    _phoneEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedSeatEditingController =
          TextEditingController(text: selectedSeats.join(', '));
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          //automaticallyImplyLeading: false,
          leadingWidth: 200,
          leading: GestureDetector(
            onTap: () {
              Get.offAll(ScaffoldWithNavigationRail(selectedIndex: 4));
            },
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: AppColor.mainColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Go Back',
                    style: TextStyle(
                        fontFamily: 'Roboto bold',
                        fontSize: 18,
                        color: AppColor.mainColor),
                  )
                ],
              ),
            ),
          )
          // title: const Text(
          //   'Go back',
          //   style: TextStyle(fontFamily: 'Roboto bold', fontSize: 20),
          // ),
          ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Add new ticket',
                  style: TextStyle(
                      fontFamily: 'Roboto bold',
                      color: AppColor.mainColor,
                      fontSize: 25),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(e.nameCity),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFrom = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Where',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(e.nameCity),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedWhere = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      TextField(
                        onTap: () async {
                          DateTime? foramtedDate;
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
                        },
                        readOnly: true,
                        controller: _dateEditingController,
                        decoration: InputDecoration(
                          hintText: 'Choose departure date',
                          hintStyle: TextStyle(color: AppColor.mainColor),
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
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        final _appCircleprogressbar = AppCircleprogressbar();
                        _appCircleprogressbar.buildCirclerprogessbar(context);
                        final newData =
                            await _loadingController.searchRouteData(
                                _selectedFrom,
                                _selectedWhere,
                                _dateEditingController.text);
                        Navigator.of(context).pop();

                        setState(() {
                          routeRow = newData;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white),
                      icon: const Icon(Icons.search),
                      label: const Text(
                        'Search',
                        style:
                            TextStyle(fontFamily: 'Roboto bold', fontSize: 18),
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColor.mainColor),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              //padding: EdgeInsets.only(left: 20, right: 20),
                              child: DataTable(
                                  dataRowMaxHeight: 0,
                                  dataRowMinHeight: 0,
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => AppColor.mainColor),
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      'Number',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          color: Colors.white),
                                    )),
                                    DataColumn(
                                        label: Text('Id vehicle',
                                            style: TextStyle(
                                                //fontFamily: 'Roboto bold',
                                                color: Colors.white))),
                                    DataColumn(
                                        label: Text('Capacity',
                                            style: TextStyle(
                                                //fontFamily: 'Roboto bold',
                                                color: Colors.white))),
                                    DataColumn(
                                        label: Text('Time',
                                            style: TextStyle(
                                                //fontFamily: 'Roboto bold',
                                                color: Colors.white))),
                                    DataColumn(
                                        label: Text('Prices',
                                            style: TextStyle(
                                                //fontFamily: 'Roboto bold',
                                                color: Colors.white))),
                                    DataColumn(
                                        label: Text('Choose',
                                            style: TextStyle(
                                                //fontFamily: 'Roboto bold',
                                                color: Colors.white))),
                                  ],
                                  rows: const [
                                    DataRow(cells: [
                                      DataCell(Text('1')),
                                      DataCell(Text('64F1-2222')),
                                      DataCell(Text('16')),
                                      DataCell(Text('13:00')),
                                      DataCell(Text('120000')),
                                      DataCell(Text('Choose')),
                                    ]),
                                  ]),
                            ),
                            // FutureBuilder(
                            //     future: _loadingController.searchRouteData(
                            //         _selectedFrom,
                            //         _selectedWhere,
                            //         _dateEditingController.text),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.connectionState ==
                            //           ConnectionState.waiting) {
                            //         return Center(
                            //           child: Container(
                            //             padding: EdgeInsets.only(top: 20),
                            //             child: CircularProgressIndicator(
                            //               color: AppColor.mainColor,
                            //             ),
                            //           ),
                            //         );
                            //       } else if (snapshot.hasError) {
                            //         return const Center(
                            //           child: Text(
                            //             'Error loading data',
                            //             style: TextStyle(fontSize: 20),
                            //           ),
                            //         );
                            //       } else {
                            //         routeRow = snapshot.data;
                            //         if (routeRow.isNotEmpty) {
                            //           int index = 0;
                            //           return Expanded(
                            //             child: SingleChildScrollView(
                            //               child: Container(
                            //                 // padding: const EdgeInsets.only(
                            //                 //     left: 20, right: 20),
                            //                 width: double.infinity,
                            //                 child: DataTable(
                            //                     // headingRowColor:
                            //                     //     MaterialStateProperty.resolveWith(
                            //                     //         (states) => AppColor.mainColor),
                            //                     headingRowHeight: 0,
                            //                     columns: const [
                            //                       DataColumn(
                            //                           label: Text(
                            //                         'Number',
                            //                         style: TextStyle(
                            //                             fontFamily:
                            //                                 'Roboto bold',
                            //                             color: Colors.white),
                            //                       )),
                            //                       DataColumn(
                            //                           label: Text('Id vehicle',
                            //                               style: TextStyle(
                            //                                   //fontFamily: 'Roboto bold',
                            //                                   color: Colors
                            //                                       .white))),
                            //                       DataColumn(
                            //                           label: Text('Capacity',
                            //                               style: TextStyle(
                            //                                   //fontFamily: 'Roboto bold',
                            //                                   color: Colors
                            //                                       .white))),
                            //                       DataColumn(
                            //                           label: Text('Time',
                            //                               style: TextStyle(
                            //                                   //fontFamily: 'Roboto bold',
                            //                                   color: Colors
                            //                                       .white))),
                            //                       DataColumn(
                            //                           label: Text('Prices',
                            //                               style: TextStyle(
                            //                                   //fontFamily: 'Roboto bold',
                            //                                   color: Colors
                            //                                       .white))),
                            //                       DataColumn(
                            //                           label: Text('Choose',
                            //                               style: TextStyle(
                            //                                   //fontFamily: 'Roboto bold',
                            //                                   color: Colors
                            //                                       .white))),
                            //                     ],
                            //                     rows: routeRow.map((e) {
                            //                       index += 1;
                            //                       return DataRow(cells: [
                            //                         DataCell(
                            //                             Text(index.toString())),
                            //                         DataCell(Text(e.idVehicle)),
                            //                         DataCell(Text(e.capacity)),
                            //                         DataCell(
                            //                             Text(e.departureTime)),
                            //                         DataCell(Text(e.price)),
                            //                         DataCell(
                            //                           GestureDetector(
                            //                             onTap: () async {
                            //                               StateList16Seats
                            //                                       .bookedSeat =
                            //                                   await _loadingController
                            //                                       .getBookedSeats(
                            //                                           e.idRoute);
                            //                               setState(() {
                            //                                 selectedRoute =
                            //                                     e.idRoute;

                            //                                 totalSeat =
                            //                                     int.parse(
                            //                                         e.capacity);
                            //                               });
                            //                               // if (selectedRoute !=
                            //                               //     '') {}
                            //                             },
                            //                             child: Icon(
                            //                               Icons.check,
                            //                               color: AppColor
                            //                                   .mainColor,
                            //                             ),
                            //                           ),
                            //                         )
                            //                       ]);
                            //                     }).toList()),
                            //               ),
                            //             ),
                            //           );
                            //         } else {
                            //           //print(snapshot.l)
                            //           return Container(
                            //             padding: const EdgeInsets.only(top: 20),
                            //             child: const Center(
                            //               child: Text(
                            //                 'Data don\'t exist',
                            //                 style: TextStyle(fontSize: 20),
                            //               ),
                            //             ),
                            //           );
                            //         }
                            //       }
                            //     }),
                            routeRow.isNotEmpty
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        // padding: const EdgeInsets.only(
                                        //     left: 20, right: 20),
                                        width: double.infinity,
                                        child: DataTable(
                                            // headingRowColor:
                                            //     MaterialStateProperty.resolveWith(
                                            //         (states) => AppColor.mainColor),
                                            headingRowHeight: 0,
                                            columns: const [
                                              DataColumn(
                                                  label: Text(
                                                'Number',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto bold',
                                                    color: Colors.white),
                                              )),
                                              DataColumn(
                                                  label: Text('Id vehicle',
                                                      style: TextStyle(
                                                          //fontFamily: 'Roboto bold',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Capacity',
                                                      style: TextStyle(
                                                          //fontFamily: 'Roboto bold',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Time',
                                                      style: TextStyle(
                                                          //fontFamily: 'Roboto bold',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Prices',
                                                      style: TextStyle(
                                                          //fontFamily: 'Roboto bold',
                                                          color:
                                                              Colors.white))),
                                              DataColumn(
                                                  label: Text('Choose',
                                                      style: TextStyle(
                                                          //fontFamily: 'Roboto bold',
                                                          color:
                                                              Colors.white))),
                                            ],
                                            rows: routeRow.map((e) {
                                              index == routeRow.length
                                                  ? index = 1
                                                  : index += 1;
                                              return DataRow(cells: [
                                                DataCell(
                                                    Text(index.toString())),
                                                DataCell(Text(e.idVehicle)),
                                                DataCell(Text(e.capacity)),
                                                DataCell(Text(e.departureTime)),
                                                DataCell(Text(e.price)),
                                                DataCell(
                                                  GestureDetector(
                                                    onTap: () async {
                                                      idRoute = e.idRoute;
                                                      pricesATicket =
                                                          int.parse(e.price);

                                                      selectedSeats.clear();
                                                      _totalPricesEditingController
                                                          .text = '0';
                                                      final _appCircleprogressbar =
                                                          AppCircleprogressbar();
                                                      _appCircleprogressbar
                                                          .buildCirclerprogessbar(
                                                              context);

                                                      if (int.parse(
                                                              e.capacity) ==
                                                          16) {
                                                        StateList16Seats
                                                                .bookedSeat =
                                                            await _loadingController
                                                                .getBookedSeats(
                                                                    e.idRoute);
                                                        for (var seat
                                                            in StateList16Seats
                                                                .seats) {
                                                          seat.color = AppColor
                                                              .mainColor;
                                                        }
                                                      } else if (int.parse(
                                                              e.capacity) ==
                                                          29) {
                                                        StateList29Seats
                                                                .bookedSeat =
                                                            await _loadingController
                                                                .getBookedSeats(
                                                                    e.idRoute);
                                                        for (var seat
                                                            in StateList29Seats
                                                                .seats) {
                                                          seat.color = AppColor
                                                              .mainColor;
                                                        }
                                                      }

                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        selectedRoute =
                                                            e.idRoute;

                                                        totalSeat = int.parse(
                                                            e.capacity);
                                                      });
                                                      // if (selectedRoute !=
                                                      //     '') {}
                                                    },
                                                    child: Icon(
                                                      Icons.check,
                                                      color: AppColor.mainColor,
                                                    ),
                                                  ),
                                                )
                                              ]);
                                            }).toList()),
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: const Center(
                                      child: Text(
                                        'Data don\'t exist',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_seat_rounded,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'Not available',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_seat_rounded,
                                          color: AppColor.mainColor,
                                          size: 30,
                                        ),
                                        const Text(
                                          'Available',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_seat_rounded,
                                          size: 30,
                                          color: Colors.greenAccent,
                                        ),
                                        Text(
                                          'Selected',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            selectedRoute != ''
                                ? totalSeat == 16
                                    ? List16Seats(
                                        onSeatsSelected: (selectedIndex) {
                                          setState(() {
                                            selectedSeats = selectedIndex;
                                            totalPrices = selectedSeats.length *
                                                pricesATicket;
                                            _totalPricesEditingController =
                                                TextEditingController(
                                                    text:
                                                        totalPrices.toString());
                                          });
                                        },
                                      )
                                    : List29Seats(
                                        onSeatsSelected: (selectedIndex) {
                                          setState(() {
                                            selectedSeats = selectedIndex;
                                            totalPrices = selectedSeats.length *
                                                pricesATicket;
                                            _totalPricesEditingController =
                                                TextEditingController(
                                                    text:
                                                        totalPrices.toString());
                                          });
                                        },
                                      )
                                : Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: const Center(
                                      child: Text(
                                        'Data don\'t exist',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                            // FutureBuilder(
                            //     future: _loadingController
                            //         .getBookedSeats(selectedRoute),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.connectionState ==
                            //           ConnectionState.waiting) {
                            //         return Center(
                            //           child: Container(
                            //             padding: EdgeInsets.only(top: 20),
                            //             child: CircularProgressIndicator(
                            //               color: AppColor.mainColor,
                            //             ),
                            //           ),
                            //         );
                            //       } else if (snapshot.hasError) {
                            //         return const Center(
                            //           child: Text(
                            //             'Error loading data',
                            //             style: TextStyle(fontSize: 20),
                            //           ),
                            //         );
                            //       } else {
                            //         StateList16Seats.bookedSeat = snapshot.data;
                            //         if (selectedRoute != '') {
                            //           return List16Seats(
                            //             onSeatsSelected: (selectedIndex) {
                            //               setState(() {
                            //                 selectedSeats = selectedIndex;
                            //               });
                            //             },
                            //           );
                            //         } else {
                            //           return Container(
                            //             padding: const EdgeInsets.only(top: 20),
                            //             child: const Center(
                            //               child: Text(
                            //                 'Data don\'t exist',
                            //                 style: TextStyle(fontSize: 20),
                            //               ),
                            //             ),
                            //           );
                            //         }
                            //       }
                            //     })
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey,
                ),
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            TextField(
                              controller: _nameEditingController,
                              decoration: InputDecoration(
                                hintText: 'Enter client\'s name',
                                hintStyle: TextStyle(color: AppColor.mainColor),
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
                      )),
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            TextField(
                              controller: _phoneEditingController,
                              decoration: InputDecoration(
                                hintText: 'Enter client\'s phone numbers',
                                hintStyle: TextStyle(color: AppColor.mainColor),
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
                      )),
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Booked Seats',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            TextField(
                              readOnly: true,
                              controller: _selectedSeatEditingController,
                              decoration: InputDecoration(
                                hintText: 'Choose client\'s seats',
                                hintStyle: TextStyle(color: AppColor.mainColor),
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
                      )),
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total prices',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                            TextField(
                              readOnly: true,
                              controller: _totalPricesEditingController,
                              decoration: InputDecoration(
                                hintText: 'The ticket\'s prices',
                                hintStyle: TextStyle(color: AppColor.mainColor),
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
                      )),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: TextStyle(
                                      fontFamily: 'Roboto bold',
                                      fontSize: 18,
                                      color: Colors.grey),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Radio(
                                                  activeColor:
                                                      AppColor.mainColor,
                                                  value: 1,
                                                  groupValue: methodPayment,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      methodPayment = value!;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'VeMienTay',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto bold',
                                                      fontSize: 16,
                                                      color:
                                                          AppColor.mainColor),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Radio(
                                                activeColor: AppColor.mainColor,
                                                value: 2,
                                                groupValue: methodPayment,
                                                onChanged: (value) {
                                                  setState(() {
                                                    methodPayment = value!;
                                                  });
                                                },
                                              ),
                                              Container(
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Zalo',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto bold',
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .mainColor),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .green.shade400,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: const Text('Pay',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto bold',
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white)),
                                                      )
                                                    ]),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_nameEditingController.text.isEmpty) {
                                      _appSnackbar.buildSnackbar(context,
                                          'Please fill client\'s name!');
                                      return;
                                    }

                                    if (_phoneEditingController.text.isEmpty) {
                                      _appSnackbar.buildSnackbar(context,
                                          'Please fill client\'s phone!');
                                      return;
                                    }

                                    if (selectedSeats.isEmpty) {
                                      _appSnackbar.buildSnackbar(context,
                                          'Please choose client\'s seats!');
                                      return;
                                    }

                                    String idAccount =
                                        "KHVL${_nameEditingController.text.trim()}PN${_phoneEditingController.text}";
                                    String idTicket =
                                        'VE${DateTime.now().millisecondsSinceEpoch}';

                                    Ticket newTicket = Ticket(
                                        keyTicket: idTicket,
                                        idAccount: idAccount,
                                        idTransition: idRoute,
                                        priceTotal: totalPrices.toString(),
                                        methodPayment: methodPayment.toString(),
                                        statusPayment: '0',
                                        statusTicket: '0');

                                    UploadController _uploadController =
                                        UploadController();
                                    final _appCircleprogressbar =
                                        AppCircleprogressbar();
                                    _appCircleprogressbar
                                        .buildCirclerprogessbar(context);
                                    final isUploadTicket =
                                        await _uploadController
                                            .updateTicket(newTicket);
                                    Navigator.of(context).pop();
                                    if (isUploadTicket) {
                                      try {
                                        selectedSeats.forEach((element) async {
                                          DetailTicket detailTicket =
                                              DetailTicket(
                                                  idTicket: idTicket,
                                                  numberSeat: element);
                                          final isUploadDetail =
                                              await InsertData()
                                                  .insertDetailTicket(
                                                      detailTicket);
                                        });
                                        _appSnackbar.buildSnackbar(
                                            context, 'Successfully!');

                                        StateList16Seats.bookedSeat =
                                            await _loadingController
                                                .getBookedSeats(idRoute);

                                        setState(() {
                                          selectedSeats.clear();
                                          totalPrices = 0;
                                        });
                                      } catch (e) {
                                        _appSnackbar.buildSnackbar(
                                            context, 'Fail!');
                                      }
                                    } else {
                                      _appSnackbar.buildSnackbar(
                                          context, 'Fail!');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      foregroundColor: Colors.white),
                                  icon: Icon(Icons.save),
                                  label: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontFamily: 'Roboto bold',
                                      fontSize: 18,
                                    ),
                                  ))
                            ]),
                      )
                    ],
                  ),
                )),
              ]),
            ))
          ],
        ),
      ),
    ));
  }
}
