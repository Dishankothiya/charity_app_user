import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DonateAmountController extends GetxController {
  TextEditingController amount = TextEditingController();
  RxBool showtextfiled = false.obs;
  void setShowtextfiled(Value) {
    this.showtextfiled = Value;
  }

  RxBool showCommonButoon = false.obs;

  RxBool save = false.obs;
  RxBool highlight = false.obs;
  // int? selectedValueIndex;
  RxInt prize = 0.obs;

  onChange(int value) {
    prize.value = value;
  }

  // onCange(int value) {
  //   selectedValueIndex.value = value;
  // }

  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   selectedValueIndex.value;
  //   super.onClose();
  // }
}
