// import 'package:charity_donation/CommonWidget/ListTileWidget/listtileWidget.dart';
// import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
// import 'package:charity_donation/Config/appColor.dart';
// import 'package:flutter/material.dart';

// Future commonBottomSheet( BuildContext context,  Icon icon, String title,) {
//  return showModalBottomSheet(
//       enableDrag: false,
//       isScrollControlled: true,
//       backgroundColor: AppColor.transparentColor,
//       context: context,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height / 5,
//           decoration: const BoxDecoration(
//               color: AppColor.whiteColor,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               commonListtile(
//                   leadingIcon: const Icon(
//                     Icons.app_blocking,
//                     size: 30,
//                     color: AppColor.blueColor,
//                   ),
//                   title: "$title",
//                   trailingIcon: false),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: savedButton(
//                         height: 40,
//                         width: 100,
//                         title: "OK",
//                         buttonColor: AppColor.blueColor),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       });
// }
