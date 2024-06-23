import 'dart:convert';

import 'package:charity_donation/BottomBar/bottomBar.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:charity_donation/Config/notificationservices.dart';
import 'package:charity_donation/Controller/SingupController/singupController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../CommonWidget/ListTileWidget/listtileWidget.dart';
import '../CommonWidget/TextFiledWidget/textfiledWidget.dart';
import '../loginScreen/loginScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final formKey = GlobalKey<FormState>();
  SinginController signinController = SinginController();
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  Future<void> sendNotification(String title, String body) async {
    // FCM endpoint
    final String serverKey =
        'AAAA666dvBA:APA91bGUzr1ydcYK1avmvqQearGLgO9w4dc24YTQlZrYW5sATcXHrGhSyf7f5fEHAKMTBhbuXbIV8AkdqWCEvJhjH6O9kZQmaHxZUf3wmAlc3PZgCxdCDb8tlIay8cCsJrvHlkP-ukR-';
    final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    // Notification body
    final Map<String, dynamic> notificationData = {
      'notification': {'title': title, 'body': body},
      'priority': 'high',
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
    };

    // Convert tokens to FCM payload
    final Map<String, dynamic> fcmPayload = {
      'to': '/topics/all_users',
      'notification': {'title': title, 'body': body},
    };

    // Send POST request to FCM endpoint
    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey', // Add your server key here
      },
      body: jsonEncode(fcmPayload),
    );

    // Handle response
    if (response.statusCode == 200) {
      print('Notification sent successfully');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('successfull'),
      //     duration: Duration(
      //         seconds:
      //             3), // Set the duration for how long the SnackBar will be displayed
      //   ),
      // );
    } else {
      print('Failed to send notification. Error: ${response.statusCode}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Faile'),
      //     duration: Duration(
      //         seconds:
      //             3), // Set the duration for how long the SnackBar will be displayed
      //   ),
      // );
    }
  }

  Future<void> signIn() async {
    signinController.setLoading(true);
    DateTime now = DateTime.now();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signinController.email.text,
        password: signinController.password.text,
      );
      String? deviceToken = await _pushNotificationService.getDeviceToken();
      if (userCredential.user != null) {
        print('User signed in: ${userCredential.user?.email}');
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "name": signinController.name.text,
          "email": signinController.email.text,
          "password": signinController.password.text,
          "profilePicture": "",
          "userToken": deviceToken,
          "time": now
        }).then((value) => Navigator.of(context).pushAndRemoveUntil(
                CupertinoModalPopupRoute(
                    builder: (context) => const bottomBarPage()),
                (Route<dynamic> route) => false));
        sendNotification("'${signinController.name.text}' is new charity User",
            "${signinController.email.text}");
        signinController.setLoading(true);
      }
    } catch (e) {
      print('Error during sign-in: $e');
      signinController.setLoading(false);
      showModalBottomSheet(
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(
          //         top: Radius.circular(12))),
          enableDrag: false,
          // constraints: BoxConstraints(maxHeight: 750),
          isScrollControlled: true,
          backgroundColor: AppColor.transparentColor,
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 5,
              // color: AppColors.whiteColor,
              decoration: const BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  commonListtile(
                      leadingIcon: const Icon(
                        Icons.close,
                        color: AppColor.redColor,
                      ),
                      title:
                          "The email address is already in use by another account.",
                      trailingIcon: false),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: savedButton(
                            height: 40,
                            width: 100,
                            title: "OK",
                            buttonColor: AppColor.blueColor),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
      signinController.setLoading(false);
      // SnackBar(content: Text('$e'));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     // backgroundColor: AppColor.whiteColor,
      //     content: Text(
      //       'The email address is already in use by another account.',
      //       style:
      //           AppTextStyle.mediumTextStyle.copyWith(color: AppColor.redColor),
      //     ),
      //     action: SnackBarAction(
      //       label: 'Undo',
      //       onPressed: () {
      //         // Perform some action when the "Undo" button is pressed
      //         // (You can customize this according to your needs)
      //         print('Undo action!');
      //       },
      //     ),
      //   ),
      // );
    }
  }

  void signInWithGoogle() async {
    signinController.setGoogleLoading(true);
    final GoogleSignIn googleSignIn = GoogleSignIn();
    DateTime now = DateTime.now();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential authcredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(authcredential);
      String? deviceToken = await _pushNotificationService.getDeviceToken();
      if (credential.user != null) {
        print("Sucseess ${credential.user}");
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "name": FirebaseAuth.instance.currentUser!.displayName.toString(),
          "email": FirebaseAuth.instance.currentUser!.email.toString(),
          "profilePicture": "",
          "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
          "userToken": deviceToken,
          "time": now
        }).then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const bottomBarPage(),
              ),
              (route) => false);
        });
        sendNotification(
            "${FirebaseAuth.instance.currentUser!.displayName.toString()}",
            "'${FirebaseAuth.instance.currentUser!.email.toString()}' is new charity User");
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoModalPopupRoute(
              builder: (context) => const bottomBarPage(),
            ),
            (route) => false);
      }
      signinController.setGoogleLoading(false);
    } catch (error) {
      signinController.setGoogleLoading(false);
      print("Error during Google sign-in: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: AppColor.blackColor),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Lottie.asset(
              ImagePath.signupAnimation,
              height: 200,
            ),
            textView(
              labelText: "Name",
              hintText: "name",
              controller: signinController.name,
              needValidation: true,
            ),
            textView(
                labelText: "Email",
                hintText: "email",
                controller: signinController.email,
                needValidation: true,
                isEmailValidator: true),
            Obx(() {
              return textView(
                labelText: "Password",
                hintText: "password",
                obscureText:
                    signinController.isshowpassword.value ? false : true,
                controller: signinController.password,
                needValidation: true,
                isPasswordValidator: true,
                suffix: InkWell(
                  onTap: () {
                    signinController.isshowpassword.value =
                        !signinController.isshowpassword.value;
                  },
                  child: signinController.isshowpassword.value
                      ? const Icon(Icons.no_encryption_gmailerrorred_sharp)
                      : const Icon(Icons.remove_red_eye),
                ),
              );
            }),
            const SizedBox(
              height: 8,
            ),
            ListTile(
              leading: Obx(() {
                return Checkbox(
                  activeColor: AppColor.blueColor,
                  side: const BorderSide(
                    color: AppColor.blueColor,
                  ),
                  value: signinController.onchange.value,
                  onChanged: (value) {
                    signinController.onchange.value =
                        !signinController.onchange.value;
                  },
                );
              }),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "By signing up, you agree to the",
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: AppColor.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of Service and Privacy Policy",
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: AppColor.blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            InkWell(onTap: () {
              if (formKey.currentState!.validate()) {
                if (signinController.onchange.value == true) {
                  signIn();
                } else {
                  showModalBottomSheet(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(
                      //         top: Radius.circular(12))),
                      enableDrag: false,
                      // constraints: BoxConstraints(maxHeight: 750),
                      isScrollControlled: true,
                      backgroundColor: AppColor.transparentColor,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 5,
                          // color: AppColors.whiteColor,
                          decoration: const BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              commonListtile(
                                  leadingIcon: const Icon(
                                    Icons.check_box,
                                    size: 30,
                                    color: AppColor.blueColor,
                                  ),
                                  title:
                                      "Please fill the Terms of Service and Privacy Policy",
                                  trailingIcon: false),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: savedButton(
                                        height: 40,
                                        width: 100,
                                        title: "OK",
                                        buttonColor: AppColor.blueColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
              }
            }, child: Obx(
              () {
                return Center(
                    child: signinController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.appColor,
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        : savedButton(
                            title: "Sign Up",
                            buttonColor: AppColor.appColor,
                          ));
              },
            )),

            const SizedBox(height: 10),
            Text(
              "Or With",
              style: AppTextStyle.smallTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            // this row will be google auth
            InkWell(
              onTap: () {
                signInWithGoogle();
                print(
                    "pppppppppppppppppppp${FirebaseAuth.instance.currentUser}");
              },
              child: Obx(
                () {
                  return Center(
                      child: signinController.isGoogleLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.appColor,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImagePath.searchIcon,
                                  scale: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Sign Up with Google",
                                  style: AppTextStyle.regularTextStyle,
                                )
                              ],
                            ));
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoModalPopupRoute(
                    builder: (context) => const loginPage(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: AppTextStyle.smallTextStyle.copyWith(
                              color: AppColor.blackColor,
                              fontSize: 15,
                            )),
                        TextSpan(
                            text: "Login",
                            style: AppTextStyle.smallTextStyle.copyWith(
                                color: AppColor.blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
