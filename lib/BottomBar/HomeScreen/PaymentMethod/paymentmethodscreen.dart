import 'dart:convert';

import 'package:charity_donation/BottomBar/HomeScreen/AboutDonation/aboutDonation.dart';
import 'package:charity_donation/BottomBar/HomeScreen/SuccessDonation/successDonation.dart';
import 'package:charity_donation/BottomBar/HomeScreen/homeScreen.dart';
import 'package:charity_donation/CommonWidget/ListTileWidget/listtileWidget.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/PaymentMethodController/paymentMethodController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class paymentAmountScreen extends StatefulWidget {
  final String id;
  final String amount;

  const paymentAmountScreen(
      {super.key, required this.id, required this.amount});

  @override
  State<paymentAmountScreen> createState() => _paymentAmountScreenState();
}

class _paymentAmountScreenState extends State<paymentAmountScreen> {
  PaymentMethodController paymentMethodController = PaymentMethodController();

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

//razorpay function
  late Razorpay razonpay;

  Map<String, dynamic>? charityData;
  void fetchData() async {
    try {
      // Fetch the document snapshot asynchronously
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("CharityData")
          .doc(widget.id)
          .get();

      // Extract the data from the snapshot
      setState(() {
        charityData = snapshot.data();

        print(charityData);
      });
    } catch (error) {
      // Handle any errors
      print("Failed to fetch data: $error");
    }
  }

  Map<String, dynamic>? userData;
  void userDataFetch() async {
    try {
      // Fetch the document snapshot asynchronously
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Extract the data from the snapshot
      setState(() {
        userData = snapshot.data();

        print(userData);
      });
    } catch (error) {
      // Handle any errors
      print("Failed to fetch data: $error");
    }
  }

  handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => successDonation()),
        (Route<dynamic> route) => route is aboutDonation);
    // date time
    DateTime now = DateTime.now();
    String monthName = DateFormat('MMM').format(now);
    int day = now.day;
    int year = now.year;

    //update on damin transection data
    int adminvalue = int.parse("${charityData!["Amount"]}");
    int uservalue = int.parse(widget.amount);
    int updateAmount = adminvalue + uservalue;
    String updatevalue = updateAmount.toString();
    int totalamount = int.parse("${charityData!["TotalAmount"]}");

    // //convert the amount in percentage
    double convertRupees() {
      int conertamount = int.parse(updatevalue);
      int convertotalAmount = int.parse("${charityData!["TotalAmount"]}");
      double totalPercentage = conertamount * 100 / convertotalAmount;
      print("totalPersentage$totalPercentage");

      int intTotalPercentage = totalPercentage.toInt();

      double convertPercentage = intTotalPercentage / 100.0;

      return convertPercentage;
    }

    FirebaseFirestore.instance
        .collection("CharityData")
        .doc(widget.id)
        .collection("userTransection")
        .doc()
        .set({
      "CharityName": "${charityData!["CharityName"]}",
      "CharityImage": "${charityData!["ImageURL"]}",
      "CharityOwnerName": "${charityData!["OwnerName"]}",
      "Amount": "${widget.amount}",
      "amountTime": now,
      "amountDay": day,
      "amountMounth": monthName,
      "amountYear": year,
      "userName": "${userData!["name"]}",
      "userImage": "${userData!["profilePicture"]}"
    });
    FirebaseFirestore.instance.collection("allUserTransection").doc().set({
      "CharityName": "${charityData!["CharityName"]}",
      "CharityImage": "${charityData!["ImageURL"]}",
      "CharityOwnerName": "${charityData!["OwnerName"]}",
      "Amount": "${widget.amount}",
      "amountTime": now,
      "amountDay": day,
      "amountMounth": monthName,
      "amountYear": year,
      "userName": "${userData!["name"]}",
      "userImage": "${userData!["profilePicture"]}"
    });

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("perticulerUserData")
        .doc()
        .set({
      "Amount": widget.amount,
      "Charityname": "${charityData!["CharityName"]}",
      "Charityimage": "${charityData!["ImageURL"]}",
      "Ownername": "${charityData!["OwnerName"]}",
      "Time": now,
      "Day": day,
      "Mounth": monthName,
      "Year": year,
    });

    FirebaseFirestore.instance
        .collection("admin1")
        .doc(charityData!["currentUSerId"])
        .collection("CharityData")
        .doc(widget.id)
        .update({
      "Amount": updatevalue,
      "Percentage": convertRupees(),
    });
    FirebaseFirestore.instance.collection("CharityData").doc(widget.id).update({
      "Amount": updatevalue,
      "Percentage": convertRupees(),
    });
    sendNotification("${charityData!["CharityName"]}",
        "'${userData!["name"]}' gives Rs.${widget.amount} on '${charityData!["CharityName"]}'");
    Fluttertoast.showToast(
        msg: "Payment Successful" + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

//fail collection
  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Fail" + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => homeScreen()),
        (Route<dynamic> route) => route is aboutDonation);
  }

