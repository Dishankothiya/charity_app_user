import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

// class LoginController extends GetxController{
//   TextEditingController loginEmail = TextEditingController();

//   TextEditingController loginpassword = TextEditingController();
// RxBool isshowpassword = false.obs;
//   RxBool isLoding = false.obs;
// }
class LoginController extends GetxController {
  TextEditingController loginEmail = TextEditingController();

  TextEditingController loginpassword = TextEditingController();
  RxBool isshowpassword = false.obs;
  RxBool isLoding = false.obs;
  void isSetLoading(Value) {
    isLoding.value = Value;
  }
}