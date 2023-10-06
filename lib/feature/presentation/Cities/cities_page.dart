import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/crud_city.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/item_city_data.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/crud_vehicle.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateCityPage();
  }
}

class StateCityPage extends State<CityPage> {
  final _loadingController = LoadingController();
  List<CityRowData> cities = [];

  void setIdNewCity() {
    //cities = await _loadingController.setCityData();
    int index = 1;
    String newId = '';
    for (var city in cities) {
      if (index < 10) {
        newId = 'DD0$index';
        print(city.idCity);
        if (newId == city.idCity) {
          index++;
          continue;
        } else {
          StateCrudCity.idCity = newId;
          return;
        }
      } else {
        newId = 'DD$index';
        if (newId == city.idCity) {
          index++;
          continue;
        } else {
          StateCrudCity.idCity = newId;
          return;
        }
      }
    }
    if (StateCrudCity.idCity == '') {
      if (index < 10) {
        StateCrudCity.idCity = 'DD0$index';
      } else {
        StateCrudCity.idCity = 'DD$index';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'City Point',
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
                    setIdNewCity();
                    Get.to(CrudCity.create(
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
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: _loadingController.setCityData(),
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
                              label: Text('ID City',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Name',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                          // DataColumn(
                          //     label: Text('Image',
                          //         style: TextStyle(
                          //             //fontFamily: 'Roboto bold',
                          //             color: Colors.white))),
                          DataColumn(
                              label: Text('More',
                                  style: TextStyle(
                                      //fontFamily: 'Roboto bold',
                                      color: Colors.white))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Number')),
                            DataCell(Text('ID City')),
                            DataCell(Text('Name')),
                            // DataCell(Image(
                            //     width: 80,
                            //     height: 50,
                            //     image: AssetImage("assets/images/imgExample.png"))),
                            DataCell(Text('More'))
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
                  cities = snapshot.data;
                  if (cities.isNotEmpty) {
                    int index = 0;
                    return Container(
                      width: double.infinity,
                      child: DataTable(
                          dataRowMinHeight: 0,
                          dataRowMaxHeight: 0,
                          headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => AppColor.mainColor),
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
                                label: Text('ID City',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                            // DataColumn(
                            //     label: Text('Image',
                            //         style: TextStyle(
                            //             //fontFamily: 'Roboto bold',
                            //             color: Colors.white))),
                            DataColumn(
                                label: Text('More',
                                    style: TextStyle(
                                        //fontFamily: 'Roboto bold',
                                        color: Colors.white))),
                          ],
                          rows: cities.map((e) {
                            index += 1;
                            return DataRow(cells: [
                              DataCell(Text(
                                index.toString(),
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e.idCity,
                                ),
                              )),
                              DataCell(Text(e.nameCity)),
                              DataCell(Text('More')),
                              // DataCell(Image(
                              //   image: NetworkImage(
                              //     e.urlImage,
                              //   ),
                              //   width: 100,
                              //   height: 50,
                              // )),
                              // DataCell(
                              //   GestureDetector(
                              //     onTap: () async {
                              //       StateCrudCity.isActive = await StateCrudCity
                              //           .triggerController
                              //           .checkActiveCity(e.idCity);
                              //       await DefaultCacheManager().emptyCache();
                              //       Get.to(CrudCity.update(city: e));
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
          FutureBuilder(
              future: _loadingController.setCityData(),
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
                  cities = snapshot.data;
                  if (cities.isNotEmpty) {
                    int index = 0;
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: DataTable(
                            // dataRowMinHeight: 0,
                            // dataRowMaxHeight: 0,
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
                                  label: Text('ID City',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Name',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              // DataColumn(
                              //     label: Text('Image',
                              //         style: TextStyle(
                              //             //fontFamily: 'Roboto bold',
                              //             color: Colors.white))),
                              DataColumn(
                                  label: Text('More',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                            ],
                            rows: cities.map((e) {
                              index += 1;
                              return DataRow(cells: [
                                DataCell(Text(
                                  index.toString(),
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e.idCity,
                                  ),
                                )),
                                DataCell(Text(e.nameCity)),
                                // DataCell(Image(
                                //   image: NetworkImage(
                                //     e.urlImage,
                                //   ),
                                //   width: 100,
                                //   height: 50,
                                // )),
                                DataCell(
                                  GestureDetector(
                                    onTap: () async {
                                      StateCrudCity.isActive =
                                          await StateCrudCity.triggerController
                                              .checkActiveCity(e.idCity);
                                      await DefaultCacheManager().emptyCache();
                                      Get.to(CrudCity.update(city: e));
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
