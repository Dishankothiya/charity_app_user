import 'package:charity_donation/CommonWidget/AppbarWidget/appbarWidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../CommonWidget/Shimmer widget/shimmerwidget.dart';

class notificationScreen extends StatefulWidget {
  const notificationScreen({super.key});

  @override
  State<notificationScreen> createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {
  //Shimmer widget
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaded();
  }

  void loaded() async {
    setState(() {
      isloading = true;
    });
    await Future.delayed(Duration(seconds: 3), () {});
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      appBar: commonAppbar(context: context, title: "Notification"),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("adminNotificationdata")
              .orderBy("NotificationTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.appColor,
                ),
              );
            }
            var documents = snapshot.data!.docs;
            return ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              isloading == true
                                  ? CommonShimmer(
                                      context,
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroudColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: AppColor.backgroudColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  documents[index]["ImageURL"]),
                                              fit: BoxFit.cover)),
                                    ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 90,
                                    // color: AppColor.blueColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          // color: AppColor.blueColor,
                                          child: Text(
                                            "${documents[index]["CharityName"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppTextStyle.mediumTextStyle
                                                .copyWith(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // height: 40,
                                          // color: AppColor.blueColor,
                                          child: Text(
                                            // "sdhasdddsui dsdslllllllllllsd dsaihdu dw idsds dwhdsasdlkdald dksadasdhsoadwd kwdhshdshdhdksaljaa",
                                            "${documents[index]["AdminNotification"]}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: AppColor.greyColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     isloading == true
                                        //         ? CommonShimmer(
                                        //             context,
                                        //             CircleAvatar(
                                        //               radius: 15,
                                        //               backgroundColor: AppColor
                                        //                   .backgroudColor,
                                        //             ))
                                        //         : CircleAvatar(
                                        //             radius: 15,
                                        //             backgroundColor:
                                        //                 AppColor.whiteColor,
                                        //             backgroundImage:
                                        //                 NetworkImage(documents[
                                        //                         index]
                                        //                     ["CharityImage"]),
                                        //           ),
                                        //     SizedBox(
                                        //       width: 8,
                                        //     ),
                                        //     Container(
                                        //       width: 180,
                                        //       // color: AppColor.blueColor,
                                        //       child: Text(
                                        //           "${documents[index]["CharityName"]}",
                                        //           overflow:
                                        //               TextOverflow.ellipsis,
                                        //           maxLines: 1,
                                        //           style: AppTextStyle
                                        //               .mediumTextStyle
                                        //               .copyWith(
                                        //                   color: AppColor
                                        //                       .blackColor
                                        //                       .withOpacity(0.4),
                                        //                   fontSize: 14,
                                        //                   fontWeight:
                                        //                       FontWeight.w500)),
                                        //     ),
                                        //   ],
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 100,
                                              // color: AppColor.appColor,
                                              child: Text(
                                                "${documents[index]["NotificationDay"]} ${documents[index]["NotificationMonth"]} ${documents[index]["NotificationYear"]}",
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greyColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }),
    );
  }
}
