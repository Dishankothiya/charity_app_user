import 'package:charity_donation/BottomBar/bottomBar.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class successDonation extends StatefulWidget {
  const successDonation({super.key});

  @override
  State<successDonation> createState() => _successDonationState();
}

class _successDonationState extends State<successDonation> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   child: Container(
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //         color: AppColor.whiteColor,
                    //         borderRadius: BorderRadius.circular(10)),
                    //     alignment: Alignment.center,
                    //     child: const Icon(
                    //       Icons.arrow_back_ios_new_outlined,
                    //       color: AppColor.greenColor,
                    //     ),
                    //   ),
                    // ),
                    Text(
                      "Donation",
                      style: AppTextStyle.mediumTextStyle.copyWith(),
                    ),
                  ],
                ),

                Lottie.asset(ImagePath.thankyouAnimation, height: 400),

                Text(
                  "Thanks for donating",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                  child: Text(
                    "No one has ever become poor by giving...",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.mediumTextStyle.copyWith(
                        color: AppColor.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                // SizedBox(
                //   height: 30,
                // ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => bottomBarPage()),
                        (Route<dynamic> route) => route is bottomBarPage);
                  },
                  child: savedButton(
                    title: "Make Another donation",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
