import 'package:charity_donation/BottomBar/HomeScreen/AboutDonation/PeopleDonaterScreen/peopleDonater.dart';
import 'package:charity_donation/BottomBar/HomeScreen/DonateAmount/donateAmount.dart';
import 'package:charity_donation/CommonWidget/SavedButton/savedButton.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/homeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class aboutDonation extends StatefulWidget {
  final String id;
  const aboutDonation({super.key, required this.id});

  @override
  State<aboutDonation> createState() => _aboutDonationState();
}

class _aboutDonationState extends State<aboutDonation> {
  HomeScreenController homeScreenController = HomeScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => donateAmount(id: widget.id),
            ));
          },
          child: savedButton(
            title: "Donate now",
          )),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("CharityData")
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColor.appColor,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
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
                      Spacer(),
                      Container(
                        width: 200,
                        // color: AppColor.appColor,
                        child: Text(
                          "${snapshot.data!["CharityName"]}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.regularTextStyle,
                        ),
                      ),
                      Spacer(),
                      // Container(
                      //   height: 40,
                      //   width: 40,
                      //   decoration: BoxDecoration(
                      //       color: AppColor.whiteColor,
                      //       borderRadius: BorderRadius.circular(10)),
                      //   child: const Icon(
                      //     Icons.share,
                      //     color: AppColor.greenColor,
                      //   ),
                      // )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3.6,
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10),
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
                    //                   homeScreenController.saveButton.value =
                    //                       !homeScreenController
                    //                           .saveButton.value;
                    //                   // });
                    //                 },
                    //                 child:
                    //                     homeScreenController.saveButton.value ==
                    //                             true
                    //                         ? const Icon(
                    //                             Icons.bookmark,
                    //                             color: AppColor.greenColor,
                    //                           )
                    //                         : const Icon(
                    //                             Icons.bookmark_border,
                    //                             color: AppColor.greenColor,
                    //                           ))))),
                    //   ],
                    // ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    // height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Raised",
                                style: AppTextStyle.mediumTextStyle
                                    .copyWith(fontSize: 14),
                              ),
                              Text(
                                "Target",
                                style: AppTextStyle.mediumTextStyle
                                    .copyWith(fontSize: 14),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 5.0,
                              percent: snapshot.data!["Percentage"],
                              barRadius: Radius.circular(10),
                              progressColor: AppColor.greenColor,
                              backgroundColor:
                                  AppColor.greyColor.withOpacity(0.4),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.currency_rupee_outlined,
                                color: AppColor.greenColor,
                              ),
                              Container(
                                width: 120,
                                child: Text(
                                  "${snapshot.data!["Amount"]} (${snapshot.data!["Percentage"]}%)",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                      color: AppColor.greenColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Spacer(),
                              const Icon(
                                Icons.currency_rupee_outlined,
                                color: AppColor.greyColor,
                              ),
                              Text(
                                "${snapshot.data!["TotalAmount"]}",
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.regularTextStyle.copyWith(
                                    color: AppColor.greyColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data!["CharityName"]}",
                                      style: AppTextStyle.regularTextStyle
                                          .copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColor.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Campaign by: ",
                                            style: AppTextStyle.mediumTextStyle
                                                .copyWith(
                                                    color: AppColor.greyColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                        const Icon(
                                          Icons.gpp_good,
                                          color: AppColor.greenColor,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 135,
                                          child: Text(
                                              "${snapshot.data!["OwnerName"]}",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                      color:
                                                          AppColor.greenColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Obx(() => InkWell(
                              //     onTap: () {
                              //       setState(() {
                              //         homeScreenController.saveButton.value =
                              //             !homeScreenController
                              //                 .saveButton.value;
                              //       });
                              //     },
                              //     child:
                              //         homeScreenController.saveButton.value ==
                              //                 true
                              //             ? const Icon(
                              //                 Icons.bookmark,
                              //                 color: AppColor.greenColor,
                              //               )
                              //             : const Icon(
                              //                 Icons.bookmark_border,
                              //                 color: AppColor.greenColor,
                              //               )))
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.backgroudColor,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data!["ImageURL"]),
                                        fit: BoxFit.fill)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${snapshot.data!["AboutCharity"]}",
                            textAlign: TextAlign.left,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.mediumTextStyle.copyWith(
                              color: AppColor.greyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 34,
                                width: 60,
                                // color: AppColor.blueColor,
                                child: Stack(children: const [
                                  Positioned(
                                      left: 0,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColor.blackColor,
                                        backgroundImage:
                                            AssetImage(ImagePath.profileImage),
                                      )),
                                  Positioned(
                                      // bottom: 10,
                                      left: 20,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColor.greenColor,
                                        backgroundImage:
                                            AssetImage(ImagePath.kidsImage),
                                      )),
                                  // Positioned(
                                  //     left: 40,
                                  //     child: CircleAvatar(
                                  //       radius: 16,
                                  //       backgroundColor: AppColor.blackColor,
                                  //       backgroundImage:
                                  //           AssetImage(ImagePath.profileImage),
                                  //     )),
                                  // Positioned(
                                  //     // bottom: 10,
                                  //     left: 60,
                                  //     child: CircleAvatar(
                                  //       radius: 16,
                                  //       backgroundColor: AppColor.greenColor,
                                  //       backgroundImage:
                                  //           AssetImage(ImagePath.profileImage),
                                  //     )),
                                  // Positioned(
                                  //     // bottom: 10,
                                  //     left: 80,
                                  //     child: CircleAvatar(
                                  //       radius: 16,
                                  //       backgroundColor: AppColor.greenColor,
                                  //       backgroundImage:
                                  //           AssetImage(ImagePath.profileImage),
                                  //     )),
                                ]),
                              ),
                              Text(
                                "Donated Name",
                                style: AppTextStyle.mediumTextStyle.copyWith(
                                    color: AppColor.blackColor, fontSize: 16),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => peopleDonaterScreen(
                                        id: widget.id,
                                        image: snapshot.data!["ImageURL"],
                                        title: snapshot.data!["CharityName"]),
                                  ));
                                },
                                child: Text(
                                  "View All",
                                  style: AppTextStyle.mediumTextStyle
                                      .copyWith(color: AppColor.greenColor),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
