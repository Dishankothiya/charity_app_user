import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:flutter/material.dart';

Widget savedButton(
    {BuildContext? buildContext,
    Function()? onTap,
    required String? title,
    Color? buttonColor,
    double? topPadding,
    double? bottamPadding,
    double? leftPadding,
    double? rightPadding,
    double? height,
    double? width}) {
  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding ?? 16,
        right: rightPadding ?? 16,
        top: topPadding ?? 16,
        bottom: bottamPadding ?? 16),
    child: Container(
      height: height ?? 50,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          color: buttonColor ?? AppColor.appColor,
          borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(
        "$title",
        style:
            AppTextStyle.regularTextStyle.copyWith(color: AppColor.whiteColor),
      ),
    ),
  );
}
