import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';

class AppCircleprogressbar {
  void buildCirclerprogessbar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.mainColor,
            ),
          );
        });
  }
}
