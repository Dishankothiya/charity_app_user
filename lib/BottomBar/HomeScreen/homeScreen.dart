import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charity_donation/BottomBar/HomeScreen/AboutDonation/aboutDonation.dart';
import 'package:charity_donation/BottomBar/HomeScreen/SearchScreen/search.dart';
import 'package:charity_donation/BottomBar/TrendingScreen/trendingScreen.dart';
import 'package:charity_donation/CommonWidget/Shimmer%20widget/shimmerwidget.dart';
import 'package:charity_donation/CommonWidget/TextFiledWidget/textfiledWidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:charity_donation/Controller/BottomBarController/HomeScreenController/homeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  HomeScreenController homeScreenController = HomeScreenController();
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

  String searchItem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroudColor,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              // color: AppColor.blueColor,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        color: AppColor.appColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30))),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("user")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.appColor,
                                  ),
                                );
                              }
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // "${FirebaseFirestore.instance.doc(FirebaseAuth.instance.currentUser!.uid).get()}",
                                        "${snapshot.data!["name"]}",
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                color: AppColor.whiteColor,
                                                fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        "We rise by lifting others",
                                        style: AppTextStyle.regularTextStyle
                                            .copyWith(
                                                color: AppColor.whiteColor,
                                                fontSize: 18),
                                      )
                                    ],
                                  ),
                                  // Spacer(),
                                  InkWell(
                                    onTap: () {},
                                    child: isloading == true
                                        ? CommonShimmer(
                                            context, CircleAvatar(radius: 25))
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: AppColor.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: snapshot.data![
                                                            "profilePicture"] ==
                                                        ""
                                                    ? DecorationImage(
                                                        image: AssetImage(
                                                            ImagePath
                                                                .kidsImage),
                                                        fit: BoxFit.cover)
                                                    : DecorationImage(
                                                        image: NetworkImage(
                                                            "${snapshot.data!["profilePicture"]}"),
                                                        fit: BoxFit.cover)),
                                          ),
                                  )
                                ],
                              );
                            })),
                  ),
                  Positioned(
                      top: 160,
                      left: 8,
                      right: 8,
                      // bottom: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => searchScreen(),
                            ));
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: AppColor.greenColor,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    "Search, Charity Name..",
                                    style: AppTextStyle.regularTextStyle
                                        .copyWith(
                                            color: AppColor.greyColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            searchItem.isNotEmpty
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("admin")
                        .where("CharityName", isEqualTo: searchItem)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.appColor,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              snapshot.data!.docs[index]["CharityName"],
                              style: TextStyle(color: AppColor.blueColor),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending campaigns",
                          style: AppTextStyle.regularTextStyle.copyWith(
                              color: AppColor.blackColor.withBlue(90),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const trendingScreen(),
                            ));
                          },
                          child: Text(
                            "view all",
                            style: AppTextStyle.mediumTextStyle.copyWith(
                                color: AppColor.greenColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("CharityData")
                  .limit(5)
                  .orderBy("Time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                  //  Center(
                  //       child: CircularProgressIndicator(
                  //     color: AppColor.appColor,
                  //   ));
                }
                var documents = snapshot.data!.docs;
                return CarouselSlider.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index, realIndex) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => aboutDonation(
                                id: documents[index].id,
                              ),
                            ));
                          },
                          child: isloading == true
                              ? CommonShimmer(
                                  context,
                                  Container(
                                    height: 150,
                                    color: AppColor.whiteColor,
                                  ))
                              : Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${documents[index]["ImageURL"]}"),
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
                                  //                 // onTap: () {
                                  //                 //   savedScreen(
                                  //                 //       id: documents[index].id);
                                  //                 //   homeScreenController
                                  //                 //           .saveButton.value =
                                  //                 //       !homeScreenController
                                  //                 //           .saveButton.value;
                                  //                 // },
                                  //                 child: homeScreenController
                                  //                             .saveButton.value ==
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
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("${documents[index]["CharityName"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.regularTextStyle
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          width: 150,
                                          child: Text(
                                              "${documents[index]["OwnerName"]}",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                      color: AppColor.greyColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    // const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 5.0,
                                        percent: documents[index]["Percentage"],
                                        barRadius: const Radius.circular(10),
                                        progressColor: AppColor.greenColor,
                                        backgroundColor:
                                            AppColor.greyColor.withOpacity(0.4),
                                      ),
                                    ),
                                    // const Spacer(),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Donation raised",
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: AppColor.greenColor,
                                                  size: 18,
                                                ),
                                                Container(
                                                  width: 120,
                                                  // color: AppColor.appColor,
                                                  child: Text(
                                                    "${documents[index]["Amount"]} (${documents[index]["Percentage"]}%)",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyle
                                                        .regularTextStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .greenColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.watch_later_outlined,
                                          color: AppColor.greyColor,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          width: 80,
                                          // height: 40,
                                          // color: AppColor.backgroudColor,
                                          child: Text(
                                            "${documents[index]['Date']} ${documents[index]['MonthName']} ${documents[index]['Year']}",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    color: AppColor.greyColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    );
                  },
                  options: CarouselOptions(
                    height: 280,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    disableCenter: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.ease,
                    onPageChanged: (index, reason) {},
                  ),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
              child: Text(
                "All Charity Trust",
                style: AppTextStyle.regularTextStyle.copyWith(
                    color: AppColor.blackColor.withBlue(90),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('CharityData')
                    .orderBy("Time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColor.appColor,
                    ));
                  }

                  var documents = snapshot.data!.docs;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var document = documents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  aboutDonation(id: documents[index].id),
                            ));
                          },
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
                                            height: 100,
                                            width: 100,
                                            color: AppColor.backgroudColor,
                                          ))
                                      : Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: AppColor.backgroudColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      document['ImageURL']),
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
                                            Text(
                                              "${document['CharityName']}",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                      color:
                                                          AppColor.blackColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.gpp_good,
                                                  color: AppColor.greenColor,
                                                  size: 14,
                                                ),
                                                Container(
                                                  width: 150,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "${document['OwnerName']}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyle
                                                        .smallTextStyle
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColor
                                                                .greyColor,
                                                            fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: LinearPercentIndicator(
                                                animation: true,
                                                animationDuration: 1000,
                                                lineHeight: 5.0,
                                                percent: documents[index]
                                                    ["Percentage"],
                                                barRadius:
                                                    const Radius.circular(10),
                                                progressColor:
                                                    AppColor.greenColor,
                                                backgroundColor: AppColor
                                                    .greyColor
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: AppColor.greenColor,
                                                  size: 18,
                                                ),
                                                Container(
                                                  width: 90,
                                                  child: Text(
                                                    "${document['Amount']} (${document['Percentage']}%)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: AppTextStyle
                                                        .smallTextStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .greenColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.watch_later_outlined,
                                                  color: AppColor.greyColor,
                                                  size: 14,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: Text(
                                                    "${documents[index]['Date']} ${documents[index]['MonthName']} ${documents[index]['Year']}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: AppTextStyle
                                                        .smallTextStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .greyColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })
          ],
        ));
  }
}

// class Ex extends StatefulWidget {
//   const Ex({super.key});

//   @override
//   State<Ex> createState() => _ExState();
// }

// class _ExState extends State<Ex> {
//   String term = "";
//   TextEditingController name = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(80),
//               child: TextField(
//                 controller: name,
//                 onChanged: (value) {
//                   setState(() {
//                     term = value.trim().toLowerCase();
//                   });
//                 },
//               ),
//             ),
//           ),
//           term.isNotEmpty
//               ? Expanded(
//                   child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection("admin")
//                       .where("CharityName", isEqualTo: term)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: AppColor.appColor,
//                         ),
//                       );
//                     }
//                     return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         return Center(
//                           child: Text(
//                             snapshot.data!.docs[index]["CharityName"],
//                             style: TextStyle(color: AppColor.blueColor),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ))
//               : Text("no data")
//         ],
//       ),
//     );
//   }
// }
