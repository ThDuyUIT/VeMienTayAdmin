import 'package:booking_transition_admin/main.dart';
import 'package:flutter/material.dart';

class TableSummary extends StatefulWidget {
  late String title;
  late String value;

  TableSummary({super.key, required this.title, required this.value});
  @override
  State<StatefulWidget> createState() {
    return StateTableSummary();
  }
}

class StateTableSummary extends State<TableSummary> {
  late double sizeTitle;
  late double sizeValue;
  late double widthScreen;

  @override
  void initState() {
    setState(() {
      widthScreen = MyApp.widthScreen;
      if (widthScreen >= 1200) {
        sizeTitle = 16;
        sizeValue = 18;
      } else if (widthScreen >= 900) {
        sizeTitle = 14;
        sizeValue = 16;
      } else {
        sizeTitle = 12;
        sizeValue = 14;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(fontSize: sizeTitle)),
                Text(widget.value,
                    style: TextStyle(
                        fontSize: sizeValue, fontFamily: 'Roboto bold')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
