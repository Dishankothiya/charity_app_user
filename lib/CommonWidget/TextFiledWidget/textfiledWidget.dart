import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:flutter/material.dart';

import '../TextFiledValidation/textfiledValidation.dart';

Widget textView({
  @required String? labelText,
  @required String? hintText,
  @required TextEditingController? controller,
  double? topPadding,
  double? bottomPadding,
  double? leftPadding,
  double? rightPadding,
  Widget? suffix,
  bool obscureText = false,
  int maxLine = 1,
  bool needValidation = false,
  bool isEmailValidator = false,
  bool isPasswordValidator = false,
  bool isPhoneNumberValidator = false,
  String? validationMessage,
  TextInputType? textInputType,
  bool isReadOnly = false,
  Function()? onPressed,
  int maxLength = 1000,
  Function(String)? onChange,
  Widget? prefixIcon,
  Color? enabledBorderColor,
  Color? disabledBorderColor,
  Color? focusedBorderColor,
  Color? labelTextColor,
  Color? inputTextColor,
  Color? cursorColor,
  FocusNode? focusNode,
}) {
  return Container(
    padding: EdgeInsets.only(
        left: leftPadding ?? 15,
        right: rightPadding ?? 15,
        top: topPadding ?? 15,
        bottom: bottomPadding ?? 5),
    child: TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLine,
      maxLength: maxLength,
      onChanged: onChange,
      validator: needValidation
          ? (value) => TextFieldValidation.validation(
              value: value ?? "",
              isPasswordValidator: isPasswordValidator,
              message: validationMessage ?? hintText,
              isEmailValidator: isEmailValidator,
              isPhoneNumberValidator: isPhoneNumberValidator)
          : null,
      keyboardType: textInputType ?? TextInputType.text,
      readOnly: isReadOnly,
      onTap: onPressed,
      style: AppTextStyle.regularTextStyle.copyWith(
          fontSize: 16,
          color: inputTextColor ?? AppColor.blackColor,
          fontWeight: FontWeight.normal),
      cursorColor: cursorColor ?? AppColor.blackColor,
      decoration: InputDecoration(
        
          labelText: labelText,
          labelStyle: AppTextStyle.regularTextStyle.copyWith(
              fontSize: 14, color: labelTextColor ?? AppColor.blackColor),
          border: InputBorder.none,
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: enabledBorderColor ?? AppColor.greyColor,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: disabledBorderColor ?? AppColor.greyColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColor.redColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColor.greyColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: focusedBorderColor ?? AppColor.blueColor,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
          prefixIcon: prefixIcon,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: suffix,
          ),
          hintText: hintText,
          hintMaxLines: 1,
          hintStyle: AppTextStyle.regularTextStyle
              .copyWith(fontSize: 16, color: AppColor.greyColor)),
    ),
  );
}