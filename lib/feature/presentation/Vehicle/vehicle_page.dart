import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/crud_vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/item_vehicle_data.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehiclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateVehicle();
  }
}

class StateVehicle extends State<VehiclePage> {
  final _loadingController = LoadingController();
  List<VehicleRowData> vehicles = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Vehicle',
              style: TextStyle(
                  fontFamily: 'Roboto bold',
                  fontSize: 25,
                  color: AppColor.mainColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    StateEditVehicle.location = await GetData.fetchCities();
                    Get.to(CrudVehicle.create(
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
          //header datatable
          FutureBuilder(
              future: _loadingController.setVehicleData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20),
                    //height: 30,
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
                                fontFamily: 'Roboto bold', color: Colors.white),
                          )),
                          DataColumn(
                              label: Text('ID Vehicle',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Name',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Capacity',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Total Routes',
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
                            DataCell(Text('ID Vehicle')),
                            DataCell(Text('Name')),
                            DataCell(Text('Capacity')),
                            DataCell(Text('Total Routes')),
                            DataCell(Text('More')
                                // Icon(
                                //   Icons.more_horiz_rounded,
                                //   color: AppColor.mainColor,
                                // ),
                                )
                          ])
                        ]),
                  );
                  // Center(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(top: 20),
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
                  vehicles = snapshot.data;
                  if (vehicles.isNotEmpty) {
                    int index = 0;
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      width: double.infinity,
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
                                label: Text('ID Vehicle',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Capacity',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Total Routes',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('More',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                          ],
                          rows: vehicles.map((e) {
                            index += 1;
                            return DataRow(cells: [
                              DataCell(Text(
                                index.toString(),
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(
                                e.idVehicle,
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(e.name)),
                              DataCell(Text(e.capacity.toString())),
                              DataCell(Text(e.totalRoutes)),
                              DataCell(Text('More')),
                              // DataCell(
                              //   GestureDetector(
                              //     onTap: () async {
                              //       StateEditVehicle.isActive =
                              //           await StateEditVehicle.triggerController
                              //               .checkActiveVehicle(e.idVehicle);
                              //       Get.to(CrudVehicle.update(vehicle: e));
                              //     },
                              //     child: Icon(
                              //       Icons.more_horiz_rounded,
                              //       color: AppColor.mainColor,
                              //     ),
                              //   ),
                              // )
                            ]);
                          }).toList()),
                    );
                  } else {
                    //print(snapshot.l)
                    return Container(
                      width: double.infinity,
                      //height: 30,
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
                                label: Text('ID Vehicle',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Capacity',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Total Routes',
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
                              DataCell(Text('ID Vehicle')),
                              DataCell(Text('Name')),
                              DataCell(Text('Capacity')),
                              DataCell(Text('Total Routes')),
                              DataCell(Text('More')
                                  // Icon(
                                  //   Icons.more_horiz_rounded,
                                  //   color: AppColor.mainColor,
                                  // ),
                                  )
                            ])
                          ]),
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
          //row data
          FutureBuilder(
              future: _loadingController.setVehicleData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
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
                  vehicles = snapshot.data;
                  if (vehicles.isNotEmpty) {
                    int index = 0;
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: DataTable(
                            // headingRowColor: MaterialStateProperty.resolveWith(
                            //     (states) => AppColor.mainColor),
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
                                  label: Text('ID Vehicle',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Name',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Capacity',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Total Routes',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('More',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                            ],
                            rows: vehicles.map((e) {
                              index += 1;
                              return DataRow(cells: [
                                DataCell(Text(
                                  index.toString(),
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(Text(
                                  e.idVehicle,
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(Text(e.name)),
                                DataCell(Text(e.capacity.toString())),
                                DataCell(Text(e.totalRoutes)),
                                DataCell(
                                  GestureDetector(
                                    onTap: () async {
                                      StateEditVehicle.isActive =
                                          await StateEditVehicle
                                              .triggerController
                                              .checkActiveVehicle(e.idVehicle);
                                      StateEditVehicle.location =
                                          await GetData.fetchCities();
                                      StateEditVehicle.upcomingRouteVehicles =
                                          await _loadingController
                                              .getUpcomingRouteVehicle();
                                      Get.to(CrudVehicle.update(vehicle: e));
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
                    ));
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
