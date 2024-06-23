import 'package:charity_donation/BottomBar/bottomBar.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../CommonWidget/SavedButton/savedButton.dart';
import '../SingupScreen/signupScreen.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              color: AppColor.blackColor,
              child: const Image(
                image: AssetImage(ImagePath.charityImage),
                fit: BoxFit.cover,
              ),
            ),
            Stack(
              children: [
                // Positioned(
                //     top: 0,
                //     child: Container(
                //       child: Image(
                //         image: AssetImage(ImagePath.charityImage),
                //         fit: BoxFit.cover,
                //       ),
                //     )),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 35, left: 50, right: 50),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Alone we can do so little together we can do so much",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.regularTextStyle.copyWith(
                                  color: AppColor.blackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No act of kidness, no matter how small is ever wasted..",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.mediumTextStyle.copyWith(
                                  fontSize: 15,
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    Navigator.of(context)
                                        .push(CupertinoModalPopupRoute(
                                      builder: (context) =>
                                          const bottomBarPage(),
                                    ));
                                  } else {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                      builder: (context) => const signUpPage(),
                                    ));
                                  }
                                },
                                child: savedButton(
                                  title: "Get started",
                                  leftPadding: 0,
                                  rightPadding: 0,
                                ))
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
