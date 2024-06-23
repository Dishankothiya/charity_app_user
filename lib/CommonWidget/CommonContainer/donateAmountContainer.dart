// import 'package:charity_donation/Config/appColor.dart';
// import 'package:charity_donation/Config/appTextStyle.dart';
// import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/AboutDonationController/DonateAmountController/donateAmountController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// DonateAmountController donateAmountController = DonateAmountController();
// Widget amountButton({
//   required String text,
//   required int index,
// }) {
//   return InkWell(
//       splashColor: Colors.cyanAccent,
//       onTap: () {
//         // setState(() {
//         donateAmountController.onChange(text);
//         // });
//       },
//       child: Obx(() => Container(
//             height: 60,
//             width: 100,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: AppColor.whiteColor,
//                 border: donateAmountController.prize.value == text
//                     ? Border.all(color: AppColor.greenColor, width: 2)
//                     : null,
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColor.greyColor.withOpacity(0.4), blurRadius: 2)
//                 ]),
//             alignment: Alignment.center,
//             child: Text(
//               "$text",
//               style: AppTextStyle.regularTextStyle
//                   .copyWith(fontWeight: FontWeight.w500),
//             ),
//           )));
// }

// import 'package:charity_donation/Config/appColor.dart';
// import 'package:charity_donation/Config/appTextStyle.dart';
// import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/DonateAmountController/donateAmountController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// DonateAmountController donateAmountController = DonateAmountController();
// Widget amountButton({
//   required String text,
//   required int index,
// }) {
//   return Obx(
//     () => InkWell(
//         splashColor: Colors.cyanAccent,
//         onTap: () {
//           // setState(() {
//           // if (donateAmountController.prize != null) {
//           donateAmountController.onChange(index);

//           // }

//           // });
//         },
//         child: Container(
//           height: 60,
//           width: 100,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: AppColor.whiteColor,
//               border: index == donateAmountController.prize.value
//                   ? Border.all(color: AppColor.greenColor, width: 2)
//                   : null,
//               boxShadow: [
//                 BoxShadow(
//                     color: AppColor.greyColor.withOpacity(0.4), blurRadius: 2)
//               ]),
//           alignment: Alignment.center,
//           child: Text(
//             "$text",
//             style: AppTextStyle.regularTextStyle
//                 .copyWith(fontWeight: FontWeight.w500),
//           ),
//         )),
//   );
// }
