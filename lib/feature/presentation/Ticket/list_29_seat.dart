import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/edit_ticket.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item_widget.dart';
import 'package:booking_transition_admin/untils/colors.dart';

import 'package:flutter/material.dart';

import '../../../../advance_icons.dart';

class List29Seats extends StatefulWidget {
  final Function(List<String>) onSeatsSelected;

  List29Seats({super.key, required this.onSeatsSelected});

  @override
  State<StatefulWidget> createState() {
    return StateList29Seats();
  }
}

class StateList29Seats extends State<List29Seats> {
  static List<String> selectedindex = [];
  static late List<SeatItem> bookedSeat;
  static List<String> selectedSeatOfTicket = [];
  static late int statusTicket;
  final _appSnackbar = AppSnackbar();

  @override
  void initState() {
    print('selected: ');
    for (var seat in seats) {
      //seat.color = AppColor.mainColor;
      for (var booked in bookedSeat) {
        if (seat.index.toString() == booked.index) {
          seat.color = Colors.red;
        }
      }

      for (var selected in selectedSeatOfTicket) {
        print(selected);
        if (seat.index.toString() == selected) {
          seat.color = Colors.greenAccent;
        }
      }
    }
    super.initState();
  }

  static List<SeatItem> seats = [
    SeatItem(index: '1A'),
    SeatItem(index: '2A'),
    SeatItem(index: '3A'),
    SeatItem(index: '4A'),
    SeatItem(index: '5A'),
    SeatItem(index: '6A'),
    SeatItem(index: '7A'),
    SeatItem(index: '1B'),
    SeatItem(index: '2B'),
    SeatItem(index: '3B'),
    SeatItem(index: '4B'),
    SeatItem(index: '5B'),
    SeatItem(index: '6B'),
    SeatItem(index: '7B'),
    SeatItem(index: '1C'),
    SeatItem(index: '2C'),
    SeatItem(index: '3C'),
    SeatItem(index: '4C'),
    SeatItem(index: '5C'),
    SeatItem(index: '6C'),
    SeatItem(index: '7C'),
    SeatItem(index: '1D'),
    SeatItem(index: '2D'),
    SeatItem(index: '3D'),
    SeatItem(index: '4D'),
    SeatItem(index: '5D'),
    SeatItem(index: '6D'),
    SeatItem(index: '7D'),
  ];

  Color seatIconColor = Colors.black;

  void selectedSeat(int i) {
    if (statusTicket != 0) {
      _appSnackbar.buildSnackbar(context, "The ticket was finished!");
      return;
    }
    setState(() {
      if (seats[i].color == AppColor.mainColor) {
        seats[i].color = Colors.greenAccent;
        selectedindex.add(seats[i].index.toString());
        //StateChooseSeat.selectedindex.add(seats[i].index.toString());
      } else {
        seats[i].color = AppColor.mainColor;
        selectedindex.remove(seats[i].index.toString());
        //StateChooseSeat.selectedindex.remove(seats[i].index.toString());
      }
    });

    widget.onSeatsSelected(selectedindex);
  }

  @override
  Widget build(BuildContext context) {
    bookedSeat = bookedSeat
        .where((element) => !selectedSeatOfTicket.contains(element.index))
        .toList();
    for (var seat in seats) {
      //seat.color = AppColor.mainColor;
      for (var booked in bookedSeat) {
        if (seat.index.toString() == booked.index) {
          seat.color = Colors.red;
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.mainColor, width: 2)),
      width: double.infinity,
      height: 225,
      //height: ,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_drop_up,
                color: Colors.grey,
                size: 35,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 35,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Icon(
                        AdvanceIcons.steeringwheel,
                        size: 40,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '1',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'C',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Bold',
                                      color: Colors.grey,
                                      fontSize: 20),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      selectedSeat(14);
                                    },
                                    child: SeatItemWidget(
                                      item: seats[14],
                                    )),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text(
                              'D',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(21);
                                },
                                child: SeatItemWidget(
                                  item: seats[21],
                                )),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '1',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'A',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Bold',
                                      color: Colors.grey,
                                      fontSize: 20),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      selectedSeat(0);
                                    },
                                    child: SeatItemWidget(
                                      item: seats[0],
                                    )),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text(
                              'B',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(7);
                                },
                                child: SeatItemWidget(
                                  item: seats[7],
                                )),
                          ],
                        )),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: Icon(
                    //     Icons.event_seat_rounded,
                    //     size: 40,
                    //     color: AppColor.mainColor,
                    //   ),
                    // ),
                    const Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(1);
                                },
                                child: SeatItemWidget(
                                  item: seats[1],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(8);
                            },
                            child: SeatItemWidget(
                              item: seats[8],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(15);
                                },
                                child: SeatItemWidget(
                                  item: seats[15],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(22);
                            },
                            child: SeatItemWidget(
                              item: seats[22],
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '3',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(2);
                                },
                                child: SeatItemWidget(
                                  item: seats[2],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(9);
                            },
                            child: SeatItemWidget(
                              item: seats[9],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '3',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(16);
                                },
                                child: SeatItemWidget(
                                  item: seats[16],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(23);
                            },
                            child: SeatItemWidget(
                              item: seats[23],
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '4',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(3);
                                },
                                child: SeatItemWidget(
                                  item: seats[3],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(10);
                            },
                            child: SeatItemWidget(
                              item: seats[10],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '4',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(17);
                                },
                                child: SeatItemWidget(
                                  item: seats[17],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(24);
                            },
                            child: SeatItemWidget(
                              item: seats[24],
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '5',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(4);
                                },
                                child: SeatItemWidget(
                                  item: seats[4],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(11);
                            },
                            child: SeatItemWidget(
                              item: seats[11],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '5',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(18);
                                },
                                child: SeatItemWidget(
                                  item: seats[18],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(25);
                            },
                            child: SeatItemWidget(
                              item: seats[25],
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '6',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(5);
                                },
                                child: SeatItemWidget(
                                  item: seats[5],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(12);
                            },
                            child: SeatItemWidget(
                              item: seats[12],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '6',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(19);
                                },
                                child: SeatItemWidget(
                                  item: seats[19],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(26);
                            },
                            child: SeatItemWidget(
                              item: seats[26],
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '7',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(6);
                                },
                                child: SeatItemWidget(
                                  item: seats[6],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(13);
                            },
                            child: SeatItemWidget(
                              item: seats[13],
                            ))),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.event_seat_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text(
                              '7',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  color: Colors.grey,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  selectedSeat(20);
                                },
                                child: SeatItemWidget(
                                  item: seats[20],
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              selectedSeat(27);
                            },
                            child: SeatItemWidget(
                              item: seats[27],
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
