import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:flutter/material.dart';

Widget commonListtile(
    {BuildContext? Context,
    Function()? ontap,
    bool? trailingIcon = true,
    bool? subtitle = false,
    Widget? subTitleWidget,
    bool? border = false,
    String? textSubtitle,
    required Icon? leadingIcon,
    @required String? title,
    // String? subtitles,
    Color? leadingContainerColor,
    Widget? trailingWidget}) {
  return Column(
    children: [
      ListTile(
          leading: leadingIcon ??
              const Icon(
                Icons.water_drop_sharp,
                color: AppColor.greyColor,
              ),
          title: Text(
            "$title",
            style: AppTextStyle.regularTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColor.blackColor.withOpacity(0.6)),
          ),
          subtitle: subtitle == true ? Text("$textSubtitle") : subTitleWidget,
          trailing: trailingIcon == true
              ? const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColor.greyColor,
                  size: 18,
                )
              : trailingWidget),
    ],
  );
}
