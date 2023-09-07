import 'package:booking_transition_admin/feature/controller/loading_controller.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/add_ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/crud_ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/edit_ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/item_ticket_data.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_16_seats.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_29_seat.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TicketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateTicketPage();
  }
}

class StateTicketPage extends State<TicketPage> {
  //late String pickedMonth = '${DateTime.now().month}/${DateTime.now().year}';
  // late String _selectedFrom;
  // late String _selectedWhere;
  // static List<City> cities = [];
  late TextEditingController _dateEditingController;
  late TextEditingController _phoneEditingController;
  final _loadingController = LoadingController();
  List<TicketRowData> ticketRow = [];
  String inputPhone = '';

  @override
  void initState() {
    //_selectedFrom = cities[0].idCity;
    //_selectedWhere = cities[0].idCity;
    String now =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    _dateEditingController = TextEditingController(text: now);
    super.initState();
    _phoneEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    print(_dateEditingController.text);
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Ticket',
              style: TextStyle(
                  fontFamily: 'Roboto bold',
                  fontSize: 25,
                  color: AppColor.mainColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontFamily: 'Roboto bold',
                          fontSize: 20,
                        ),
                      ),
                      TextField(
                        controller: _dateEditingController,
                        onTap: () async {
                          DateTime? formatedDate;
                          formatedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030));

                          if (formatedDate != null) {
                            setState(() {
                              _dateEditingController.text =
                                  '${formatedDate?.day}/${formatedDate?.month}/${formatedDate?.year}';
                            });
                          }
                        },
                        readOnly: true,
                        //controller: _dateEditingController,
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
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone',
                        style: TextStyle(
                          fontFamily: 'Roboto bold',
                          fontSize: 20,
                        ),
                      ),
                      RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (RawKeyEvent event) {
                          if (event.runtimeType == RawKeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace) {
                            if (_phoneEditingController.text.isNotEmpty) {
                              setState(() {
                                inputPhone = _phoneEditingController.text;
                                inputPhone = inputPhone.substring(
                                    0, inputPhone.length - 1);
                                _phoneEditingController.text = inputPhone;
                              });
                            }
                          }
                        },
                        child: TextField(
                          onChanged: (value) async {
                            inputPhone = inputPhone + value;
                            _phoneEditingController.text = inputPhone;
                            final newTicketData =
                                await _loadingController.setTicketData(
                                    _dateEditingController.text,
                                    _phoneEditingController.text);

                            setState(() {
                              ticketRow = newTicketData;
                            });
                          },
                          controller: _phoneEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter client\' phone numbers',
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
                      ),
                    ],
                  ),
                ),
              ],
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
                    StateAddTicket.cities = await GetData.fetchCities();
                    Get.to(AddTicket());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.white),
                  icon: Icon(Icons.add_rounded),
                  label: Text('Add', style: TextStyle(fontSize: 18))),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10),
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
                      label: Text('Name',
                          style: TextStyle(
                              //fontFamily: 'Roboto bold',
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Phone',
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
                      label: Text('Status Payment',
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
                    DataCell(Text('Nguyen Thanh Duy')),
                    DataCell(Text('0828767179')),
                    DataCell(Text('Vinh Long')),
                    DataCell(Text('Hau Giang')),
                    DataCell(Text('120000')),
                    DataCell(Text('26/8/2023')),
                    DataCell(Text('03:00')),
                    DataCell(Text('Unpaid')),
                    DataCell(Text('More'))
                  ])
                ]),
          ),
          FutureBuilder(
              future: _loadingController.setTicketData(
                  _dateEditingController.text, _phoneEditingController.text),
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
                  ticketRow = snapshot.data;
                  if (ticketRow.isNotEmpty) {
                    int index = 0;
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Container(
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
                                  label: Text('Name',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Phone',
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
                                  label: Text('Status Payment',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('More',
                                      style: TextStyle(
                                          //fontFamily: 'Roboto bold',
                                          color: Colors.white))),
                            ],
                            rows: ticketRow.map((e) {
                              index += 1;
                              return DataRow(cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(e.name)),
                                DataCell(Text(e.phone)),
                                DataCell(Text(e.from)),
                                DataCell(Text(e.where)),
                                DataCell(Text(e.prices)),
                                DataCell(Text(e.departureDate)),
                                DataCell(Text(e.departureTime)),
                                DataCell(Text(e.statusPayment == '0'
                                    ? "Unpaid"
                                    : "Paid")),
                                DataCell(
                                  GestureDetector(
                                    onTap: () async {
                                      Transitions bookedRoute =
                                          await _loadingController
                                              .getTheBookedRoute(e.idRoute);
                                      Vehicle bookedVehicle =
                                          await _loadingController
                                              .getTheBookedVehicle(
                                                  bookedRoute.idVehicle);

                                      final editSeats = await _loadingController
                                          .getEditedSeat(e.idTicket);

                                      final detailBookedTicket =
                                          await _loadingController
                                              .getDetailId(e.idTicket);

                                      if (bookedVehicle.capacity == 16) {
                                        StateList16Seats.bookedSeat =
                                            await _loadingController
                                                .getBookedSeats(e.idRoute);
                                        for (var seat
                                            in StateList16Seats.seats) {
                                          seat.color = AppColor.mainColor;
                                        }
                                      } else if (bookedVehicle.capacity == 29) {
                                        StateList29Seats.bookedSeat =
                                            await _loadingController
                                                .getBookedSeats(e.idRoute);
                                        for (var seat
                                            in StateList29Seats.seats) {
                                          seat.color = AppColor.mainColor;
                                        }
                                      }

                                      Get.to(EditTicket(
                                        ticket: e,
                                        bookedRoute: bookedRoute,
                                        bookedvehicle: bookedVehicle,
                                        editedSeat: editSeats,
                                        detailBookedTicket: detailBookedTicket,
                                      ));
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
