import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/controller/statistic_controller.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/item_dashboard_data.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/item_table_summay.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/main.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateDashBoard();
  }
}

class StateDashBoard extends State<DashBoard> {
  late String pickedMonth = '${DateTime.now().month}/${DateTime.now().year}';
  final _statisticController = StatisticController();
  final _loadingController = LoadingController();
  late String totalSales;
  late String percentEmpty;
  late String predictSales;
  List<DashboardRowData> dashboardRow = [];
  //late double widthScreen;
  late double textSize;
  late double distanceElement;

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   widthScreen = MyApp.widthScreen;
    // });
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Dashboard',
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
              'Statistics',
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
                const SizedBox(
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
                      final newTotal =
                          await _statisticController.totalSale(pickedMonth);

                      final newPercent = await _statisticController
                          .percentEmptySeat(pickedMonth);

                      final newPredict =
                          await _statisticController.predictSales(pickedMonth);

                      final newData = await _loadingController
                          .setDashboardData(pickedMonth);

                      setState(() {
                        totalSales = newTotal.toString();
                        percentEmpty = newPercent.toString();
                        predictSales = newPredict.toString();
                        dashboardRow = newData;
                        // Get.offAll(ScaffoldWithNavigationRail(
                        //   selectedIndex: 0,
                        // ));
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
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: FutureBuilder(
                      future: _statisticController.predictSales(pickedMonth),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          predictSales = NumberFormat.decimalPattern()
                              .format(snapshot.data)
                              .toString();
                          return TableSummary(
                              title: 'Prediction Sales',
                              value: 'VND: $predictSales');
                        }
                      })),
              Expanded(
                  child: FutureBuilder(
                      future: _statisticController.totalSale(pickedMonth),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
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
                          totalSales = NumberFormat.decimalPattern()
                              .format(snapshot.data)
                              .toString();
                          return TableSummary(
                              title: 'Total Sales', value: 'VND: $totalSales');
                        }
                      })),
              Expanded(
                  child: FutureBuilder(
                      future:
                          _statisticController.percentEmptySeat(pickedMonth),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainColor,
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
                          try {
                            percentEmpty = snapshot.data.toString();
                            // if (percentEmpty != '0') {
                            //   int indexOfDec = percentEmpty.indexOf('.');
                            //   percentEmpty =
                            //       percentEmpty.substring(0, indexOfDec + 4);
                            // }
                          } catch (e) {
                            print(e);
                          }
                          return TableSummary(
                              title: 'Empty seat percent',
                              value: '%: $percentEmpty');
                        }
                      })),
            ]),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   width: double.infinity,
            //   //height: 30,
            //   child: FittedBox(
            //     child: DataTable(
            //         dataRowMaxHeight: 0,
            //         dataRowMinHeight: 0,
            //         headingRowColor: MaterialStateProperty.resolveWith(
            //             (states) => AppColor.mainColor),
            //         // headingTextStyle: widthScreen < 1296
            //         //     ? TextStyle(fontSize: 10)
            //         //     : TextStyle(fontSize: 14),
            //         // dataTextStyle: MyApp.widthScreen < 1296
            //         //     ? TextStyle(fontSize: 10)
            //         //     : TextStyle(fontSize: 14),
            //         columns: const [
            //           DataColumn(
            //               label: Text(
            //             'Number',
            //             style: TextStyle(
            //                 fontFamily: 'Roboto bold', color: Colors.white),
            //           )),
            //           DataColumn(
            //               label: Text('ID Vehicle',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Capacity',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('From',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Where',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Prices',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Departure Date',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Departure Time',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //           DataColumn(
            //               label: Text('Booked Seats',
            //                   style: TextStyle(
            //                       //fontFamily: 'Roboto bold',
            //                       color: Colors.white))),
            //         ],
            //         rows: const [
            //           DataRow(cells: [
            //             DataCell(Text('1')),
            //             DataCell(Text('64F1-9019')),
            //             DataCell(Text('16')),
            //             DataCell(Text('Vinh Long')),
            //             DataCell(Text('Tp Ho Chi Minh')),
            //             DataCell(Text('120000')),
            //             DataCell(Text('26/8/2023')),
            //             DataCell(Text('03:00')),
            //             DataCell(Text('2')),
            //           ])
            //         ]),
            //   ),
            // ),
            FutureBuilder(
                future: _loadingController.setDashboardData(pickedMonth),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      //height: 30,
                      child: FittedBox(
                        child: DataTable(
                            dataRowMaxHeight: 0,
                            dataRowMinHeight: 0,
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => AppColor.mainColor),
                            // headingTextStyle: widthScreen < 1296
                            //     ? TextStyle(fontSize: 10)
                            //     : TextStyle(fontSize: 14),
                            // dataTextStyle: MyApp.widthScreen < 1296
                            //     ? TextStyle(fontSize: 10)
                            //     : TextStyle(fontSize: 14),
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
                                  label: Text('Capacity',
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
                            ],
                            rows: const [
                              DataRow(cells: [
                                DataCell(Text('Number')),
                                DataCell(Text('ID Vehicle')),
                                DataCell(Text('Capacity')),
                                DataCell(Text('From')),
                                DataCell(Text('Where')),
                                DataCell(Text('Prices')),
                                DataCell(Text('Date')),
                                DataCell(Text('Time')),
                                DataCell(Text('Booked')),
                              ])
                            ]),
                      ),
                    );
                    // Container(
                    //   padding: EdgeInsets.all(20),
                    //   child: Center(
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
                    dashboardRow = snapshot.data;
                    if (dashboardRow.isNotEmpty) {
                      int index = 0;
                      return Container(
                        width: double.infinity,
                        child: FittedBox(
                          child: DataTable(
                              //headingRowHeight: 0,
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
                                    label: Text('ID Vehicle',
                                        style: TextStyle(
                                            //fontFamily: 'Roboto bold',
                                            color: Colors.white))),
                                DataColumn(
                                    label: Text('Capacity',
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
                                    label: Text('Departure Date',
                                        style: TextStyle(
                                            //fontFamily: 'Roboto bold',
                                            color: Colors.white))),
                                DataColumn(
                                    label: Text('Departure Time',
                                        style: TextStyle(
                                            //fontFamily: 'Roboto bold',
                                            color: Colors.white))),
                                DataColumn(
                                    label: Text('Booked Seats',
                                        style: TextStyle(
                                            //fontFamily: 'Roboto bold',
                                            color: Colors.white))),
                              ],
                              rows: dashboardRow.map((e) {
                                index += 1;
                                return DataRow(cells: [
                                  DataCell(Text(index.toString())),
                                  DataCell(Text(e.idVehicle)),
                                  DataCell(Text(e.capacity)),
                                  DataCell(Text(e.from)),
                                  DataCell(Text(e.where)),
                                  DataCell(Text(NumberFormat.decimalPattern()
                                      .format(int.parse(e.prices))
                                      .toString())),
                                  DataCell(Text(e.departureDate)),
                                  DataCell(Text(e.departureTime)),
                                  DataCell(Text(e.bookedSeat)),
                                ]);
                              }).toList()),
                        ),
                      );
                    } else {
                      //print(snapshot.l)
                      return Container(
                        width: double.infinity,
                        //height: 30,
                        child: FittedBox(
                          child: DataTable(
                              dataRowMaxHeight: 0,
                              dataRowMinHeight: 0,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => AppColor.mainColor),
                              // headingTextStyle: widthScreen < 1296
                              //     ? TextStyle(fontSize: 10)
                              //     : TextStyle(fontSize: 14),
                              // dataTextStyle: MyApp.widthScreen < 1296
                              //     ? TextStyle(fontSize: 10)
                              //     : TextStyle(fontSize: 14),
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
                                    label: Text('Capacity',
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
                              ],
                              rows: const [
                                DataRow(cells: [
                                  DataCell(Text('Number')),
                                  DataCell(Text('ID Vehicle')),
                                  DataCell(Text('Capacity')),
                                  DataCell(Text('From')),
                                  DataCell(Text('Where')),
                                  DataCell(Text('Prices')),
                                  DataCell(Text('Date')),
                                  DataCell(Text('Time')),
                                  DataCell(Text('Booked')),
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
                future: _loadingController.setDashboardData(pickedMonth),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
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
                    dashboardRow = snapshot.data;
                    if (dashboardRow.isNotEmpty) {
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
                                // headingTextStyle: widthScreen < 1296
                                //     ? TextStyle(fontSize: 10)
                                //     : TextStyle(fontSize: 14),
                                // dataTextStyle: MyApp.widthScreen < 1296
                                //     ? TextStyle(fontSize: 10)
                                //     : TextStyle(fontSize: 14),
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
                                      label: Text('Capacity',
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
                                      label: Text('Departure Date',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Departure Time',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text('Booked Seats',
                                          style: TextStyle(
                                              //fontFamily: 'Roboto bold',
                                              color: Colors.white))),
                                ],
                                rows: dashboardRow.map((e) {
                                  index += 1;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(e.idVehicle)),
                                    DataCell(Text(e.capacity)),
                                    DataCell(Text(e.from)),
                                    DataCell(Text(e.where)),
                                    DataCell(Text(NumberFormat.decimalPattern()
                                        .format(int.parse(e.prices))
                                        .toString())),
                                    DataCell(Text(e.departureDate)),
                                    DataCell(Text(e.departureTime)),
                                    DataCell(Text(e.bookedSeat)),
                                  ]);
                                }).toList()),
                          ),
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
        ));
  }
}
