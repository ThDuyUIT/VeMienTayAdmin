import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/item_city_data.dart';
import 'package:booking_transition_admin/feature/presentation/Route/crud_route.dart';
import 'package:booking_transition_admin/feature/presentation/Route/item_route_data.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/crud_vehicle.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RoutePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateRoutePage();
  }
}

class StateRoutePage extends State<RoutePage> {
  late String pickedMonth = '${DateTime.now().month}/${DateTime.now().year}';
  List<RouteRowData> routeRow = [];
  final _loadingController = LoadingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Route',
              style: TextStyle(
                  fontFamily: 'Roboto bold',
                  fontSize: 25,
                  color: AppColor.mainColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Timeline',
            style: TextStyle(
              fontFamily: 'Roboto bold',
              fontSize: 20,
            ),
          ),
          Row(
            children: [
              Text(
                pickedMonth,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? foramtedDate;
                    foramtedDate = await showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));

                    setState(() {
                      pickedMonth =
                          '${foramtedDate!.month}/${foramtedDate.year}';
                    });
                    // final newTotal =
                    //     await _statisticController.totalSale(pickedMonth);

                    // final newPercent = await _statisticController
                    //     .percentEmptySeat(pickedMonth);

                    // final newPredict =
                    //     await _statisticController.predictSales(pickedMonth);

                    final newData =
                        await _loadingController.setRouteData(pickedMonth);

                    setState(() {
                      routeRow = newData;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.mainColor,
                      foregroundColor: Colors.white),
                  icon: const Icon(Icons.date_range),
                  label: Text('Pick time', style: TextStyle(fontSize: 16)))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    StateCrudRoute.cities = await GetData.fetchCities();
                    StateCrudRoute.vehicles = await GetData.fetchVehicle();
                    StateCrudRoute.upcomingRouteVehicles =
                        await _loadingController.getUpcomingRouteVehicle();
                    Get.to(CrudRoute.create(
                      isAddNew: true,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.white),
                  icon: Icon(Icons.add_rounded),
                  label: Text('Add', style: TextStyle(fontSize: 18))),
            ],
          ),

          //Header datatable
          FutureBuilder(
              future: _loadingController.setRouteData(pickedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10),
                    child: FittedBox(
                      child: DataTable(
                          dataRowMaxHeight: 0,
                          dataRowMinHeight: 0,
                          headingRowColor: MaterialStateProperty.resolveWith(
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
                                label: Text('ID Route',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('ID Vehicle',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('From',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Where',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Prices',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Time',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Booked',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('More',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                          ],
                          rows: const [
                            DataRow(cells: [
                              DataCell(Text('Number')),
                              DataCell(Text('ID Route')),
                              DataCell(Text('ID Vehicle')),
                              DataCell(Text('From')),
                              DataCell(Text('Where')),
                              DataCell(Text('Prices')),
                              DataCell(Text('Date')),
                              DataCell(Text('Time')),
                              DataCell(Text('Booked')),
                              DataCell(Text('More'))
                            ])
                          ]),
                    ),
                  );
                  // Center(
                  //   child: Container(
                  //     padding: EdgeInsets.only(top: 20),
                  //     child: CircularProgressIndicator(
                  //       color: AppColor.mainColor,
                  //     ),
                  //   ),
                  // );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  routeRow = snapshot.data;
                  if (routeRow.isNotEmpty) {
                    int index = 0;
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: FittedBox(
                        child: DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => AppColor.mainColor),
                            dataRowMaxHeight: 0,
                            dataRowMinHeight: 0,
                            //headingRowHeight: 0,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Number',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold',
                                    color: Colors.white),
                              )),
                              DataColumn(
                                  label: Text('ID Route',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('ID Vehicle',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('From',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Where',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Prices',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Date',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Time',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Booked',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('More',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                            ],
                            rows: routeRow.map((e) {
                              index += 1;
                              return DataRow(cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(e.idRoute)),
                                DataCell(Text(e.idVehicle)),
                                DataCell(Text(e.from.nameCity)),
                                DataCell(Text(e.where.nameCity)),
                                DataCell(Text(NumberFormat.decimalPattern()
                                    .format(int.parse(e.price))
                                    .toString())),
                                DataCell(Text(e.departureDate)),
                                DataCell(Text(e.departureTime)),
                                DataCell(Text(e.bookedSeat)),
                                // DataCell(
                                //   GestureDetector(
                                //     onTap: () async {
                                //       StateCrudRoute.cities =
                                //           await GetData.fetchCities();
                                //       StateCrudRoute.vehicles =
                                //           await GetData.fetchVehicle();
                                //       Get.to(CrudRoute.update(route: e));
                                //     },
                                //     child: Icon(
                                //       Icons.more_horiz_rounded,
                                //       color: AppColor.mainColor,
                                //     ),
                                //   ),
                                // )
                                DataCell(Text('More')),
                              ]);
                            }).toList()),
                      ),
                    );
                  } else {
                    //print(snapshot.l)
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10),
                      child: FittedBox(
                        child: DataTable(
                            dataRowMaxHeight: 0,
                            dataRowMinHeight: 0,
                            headingRowColor: MaterialStateProperty.resolveWith(
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
                                  label: Text('ID Route',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('ID Vehicle',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('From',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Where',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Prices',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Date',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Time',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Booked',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('More',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                            ],
                            rows: const [
                              DataRow(cells: [
                                DataCell(Text('Number')),
                                DataCell(Text('ID Route')),
                                DataCell(Text('ID Vehicle')),
                                DataCell(Text('From')),
                                DataCell(Text('Where')),
                                DataCell(Text('Prices')),
                                DataCell(Text('Date')),
                                DataCell(Text('Time')),
                                DataCell(Text('Booked')),
                                DataCell(Text('More'))
                              ])
                            ]),
                      ),
                    );
                    // Container(
                    //   padding: const EdgeInsets.only(top: 20),
                    //   child: const Center(
                    //     child: Text(
                    //       'Data don\'t exist',
                    //       style: TextStyle(fontSize: 20),
                    //     ),
                    //   ),
                    // );
                  }
                }
              }),
          //data row
          FutureBuilder(
              future: _loadingController.setRouteData(pickedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  routeRow = snapshot.data;
                  if (routeRow.isNotEmpty) {
                    int index = 0;
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          child: FittedBox(
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
                                      label: Text('ID Route',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('ID Vehicle',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('From',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Where',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Prices',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Time',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Booked',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('More',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                ],
                                rows: routeRow.map((e) {
                                  index += 1;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(e.idRoute)),
                                    DataCell(Text(e.idVehicle)),
                                    DataCell(Text(e.from.nameCity)),
                                    DataCell(Text(e.where.nameCity)),
                                    DataCell(Text(NumberFormat.decimalPattern()
                                        .format(int.parse(e.price))
                                        .toString())),
                                    DataCell(Text(e.departureDate)),
                                    DataCell(Text(e.departureTime)),
                                    DataCell(Text(e.bookedSeat)),
                                    DataCell(
                                      GestureDetector(
                                        onTap: () async {
                                          StateCrudRoute.cities =
                                              await GetData.fetchCities();
                                          StateCrudRoute.vehicles =
                                              await GetData.fetchVehicle();
                                          StateCrudRoute.upcomingRouteVehicles =
                                              await _loadingController
                                                  .getUpcomingRouteVehicle();
                                          Get.to(CrudRoute.update(route: e));
                                        },
                                        child: Icon(
                                          Icons.more_horiz_rounded,
                                          color: AppColor.mainColor,
                                        ),
                                      ),
                                    )
                                  ]);
                                }).toList()),
                          ),
                        ),
                      ),
                    );
                  } else {
                    //print(snapshot.l)
                    return Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Center(
                        child: Text(
                          'Data don\'t exist',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
