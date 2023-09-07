import 'package:booking_transition_admin/advance_icons.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item_widget.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';

class List16Seats extends StatefulWidget {
  final Function(List<String>) onSeatsSelected;

  List16Seats({super.key, required this.onSeatsSelected});

  @override
  State<StatefulWidget> createState() {
    return StateList16Seats();
  }
}

class StateList16Seats extends State<List16Seats> {
  static List<String> selectedindex = [];
  static List<SeatItem> bookedSeat = [];
  //static List<String> editedSeat = [];

  static List<SeatItem> seats = [
    SeatItem(index: '1'),
    SeatItem(index: '2'),
    SeatItem(index: '3'),
    SeatItem(index: '4'),
    SeatItem(index: '5'),
    SeatItem(index: '6'),
    SeatItem(index: '7'),
    SeatItem(index: '8'),
    SeatItem(index: '9'),
    SeatItem(index: '10'),
    SeatItem(index: '11'),
    SeatItem(index: '12'),
    SeatItem(index: '13'),
    SeatItem(index: '14'),
    SeatItem(index: '15')
  ];

  Color seatIconColor = Colors.black;

  void selectedSeat(int i) {
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
    for (var seat in seats) {
      //seat.color = AppColor.mainColor;
      for (var booked in bookedSeat) {
        if (seat.index.toString() == booked.index) {
          seat.color = Colors.red;
        }
      }
    }

    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.mainColor, width: 2),
      ),
      width: double.infinity,
      child: Column(
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
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(0);
                      },
                      child: SeatItemWidget(
                        item: seats[0],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(1);
                      },
                      child: SeatItemWidget(
                        item: seats[1],
                      ))),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(2);
                      },
                      child: SeatItemWidget(
                        item: seats[2],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(3);
                      },
                      child: SeatItemWidget(
                        item: seats[3],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(4);
                      },
                      child: SeatItemWidget(
                        item: seats[4],
                      ))),
              const Expanded(
                flex: 1,
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
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(5);
                      },
                      child: SeatItemWidget(
                        item: seats[5],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(6);
                      },
                      child: SeatItemWidget(
                        item: seats[6],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(7);
                      },
                      child: SeatItemWidget(
                        item: seats[7],
                      ))),
              const Expanded(
                flex: 1,
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
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(8);
                      },
                      child: SeatItemWidget(
                        item: seats[8],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(9);
                      },
                      child: SeatItemWidget(
                        item: seats[9],
                      ))),
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
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(11);
                      },
                      child: SeatItemWidget(
                        item: seats[11],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(12);
                      },
                      child: SeatItemWidget(
                        item: seats[12],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(13);
                      },
                      child: SeatItemWidget(
                        item: seats[13],
                      ))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        selectedSeat(14);
                      },
                      child: SeatItemWidget(
                        item: seats[14],
                      ))),
            ],
          ),
        ],
      ),
    );
  }
}
