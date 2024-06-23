import 'package:charity_donation/Config/appColor.dart';
import 'package:flutter/material.dart';

void showIndiCator(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
              child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.whiteColor),
            child: const Center(
                child: CircularProgressIndicator(color: AppColor.blueColor)),
          )),
        );
      });
}