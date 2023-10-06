import 'dart:math';

import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/mycupertinodialog.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/remove_controller.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/item_ticket_data.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_16_seats.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/list_29_seat.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/ticket_page.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/feature/services/insert_data.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditTicket extends StatefulWidget {
  late TicketRowData ticket;
  late Vehicle bookedvehicle;
  late Transitions bookedRoute;
  late List<String> editedSeat;
  late List<String> detailBookedTicket;

  EditTicket(
      {super.key,
      required this.ticket,
      required this.bookedRoute,
      required this.bookedvehicle,
      required this.editedSeat,
      required this.detailBookedTicket});

  @override
  State<StatefulWidget> createState() {
    return StateEditTicket();
  }
}

class StateEditTicket extends State<EditTicket> {
  late TextEditingController _nameVehicleEditingController;
  late TextEditingController _idVehicleEditingController;
  late TextEditingController _capacityEditingController;
  late TextEditingController _nameClientEditingController;
  late TextEditingController _phoneEditingController;
  late TextEditingController _selectedSeatEditingController;
  late TextEditingController _totalPricesEditingController;

  late int methodPayment;
  late int statusPayment;
  static late int statusTicket;
  late double totalPrices;

  final _removeController = RemoveController();
  final _cupertinoDialog = MyCupertinoDialog();

  final _appSnackbar = AppSnackbar();

  static late List<String> selectedSeats;

