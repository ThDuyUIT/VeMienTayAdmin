import 'package:flutter/material.dart';

class TableSummary extends StatelessWidget {
  late String title;
  late String value;

  TableSummary({super.key, required this.title, required this.value});

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
                Text(title, style: const TextStyle(fontSize: 18)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 20, fontFamily: 'Roboto bold')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
