import 'package:booking_transition_admin/feature/presentation/Ticket/list_16_seats.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';

class CrudTicket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateCrudTicket();
  }
}

class StateCrudTicket extends State<CrudTicket> {
  static List<String> selectedSeats = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: AppColor.mainColor,
        title: const Text(
          'Go back',
          style: TextStyle(fontFamily: 'Roboto bold', fontSize: 20),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Edit Ticket - ID:',
                  style: TextStyle(
                      fontFamily: 'Roboto bold',
                      color: AppColor.mainColor,
                      fontSize: 25),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                  child: Column(
                    children: [
                      List16Seats(
                        onSeatsSelected: (selectedIndex) {
                          setState(() {
                            selectedSeats = selectedIndex;
                          });
                        },
                      )
                    ],
                  ),
                )),
                Expanded(child: Column()),
              ]),
            ))
          ],
        ),
      ),
    ));
  }
}
