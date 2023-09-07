import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/crud_vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/item_vehicle_data.dart';
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
                  onPressed: () {
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
          const SizedBox(
            height: 20,
          ),
          Container(
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
                    DataCell(Text('1')),
                    DataCell(Text('64F1-9019')),
                    DataCell(Text('Ghe tua 16 cho')),
                    DataCell(Text('16')),
                    DataCell(Text('1')),
                    DataCell(Text('More')
                        // Icon(
                        //   Icons.more_horiz_rounded,
                        //   color: AppColor.mainColor,
                        // ),
                        )
                  ])
                ]),
          ),
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
                                    onTap: () {
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
