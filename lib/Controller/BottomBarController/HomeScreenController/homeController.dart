import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeScreenController extends GetxController {
  TextEditingController serch = TextEditingController();

  RxBool saveButton = false.obs;
  void setSaveButton(Value) {
    this.saveButton = Value();
  }
}