  late String nameStatusTicket;
  @override
  void initState() {
    if (widget.bookedvehicle.capacity == 16) {
      StateList16Seats.selectedindex = widget.editedSeat;
      selectedSeats = StateList16Seats.selectedindex;
    } else {
      StateList29Seats.selectedindex = widget.editedSeat;
      selectedSeats = StateList29Seats.selectedindex;
    }

    //totalPrices = widget.ticket.prices
    _nameVehicleEditingController =
        TextEditingController(text: widget.bookedvehicle.name);
    _idVehicleEditingController =
        TextEditingController(text: widget.bookedvehicle.idVehicle);
    _capacityEditingController =
        TextEditingController(text: widget.bookedvehicle.capacity.toString());
    _nameClientEditingController =
        TextEditingController(text: widget.ticket.name);
    _phoneEditingController = TextEditingController(text: widget.ticket.phone);
    _totalPricesEditingController =
        TextEditingController(text: widget.ticket.prices);

    methodPayment = int.parse(widget.ticket.methodPayment);
    statusPayment = int.parse(widget.ticket.statusPayment);
    statusTicket = int.parse(widget.ticket.statusTicket);
    StateList16Seats.statusTicket = statusTicket;
    StateList29Seats.statusTicket = statusTicket;
    if (statusTicket == 0) {
      nameStatusTicket = 'Upcoming';
    } else if (statusTicket == 1) {
      nameStatusTicket = 'Complete';
    } else {
      nameStatusTicket = 'Cancel';
    }
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
              //Get.offAll(ScaffoldWithNavigationRail(selectedIndex: 4));
              selectedSeats.clear();
              Get.back();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Edit ticket - ID: ${widget.ticket.idTicket}',
                style: TextStyle(
                    fontFamily: 'Roboto bold',
                    color: AppColor.mainColor,
                    fontSize: 25),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '($nameStatusTicket)',
                style: TextStyle(
                    //fontFamily: 'Roboto bold',
                    color: statusTicket == 0
                        ? Colors.yellow
                        : statusTicket == 1
                            ? Colors.greenAccent
                            : Colors.redAccent,
                    fontSize: 20),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () async {
                          bool shouldVerify =
                              await _cupertinoDialog.createCupertinoDialog(
                                  AppColor.mainColor,
                                  'Cancel',
                                  'Cancel this ticket?',
                                  context);
                          if (shouldVerify) {
                            statusTicket = 2;
                            setState(() {
                              nameStatusTicket = 'Cancel';
                            });
                          }
                        },
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(fontSize: 20, color: Colors.redAccent),
                        ))),
              )
            ]),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor.mainColor),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vehicle\'s ID',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _idVehicleEditingController,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter client\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vehicle\'s name',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _nameVehicleEditingController,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter client\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vehicle\'s capacity',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _capacityEditingController,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter client\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                              widget.bookedRoute.keyRoute.isNotEmpty
                                  ? widget.bookedvehicle.capacity == 16
                                      ? List16Seats(onSeatsSelected:
                                          (selectedIndex) async {
                                          setState(() {
                                            selectedSeats = selectedIndex;
                                            totalPrices = selectedSeats.length *
                                                double.parse(
                                                    widget.bookedRoute.prices);
                                            if (totalPrices != 0) {
                                              _totalPricesEditingController =
                                                  TextEditingController(
                                                      text: totalPrices
                                                          .toString());
                                            } else {
                                              _totalPricesEditingController =
                                                  TextEditingController();
                                            }
                                          });
                                        })
                                      : List29Seats(onSeatsSelected:
                                          (selectedIndex) async {
                                          setState(() {
                                            selectedSeats = selectedIndex;
                                            totalPrices = selectedSeats.length *
                                                double.parse(
                                                    widget.bookedRoute.prices);
                                            if (totalPrices != 0) {
                                              _totalPricesEditingController =
                                                  TextEditingController(
                                                      text: totalPrices
                                                          .toString());
                                            } else {
                                              _totalPricesEditingController =
                                                  TextEditingController();
                                            }
                                          });
                                        })
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
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          width: 1,
                          height: double.infinity,
                          color: Colors.grey,
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
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
                                      controller: _nameClientEditingController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Enter client\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
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
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter client\'s phone numbers',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
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
                                      controller:
                                          _selectedSeatEditingController,
                                      decoration: InputDecoration(
                                        hintText: widget.editedSeat.join(', '),
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
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
                                      'Total prices(VND)',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _totalPricesEditingController,
                                      decoration: InputDecoration(
                                        // hintText: NumberFormat.decimalPattern()
                                        //     .format(
                                        //         int.parse(widget.ticket.prices))
                                        //     .toString(),
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment Method',
                                        style: TextStyle(
                                            fontFamily: 'Roboto bold',
                                            fontSize: 18,
                                            color: Colors.grey),
                                      ),
                                      Container(
                                        // padding:
                                        //     EdgeInsets.only(top: 5, bottom: 5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.mainColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Radio(
                                                        activeColor:
                                                            AppColor.mainColor,
                                                        value: 1,
                                                        groupValue:
                                                            methodPayment,
                                                        onChanged: (value) {
                                                          if (statusTicket !=
                                                              0) {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    "The ticket was finished!");
                                                            return;
                                                          }

                                                          if (widget.ticket
                                                                  .statusPayment ==
                                                              '1') {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    "The ticket is paid. Can\'t update!");
                                                            return;
                                                          }
                                                          setState(() {
                                                            methodPayment =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        'VeMienTay',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto bold',
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .mainColor),
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
                                                      activeColor:
                                                          AppColor.mainColor,
                                                      value: 2,
                                                      groupValue: methodPayment,
                                                      onChanged: (value) {
                                                        if (statusTicket != 0) {
                                                          _appSnackbar
                                                              .buildSnackbar(
                                                                  context,
                                                                  "The ticket was finished!");
                                                          return;
                                                        }

                                                        if (widget.ticket
                                                                .statusPayment ==
                                                            '1') {
                                                          _appSnackbar
                                                              .buildSnackbar(
                                                                  context,
                                                                  "The ticket is paid. Can\'t update!");
                                                          return;
                                                        }
                                                        setState(() {
                                                          methodPayment =
                                                              value!;
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
                                                                  EdgeInsets
                                                                      .all(2),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green
                                                                      .shade400,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: const Text(
                                                                  'Pay',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto bold',
                                                                      fontSize:
                                                                          16,
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
                              Container(
                                  padding: EdgeInsets.only(top: 8),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status Payment',
                                        style: TextStyle(
                                            fontFamily: 'Roboto bold',
                                            fontSize: 18,
                                            color: Colors.grey),
                                      ),
                                      Container(
                                        // padding:
                                        //     EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.mainColor)),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Radio(
                                                        activeColor:
                                                            Colors.redAccent,
                                                        value: 0,
                                                        groupValue:
                                                            statusPayment,
                                                        onChanged: (value) {
                                                          if (statusTicket !=
                                                              0) {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    "The ticket was finished!");
                                                            return;
                                                          }

                                                          if (widget.ticket
                                                                  .statusPayment ==
                                                              '1') {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    "The ticket is paid. Can\'t update!");
                                                            return;
                                                          }
                                                          setState(() {
                                                            statusPayment =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        'Unpaid',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto bold',
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .mainColor),
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
                                                      activeColor:
                                                          Colors.greenAccent,
                                                      value: 1,
                                                      groupValue: statusPayment,
                                                      onChanged: (value) {
                                                        if (statusTicket != 0) {
                                                          _appSnackbar
                                                              .buildSnackbar(
                                                                  context,
                                                                  "The ticket was finished!");
                                                          return;
                                                        }

                                                        setState(() {
                                                          statusPayment =
                                                              value!;
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
                                                              'Paid',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto bold',
                                                                  fontSize: 16,
                                                                  color: AppColor
                                                                      .mainColor),
                                                            ),
                                                          ]),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 8),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Status Ticket',
                                      //   style: TextStyle(
                                      //       fontFamily: 'Roboto bold',
                                      //       fontSize: 18,
                                      //       color: Colors.grey),
                                      // ),
                                      // Container(
                                      //   // padding:
                                      //   //     EdgeInsets.only(top: 5, bottom: 5),
                                      //   width: double.infinity,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(4)),
                                      //       border: Border.all(
                                      //           width: 2,
                                      //           color: AppColor.mainColor)),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     children: [
                                      //       Expanded(
                                      //           flex: 1,
                                      //           child: Container(
                                      //             width: double.infinity,
                                      //             child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .center,
                                      //               children: [
                                      //                 Radio(
                                      //                   activeColor:
                                      //                       Colors.yellow,
                                      //                   value: 0,
                                      //                   groupValue:
                                      //                       statusTicket,
                                      //                   onChanged: (value) {
                                      //                     setState(() {
                                      //                       statusTicket =
                                      //                           value!;
                                      //                     });
                                      //                   },
                                      //                 ),
                                      //                 Text(
                                      //                   'Upcomming',
                                      //                   style: TextStyle(
                                      //                       fontFamily:
                                      //                           'Roboto bold',
                                      //                       fontSize: 16,
                                      //                       color: AppColor
                                      //                           .mainColor),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           )),
                                      //       Expanded(
                                      //           flex: 1,
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.center,
                                      //             children: [
                                      //               Radio(
                                      //                 activeColor:
                                      //                     Colors.greenAccent,
                                      //                 value: 1,
                                      //                 groupValue: statusTicket,
                                      //                 onChanged: (value) {
                                      //                   setState(() {
                                      //                     statusTicket = value!;
                                      //                   });
                                      //                 },
                                      //               ),
                                      //               Container(
                                      //                 child: Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .center,
                                      //                     children: [
                                      //                       Text(
                                      //                         'Completed',
                                      //                         style: TextStyle(
                                      //                             fontFamily:
                                      //                                 'Roboto bold',
                                      //                             fontSize: 16,
                                      //                             color: AppColor
                                      //                                 .mainColor),
                                      //                       ),
                                      //                     ]),
                                      //               )
                                      //             ],
                                      //           )),
                                      //       Expanded(
                                      //           flex: 1,
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.center,
                                      //             children: [
                                      //               Radio(
                                      //                 activeColor:
                                      //                     Colors.redAccent,
                                      //                 value: 2,
                                      //                 groupValue: statusTicket,
                                      //                 onChanged: (value) {
                                      //                   setState(() {
                                      //                     statusTicket = value!;
                                      //                   });
                                      //                 },
                                      //               ),
                                      //               Container(
                                      //                 child: Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .center,
                                      //                     children: [
                                      //                       Text(
                                      //                         'Cancel',
                                      //                         style: TextStyle(
                                      //                             fontFamily:
                                      //                                 'Roboto bold',
                                      //                             fontSize: 16,
                                      //                             color: AppColor
                                      //                                 .mainColor),
                                      //                       ),
                                      //                     ]),
                                      //               )
                                      //             ],
                                      //           )),
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                  onPressed: () async {
                                                    if (_selectedSeatEditingController
                                                        .text.isEmpty) {
                                                      _appSnackbar.buildSnackbar(
                                                          context,
                                                          'Booked seats is empty!');
                                                      return;
                                                    }

                                                    Ticket changedTicket = Ticket(
                                                        keyTicket: widget
                                                            .ticket.idTicket,
                                                        idAccount: widget
                                                            .ticket.idAccount,
                                                        idTransition: widget
                                                            .bookedRoute
                                                            .keyRoute,
                                                        priceTotal:
                                                            _selectedSeatEditingController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? _totalPricesEditingController
                                                                    .text
                                                                : widget.ticket
                                                                    .prices,
                                                        methodPayment:
                                                            methodPayment
                                                                .toString(),
                                                        statusPayment:
                                                            statusPayment
                                                                .toString(),
                                                        statusTicket:
                                                            statusTicket
                                                                .toString());

                                                    final _appCircleprogressbar =
                                                        AppCircleprogressbar();
                                                    _appCircleprogressbar
                                                        .buildCirclerprogessbar(
                                                            context);

                                                    final isUploadTicket =
                                                        await InsertData()
                                                            .insertTicket(
                                                                changedTicket);

                                                    Navigator.of(context).pop();

                                                    if (isUploadTicket) {
                                                      try {
                                                        if (_selectedSeatEditingController
                                                            .text.isNotEmpty) {
                                                          await _removeController
                                                              .removeSelectedSeats(
                                                                  widget
                                                                      .detailBookedTicket);

                                                          // selectedSeats.forEach(
                                                          //     (element) async {
                                                          //   print(element);
                                                          //   DetailTicket
                                                          //       detailTicket =
                                                          //       DetailTicket(
                                                          //           idTicket: widget
                                                          //               .ticket
                                                          //               .idTicket,
                                                          //           numberSeat:
                                                          //               element);
                                                          //   //final isUploadDetail =
                                                          //   await InsertData()
                                                          //       .insertDetailTicket(
                                                          //           detailTicket);
                                                          // });

                                                          for (var element
                                                              in selectedSeats) {
                                                            DetailTicket
                                                                detailTicket =
                                                                DetailTicket(
                                                                    idTicket: widget
                                                                        .ticket
                                                                        .idTicket,
                                                                    numberSeat:
                                                                        element);
                                                            //final isUploadDetail =
                                                            await InsertData()
                                                                .insertDetailTicket(
                                                                    detailTicket);
                                                          }
                                                        }

                                                        _appSnackbar
                                                            .buildSnackbar(
                                                                context,
                                                                'Successfully!');

                                                        selectedSeats.clear();

                                                        Get.offAll(
                                                            ScaffoldWithNavigationRail(
                                                                selectedIndex:
                                                                    4));
                                                      } catch (e) {
                                                        _appSnackbar
                                                            .buildSnackbar(
                                                                context,
                                                                'Fail!');
                                                      }
                                                    } else {
                                                      _appSnackbar
                                                          .buildSnackbar(
                                                              context, 'Fail!');
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent,
                                                          foregroundColor:
                                                              Colors.white),
                                                  icon: Icon(Icons.save),
                                                  label: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto bold',
                                                      fontSize: 18,
                                                    ),
                                                  )),
                                              // const SizedBox(
                                              //   width: 10,
                                              // ),
                                              // ElevatedButton.icon(
                                              //     onPressed: () async {
                                              //       bool shouldVerify =
                                              //           await _cupertinoDialog
                                              //               .createCupertinoDialog(
                                              //                   AppColor
                                              //                       .mainColor,
                                              //                   'Delete',
                                              //                   'Delete this ticket?',
                                              //                   context);

                                              //       if (shouldVerify) {
                                              //         try {
                                              //           final _appCircleprogressbar =
                                              //               AppCircleprogressbar();
                                              //           _appCircleprogressbar
                                              //               .buildCirclerprogessbar(
                                              //                   context);

                                              //           await _removeController
                                              //               .removeSelectedSeats(
                                              //                   widget
                                              //                       .detailBookedTicket);
                                              //           final isRemove =
                                              //               await _removeController
                                              //                   .removeATicket(
                                              //                       widget
                                              //                           .ticket
                                              //                           .idTicket);
                                              //           Navigator.of(context)
                                              //               .pop();

                                              //           if (isRemove) {
                                              //             _appSnackbar
                                              //                 .buildSnackbar(
                                              //                     context,
                                              //                     'Delete Successfully!');

                                              //             Get.offAll(
                                              //                 ScaffoldWithNavigationRail(
                                              //                     selectedIndex:
                                              //                         4));
                                              //           } else {
                                              //             _appSnackbar
                                              //                 .buildSnackbar(
                                              //                     context,
                                              //                     'Delete fail!');
                                              //           }
                                              //         } catch (e) {
                                              //           _appSnackbar
                                              //               .buildSnackbar(
                                              //                   context,
                                              //                   'Delete fail!');
                                              //         }
                                              //       }
                                              //     },
                                              //     style:
                                              //         ElevatedButton.styleFrom(
                                              //             backgroundColor:
                                              //                 Colors.redAccent,
                                              //             foregroundColor:
                                              //                 Colors.white),
                                              //     icon:
                                              //         const Icon(Icons.delete),
                                              //     label: const Text(
                                              //       'Delete',
                                              //       style: TextStyle(
                                              //         fontFamily: 'Roboto bold',
                                              //         fontSize: 18,
                                              //       ),
                                              //     )),
                                            ]),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ))
                      ],
                    )))
          ])),
    ));
  }
}
