import 'package:charity_donation/BottomBar/HomeScreen/PaymentMethod/paymentmethodscreen.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/DonateAmountController/donateAmountController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class donateAmount extends StatefulWidget {
  final String id;
  const donateAmount({super.key, required this.id});

  @override
  State<donateAmount> createState() => _donateAmountState();
}

class _donateAmountState extends State<donateAmount> {
  // DonateAmountController donateAmountController = DonateAmountController();
  // HomeScreenController homeScreenController = HomeScreenController();

  // Widget amountButton({
  //   required String text,
  //   required int index,
  // }) {
  //   return InkWell(
  //       splashColor: Colors.cyanAccent,
  //       onTap: () {
  //         setState(() {
  //           donateAmountController.selectedValueIndex = index;
  //           print(selectedValueIndex);
  //           print(index);
  //         });
  //       },
  //       child: Container(
  //         height: 60,
  //         width: 100,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(5),
  //             color: AppColor.whiteColor,
  //             border: index == donateAmountController.selectedValueIndex
  //                 ? Border.all(color: AppColor.greenColor, width: 2)
  //                 : null,
  //             boxShadow: [
  //               BoxShadow(
  //                   color: AppColor.greyColor.withOpacity(0.4), blurRadius: 2)
  //             ]),
  //         alignment: Alignment.center,
  //         child: Text(
  //           "$text",
  //           style: AppTextStyle.regularTextStyle
  //               .copyWith(fontWeight: FontWeight.w500),
  //         ),
  //       ));
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   donateAmountController.prize;
  // }
  DonateAmountController donateAmountController = DonateAmountController();
  final formkey = GlobalKey<FormState>();
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
  //           // donateAmountController.setShowtextfiled(true);
  //           setState(() {
  //             donateAmountController.showtextfiled.value =
  //                 !donateAmountController.showtextfiled.value;
  //             donateAmountController.highlight.value =
  //                 !donateAmountController.highlight.value;
  //           });

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
  //                   ? donateAmountController.highlight.value == true
  //                       ? Border.all(color: AppColor.greenColor, width: 2)
  //                       : null
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      bottomNavigationBar: InkWell(
          onTap: () {
            if (formkey.currentState!.validate()) {
              // if (donateAmountController.amount == null) {
              //   Text("Please fill the anount");
              // }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => paymentAmountScreen(
                  id: widget.id,
                  amount: donateAmountController.amount.text,
                ),
              ));
            }
          },
          child: savedButton(title: "Next")),
      body: Form(
        key: formkey,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("CharityData")
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.appColor,
                  ),
                );
              }
              return Padding(
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
                      height: MediaQuery.of(context).size.height / 5.5,
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data!["ImageURL"]),
                              fit: BoxFit.cover)),
                      // child: Stack(
                      //   children: [
                      //     Positioned(
                      //         right: 20,
                      //         top: 10,
                      //         child: CircleAvatar(
                      //             backgroundColor: AppColor.whiteColor,
                      //             radius: 18,
                      //             child: Obx(() => InkWell(
                      //                 onTap: () {
                      //                   // setState(() {
                      //                   donateAmountController.save.value =
                      //                       !donateAmountController.save.value;
                      //                   // });
                      //                 },
                      //                 child: donateAmountController.save.value ==
                      //                         true
                      //                     ? const Icon(
                      //                         Icons.bookmark,
                      //                         color: AppColor.greenColor,
                      //                       )
                      //                     : const Icon(
                      //                         Icons.bookmark_border,
                      //                         color: AppColor.greenColor,
                      //                       ))))),
                      //   ],
                      // ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 8,
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.greyColor.withOpacity(0.4),
                                blurRadius: 5)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${snapshot.data!["CharityName"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.regularTextStyle.copyWith(

                                  // overflow: TextOverflow.ellipsis,
                                  color: AppColor.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Campaign by: ",
                                    style: AppTextStyle.mediumTextStyle
                                        .copyWith(
                                            color: AppColor.greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                const Icon(
                                  Icons.gpp_good,
                                  color: AppColor.greenColor,
                                  size: 18,
                                ),
                                Container(
                                  width: 150,
                                  // color: AppColor.appColor,
                                  child: Text("${snapshot.data!["OwnerName"]}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.mediumTextStyle
                                          .copyWith(
                                              color: AppColor.greyColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // donateAmountController.showCommonButoon.value
                    //     ? Container(
                    //         height: 150,
                    //         color: AppColor.transparentColor,
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 amountButton(text: "100", index: 1),
                    //                 amountButton(
                    //                   text: "500",
                    //                   index: 2,
                    //                 ),
                    //                 amountButton(
                    //                   text: "1000",
                    //                   index: 3,
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 amountButton(
                    //                   text: "2000",
                    //                   index: 4,
                    //                 ),
                    //                 amountButton(
                    //                   text: "5000",
                    //                   index: 5,
                    //                 ),
                    //                 amountButton(
                    //                   text: "10000",
                    //                   index: 6,
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 10),
                        child: Text(
                          "Enter Amount",
                          style: AppTextStyle.mediumTextStyle.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        )),
                    InkWell(
                      onTap: () {
                        // setState(() {
                        //   donateAmountController.showCommonButoon.value =
                        //       !donateAmountController.showCommonButoon.value;
                        // });
                      },
                      child: Material(
                          shadowColor: AppColor.backgroudColor.withOpacity(0.4),
                          elevation: 9,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            cursorErrorColor: AppColor.redColor,
                            style: AppTextStyle.regularTextStyle.copyWith(
                                color: AppColor.greenColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                            controller: donateAmountController.amount,
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                Icons.currency_rupee_outlined,
                                size: 25,
                                color: AppColor.greenColor,
                              ),
                              hintText: "  Enter Amount",
                              hintStyle: AppTextStyle.mediumTextStyle.copyWith(
                                  color: AppColor.greyColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            cursorColor: AppColor.greenColor,
                            cursorOpacityAnimates: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the  Amount to donate this charity';
                              }
                              return null;
                            },
                          )
                          // ? TextField(
                          //     onTap: () {},
                          //     keyboardType: TextInputType.number,
                          //     decoration: InputDecoration(
                          //         enabledBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(10),
                          //             borderSide: const BorderSide(
                          //                 color: AppColor.whiteColor)),
                          //         focusedBorder: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(10),
                          //             borderSide: const BorderSide(
                          //                 color: AppColor.whiteColor)),
                          //         border: const OutlineInputBorder(),
                          //         filled: true,
                          //         fillColor: AppColor.whiteColor,
                          //         hintText: "Enter Amount",
                          //         hintStyle: AppTextStyle.mediumTextStyle
                          //             .copyWith(
                          //                 color: AppColor.greyColor
                          //                     .withOpacity(0.4),
                          //                 fontWeight: FontWeight.w400)),
                          //   )
                          ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
