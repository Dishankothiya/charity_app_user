import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';

import 'package:flutter/material.dart';


PreferredSizeWidget commonAppbar({
  BuildContext? buildContext,
  @required BuildContext? context,
  required String? title,
  Color? backgroudColor,
}) {
  return AppBar(
    backgroundColor: backgroudColor ?? AppColor.transparentColor,
    automaticallyImplyLeading: false,
    // leading: Padding(
    //   padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5),
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: AppColor.whiteColor,
    //         borderRadius: BorderRadius.circular(10)),
    //     child: Icon(
    //       Icons.arrow_back,
    //       color: AppColor.blackColor,
    //     ),
    //   ),
    // ),
    elevation: 0,
    centerTitle: true,
    title: Text(
      "$title",
      style: AppTextStyle.regularTextStyle
          .copyWith(color: AppColor.blackColor, fontWeight: FontWeight.w500),
    ),
  );
}
