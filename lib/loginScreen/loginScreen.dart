import 'package:charity_donation/BottomBar/bottomBar.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/CommonWidget/TextFiledWidget/textfiledWidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import '../Controller/LoginController/loginController.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final formkey = GlobalKey<FormState>();
  LoginController loginController = LoginController();
  login() async {
    try {
      loginController.isSetLoading(true);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginController.loginEmail.text,
        password: loginController.loginpassword.text,
      );
      if (userCredential.user != null) {
        print('User signed in: ${userCredential.user?.email}');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const bottomBarPage()),
            (Route<dynamic> route) => false);
      }
      loginController.isSetLoading(false);
    } catch (e) {
      print('Error during sign-in: $e');
      loginController.isSetLoading(false);
      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('The email address and password is wrong.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Perform some action when the "Undo" button is pressed
                // (You can customize this according to your needs)
                print('Undo action!');
              },
            ),
          ),
        );
      }
      loginController.isSetLoading(false);
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
            "Login",
            style: TextStyle(color: AppColor.blackColor),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_outlined,
              color: AppColor.blackColor,
            ),
          )),
      body: Form(
        key: formkey,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Lottie.asset(ImagePath.loginAnimation, height: 200),
            textView(
                labelText: "Email",
                hintText: "email",
                controller: loginController.loginEmail,
                needValidation: true,
                isEmailValidator: true),
            Obx(() {
              return textView(
                labelText: "Password",
                hintText: "password",
                obscureText:
                    loginController.isshowpassword.value ? false : true,
                controller: loginController.loginpassword,
                needValidation: true,
                isPasswordValidator: true,
                suffix: InkWell(
                  onTap: () {
                    loginController.isshowpassword.value =
                        !loginController.isshowpassword.value;
                  },
                  child: loginController.isshowpassword.value
                      ? const Icon(Icons.no_encryption_gmailerrorred_sharp)
                      : const Icon(Icons.remove_red_eye),
                ),
              );
            }),
            const SizedBox(
              height: 28,
            ),
            InkWell(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  login();
                }
              },
              child: Obx(() {
                return Center(
                  child: loginController.isLoding.value == false
                      ? savedButton(
                          title: "Login", buttonColor: AppColor.appColor)
                      : const CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: AppColor.blueColor),
                );
              }),
            ),
            const SizedBox(
              height: 28,
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // InkWell(
            //   // onTap: () {
            //   //   Navigator.of(context).push(CupertinoPageRoute(
            //   //     builder: (context) => const ForgotPassword(),
            //   //   ));
            //   // },
            //   child: Text(
            //     "Forgot Password?",
            //     textAlign: TextAlign.center,
            //     style: AppTextStyle.mediumTextStyle
            //         .copyWith(color: AppColor.blueColor),
            //   ),
            // ),
            const SizedBox(
              height: 28,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Don't have an account yet? ",
                            style: AppTextStyle.smallTextStyle.copyWith(
                                color: AppColor.blackColor, fontSize: 15)),
                        TextSpan(
                            text: "Sign Up",
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
            )
          ],
        ),
      ),
    );
  }
}