//external collection
  void handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => successDonation()),
        (Route<dynamic> route) => route is aboutDonation);
    DateTime now = DateTime.now();
    String monthName = DateFormat('MMM').format(now);
    int day = now.day;
    int year = now.year;
    //update on damin transection data
    int adminvalue = int.parse("${charityData!["Amount"]}");
    int uservalue = int.parse(widget.amount);
    int updateAmount = adminvalue + uservalue;
    String updatevalue = updateAmount.toString();
    int totalamount = int.parse("${charityData!["TotalAmount"]}");

    // //convert the amount in percentage
    double convertRupees() {
      int conertamount = int.parse(updatevalue);
      int convertotalAmount = int.parse("${charityData!["TotalAmount"]}");
      double totalPercentage = conertamount * 100 / convertotalAmount;
      print("totalPersentage$totalPercentage");

      int intTotalPercentage = totalPercentage.toInt();

      double convertPercentage = intTotalPercentage / 100.0;

      return convertPercentage;
    }

    FirebaseFirestore.instance
        .collection("CharityData")
        .doc(widget.id)
        .collection("userTransection")
        .doc()
        .set({
      "CharityName": "${charityData!["CharityName"]}",
      "CharityImage": "${charityData!["ImageURL"]}",
      "CharityOwnerName": "${charityData!["OwnerName"]}",
      "Amount": "${widget.amount}",
      "amountTime": now,
      "amountDay": day,
      "amountMounth": monthName,
      "amountYear": year,
      "userName": "${userData!["name"]}",
      "userImage": "${userData!["profilePicture"]}"
    });
    FirebaseFirestore.instance.collection("allUserTransection").doc().set({
      "CharityName": "${charityData!["CharityName"]}",
      "CharityImage": "${charityData!["ImageURL"]}",
      "CharityOwnerName": "${charityData!["OwnerName"]}",
      "Amount": "${widget.amount}",
      "amountTime": now,
      "amountDay": day,
      "amountMounth": monthName,
      "amountYear": year,
      "userName": "${userData!["name"]}",
      "userImage": "${userData!["profilePicture"]}"
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("perticulerUserData")
        .doc()
        .set({
      "Amount": widget.amount,
      "Charityname": "${charityData!["CharityName"]}",
      "Charityimage": "${charityData!["ImageURL"]}",
      "Ownername": "${charityData!["OwnerName"]}",
      "Time": now,
      "Day": day,
      "Mounth": monthName,
      "Year": year,
    });
    FirebaseFirestore.instance
        .collection("admin1")
        .doc(charityData!["currentUSerId"])
        .collection("CharityData")
        .doc(widget.id)
        .update({
      "Amount": updatevalue,
      "Percentage": convertRupees(),
    });
    FirebaseFirestore.instance.collection("CharityData").doc(widget.id).update({
      "Amount": updatevalue,
      "Percentage": convertRupees(),
    });
    sendNotification("${charityData!["CharityName"]}",
        "'${userData!["name"]}' gives Rs.${widget.amount} on '${charityData!["CharityName"]}'");
    Fluttertoast.showToast(
        msg: "External Wallet" + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razonpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razonpay = Razorpay();
    razonpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razonpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razonpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    fetchData();
    userDataFetch();
  }

  //user parent and sub colletion data
  Stream<QuerySnapshot> getSubUserTransectionData() {
    // Get a reference to the parent document
    DocumentReference parentDocumentRef = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Return a stream of the subcollection
    return parentDocumentRef
        .collection('transectiondata')
        .orderBy("time", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("CharityData")
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColor.appColor,
                ),
              ),
            );
          }
          var documents = snapshot.data;

          return Scaffold(
              backgroundColor: AppColor.backgroudColor,
              bottomNavigationBar: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return InkWell(
                        onTap: () async {
                          //the set amount in the current user and pertiquler admin id data in firebsefirestore

                          // DateTime now = DateTime.now();
                          // String monthName = DateFormat('MMM').format(now);
                          // int day = now.day;
                          // int year = now.year;

                          //update on damin transection data
                          int adminvalue = int.parse("${documents!["Amount"]}");
                          int uservalue = int.parse(widget.amount);
                          int updateAmount = adminvalue + uservalue;
                          String updatevalue = updateAmount.toString();
                          int totalamount =
                              int.parse("${documents["TotalAmount"]}");

                          // //convert the amount in percentage
                          double convertRupees() {
                            int conertamount = int.parse(updatevalue);
                            int convertotalAmount =
                                int.parse("${documents["TotalAmount"]}");
                            double totalPercentage =
                                conertamount * 100 / convertotalAmount;
                            print("totalPersentage$totalPercentage");

                            int intTotalPercentage = totalPercentage.toInt();

                            double convertPercentage =
                                intTotalPercentage / 100.0;

                            return convertPercentage;
                          }

                          if (updateAmount <= totalamount) {
                            // if (Razorpay.EVENT_EXTERNAL_WALLET == false ||
                            //     Razorpay.EVENT_PAYMENT_SUCCESS == false) {}
                            // print("aaaaaaaaaaaaaaaaaa");
                            // FirebaseFirestore.instance
                            //     .collection("admin")
                            //     .doc(widget.id)
                            //     .update({
                            //   "Amount": updatevalue,
                            //   "Percentage": convertRupees()
                            // });
                            // //user time update
                            // FirebaseFirestore.instance
                            //     .collection("user")
                            //     .doc(FirebaseAuth.instance.currentUser!.uid)
                            //     .update({
                            //   "time": now,
                            // });

                            // //admin collection time update
                            // FirebaseFirestore.instance
                            //     .collection("admin")
                            //     .doc(widget.id)
                            //     .update({
                            //   "updateTime": now,
                            // });

                            // print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
                            // //the set amount in the current user data in firebsefirestore
                            // DocumentReference<Map<String, dynamic>> references =
                            //     FirebaseFirestore.instance
                            //         .collection("user")
                            //         .doc(
                            //             FirebaseAuth.instance.currentUser!.uid);

                            // references.collection('transectionData').doc().set({
                            //   "charityName": "${documents["CharityName"]}",
                            //   "ownerName": "${documents["OwnerName"]}",
                            //   "imageUrl": "${documents["ImageURL"]}",
                            //   "useramount": widget.amount.toString(),
                            //   "time": now.toString(),
                            //   "monthName": monthName.toString(),
                            //   "day": day.toString(),
                            //   "year": year.toString(),
                            //   "totalAmount": 0
                            // });

                            // print(
                            //     "cccccccccccccccccccccccccccccccccccccccccccccccccc");
                            // // the set amount  data in pertiqler admin id in firebase
                            // DocumentReference<Map<String, dynamic>>
                            //     adminReferences = FirebaseFirestore.instance
                            //         .collection("admin")
                            //         .doc(widget.id);

                            // adminReferences
                            //     .collection("userTransectionData")
                            //     .doc()
                            //     .set({
                            //   "charityName": "${documents["CharityName"]}",
                            //   "charityImage": "${documents["ImageURL"]}",
                            //   "ownerName": "${documents["OwnerName"]}",
                            //   "userProfileImage":
                            //       "${snapshot.data!["profilePicture"]}",
                            //   "userTrancetionName": "${snapshot.data!["name"]}",
                            //   "useramount": widget.amount.toString(),
                            //   "time": now.toString(),
                            //   "monthName": monthName.toString(),
                            //   "day": day.toString(),
                            //   "year": year.toString()
                            // });
                            // print(
                            //     "dddddddddddddddddddddddddddddddddddddddddddddddd");

                            // this is open rezorpay app in this devise
                            void openCheakout(amount) async {
                              amount = amount * 100;
                              var options = {
                                'key': 'rzp_test_KltrkZ4pRrtYYG',
                                'amount': amount,
                                'name': '${snapshot.data!['name']}',
                                'prefill': {
                                  'contact': '9724488033',
                                  'email': '${snapshot.data!['email']}'
                                },
                                'external': {
                                  'wallets': ['paytm'],
                                }
                              };
                              try {
                                razonpay.open(options);
                              } catch (e) {
                                debugPrint('something wrong');
                              }
                            }

                            // the give amount to show in rezore pay
                            setState(() {
                              int amount = int.parse(widget.amount);
                              openCheakout(amount);
                            });
                          } else {
                            showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: true,
                                backgroundColor: AppColor.transparentColor,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    decoration: const BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        commonListtile(
                                            leadingIcon: const Icon(
                                              Icons.app_blocking,
                                              size: 30,
                                              color: AppColor.blueColor,
                                            ),
                                            title:
                                                "the amount is higher than the charity want ",
                                            trailingIcon: false),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: savedButton(
                                                  height: 40,
                                                  width: 100,
                                                  title: "OK",
                                                  buttonColor:
                                                      AppColor.blueColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                        },
                        child: savedButton(title: "Pay Now"));
                  }),
              // }),
              body: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: AppColor.greenColor,
                            ),
                          ),
                        ),
                        Text(
                          "Donation",
                          style: AppTextStyle.mediumTextStyle.copyWith(),
                        ),
                        const SizedBox(
                          height: 40,
                          width: 40,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: AppColor.greyColor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${snapshot.data!["ImageURL"]}"),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                  // height: 90,
                                  // color: AppColor.blueColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data!["CharityName"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.regularTextStyle
                                            .copyWith(
                                                color: AppColor.blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Campaign by: ",
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                      color: AppColor.greyColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                          const Icon(
                                            Icons.gpp_good,
                                            color: AppColor.greenColor,
                                            size: 14,
                                          ),
                                          Container(
                                            width: 100,
                                            // color: AppColor.appColor,
                                            child: Text(
                                                "${snapshot.data!["OwnerName"]}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greyColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style: AppTextStyle.mediumTextStyle.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            Spacer(),
                            Icon(
                              Icons.currency_rupee,
                              size: 25,
                              color: AppColor.greenColor,
                            ),
                            Text(
                              "${widget.amount}",
                              style: AppTextStyle.mediumTextStyle.copyWith(
                                  fontSize: 25,
                                  color: AppColor.greenColor,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    ),
                    Lottie.asset(ImagePath.paymentAnimation, height: 400),
                    // const SizedBox(
                    //   height: 18,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: AppColor.whiteColor,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Payment method",
                    //           style: AppTextStyle.regularTextStyle
                    //               .copyWith(fontSize: 16),
                    //         ),
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         radioButton(
                    //             text: "Paypal",
                    //             index: 1,
                    //             image: Image.asset(ImagePath.paypalIcon)),
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         radioButton(
                    //             text: "Debit Card",
                    //             index: 2,
                    //             image:
                    //                 Image.asset(ImagePath.creditCardIcon)),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //         Container(
                    //             decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                     color: AppColor.greyColor
                    //                         .withOpacity(0.4)),
                    //                 borderRadius:
                    //                     BorderRadius.circular(10)),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     "Card Details",
                    //                     style: AppTextStyle.regularTextStyle
                    //                         .copyWith(
                    //                             fontSize: 16,
                    //                             color: AppColor.greyColor),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 13,
                    //                   ),
                    //                   TextFormField(
                    //                     textInputAction:
                    //                         TextInputAction.done,
                    //                     keyboardType: TextInputType.number,
                    //                     decoration: InputDecoration(
                    //                         enabledBorder: OutlineInputBorder(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(
                    //                                     10),
                    //                             borderSide: BorderSide(
                    //                                 color: AppColor.greyColor
                    //                                     .withOpacity(0.4))),
                    //                         focusedBorder: OutlineInputBorder(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(
                    //                                     10),
                    //                             borderSide: const BorderSide(
                    //                                 color: AppColor
                    //                                     .blackColor)),
                    //                         prefixIcon: const Padding(
                    //                             padding:
                    //                                 EdgeInsets.all(8.0),
                    //                             child: Icon(
                    //                               Icons.credit_card,
                    //                               color: AppColor.greyColor,
                    //                             )),
                    //                         suffixIcon: const Padding(
                    //                             padding:
                    //                                 EdgeInsets.all(8.0),
                    //                             child: SizedBox(
                    //                               height: 20,
                    //                               width: 50,
                    //                               child: Image(
                    //                                 image: AssetImage(
                    //                                     ImagePath
                    //                                         .creditCardIcon),
                    //                                 fit: BoxFit.cover,
                    //                               ),
                    //                             )),
                    //                         border:
                    //                             const OutlineInputBorder(),
                    //                         hintText: 'XXXX XXXX XXXX XXXX',
                    //                         labelText: 'Card Number',
                    //                         labelStyle: AppTextStyle
                    //                             .mediumTextStyle
                    //                             .copyWith(
                    //                                 color:
                    //                                     AppColor.greyColor)),
                    //                     maxLength: 16,
                    //                     onChanged: (value) {},
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 13,
                    //                   ),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       SizedBox(
                    //                         width: 130,
                    //                         child: TextFormField(
                    //                           // textInputAction: TextInputAction.done,
                    //                           keyboardType:
                    //                               TextInputType.number,
                    //                           decoration: InputDecoration(
                    //                               enabledBorder: OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           10),
                    //                                   borderSide: BorderSide(
                    //                                       color: AppColor
                    //                                           .greyColor
                    //                                           .withOpacity(
                    //                                               0.4))),
                    //                               focusedBorder: OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           10),
                    //                                   borderSide: const BorderSide(
                    //                                       color: AppColor
                    //                                           .blackColor)),
                    //                               prefixIcon: const Padding(
                    //                                   padding:
                    //                                       EdgeInsets.all(
                    //                                           8.0),
                    //                                   child: Icon(
                    //                                     Icons.date_range,
                    //                                     color: AppColor
                    //                                         .greyColor,
                    //                                   )),
                    //                               border:
                    //                                   const OutlineInputBorder(),
                    //                               hintText: 'MM/YY',
                    //                               labelText: 'Expire',
                    //                               labelStyle: AppTextStyle
                    //                                   .mediumTextStyle
                    //                                   .copyWith(color: AppColor.greyColor)),
                    //                           onChanged: (value) {},
                    //                         ),
                    //                       ),
                    //                       SizedBox(
                    //                         width: 130,
                    //                         child: TextFormField(
                    //                           // textInputAction: TextInputAction.done,
                    //                           keyboardType:
                    //                               TextInputType.number,
                    //                           decoration: InputDecoration(
                    //                               enabledBorder: OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           10),
                    //                                   borderSide: BorderSide(
                    //                                       color: AppColor
                    //                                           .greyColor
                    //                                           .withOpacity(
                    //                                               0.4))),
                    //                               focusedBorder: OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           10),
                    //                                   borderSide: const BorderSide(
                    //                                       color: AppColor
                    //                                           .blackColor)),
                    //                               prefixIcon: const Padding(
                    //                                   padding:
                    //                                       EdgeInsets.all(
                    //                                           8.0),
                    //                                   child: Icon(
                    //                                     Icons
                    //                                         .lock_outline_rounded,
                    //                                     color: AppColor
                    //                                         .greyColor,
                    //                                   )),
                    //                               border:
                    //                                   const OutlineInputBorder(),
                    //                               hintText: 'CVV',
                    //                               labelText: 'CVV',
                    //                               labelStyle: AppTextStyle
                    //                                   .mediumTextStyle
                    //                                   .copyWith(color: AppColor.greyColor)),
                    //                           onChanged: (value) {},
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             )),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ));
        });
  }
}
