import 'package:charity_donation/BottomBar/HomeScreen/AboutDonation/aboutDonation.dart';
import 'package:charity_donation/CommonWidget/AppbarWidget/appbarWidget.dart';
import 'package:charity_donation/CommonWidget/Shimmer%20widget/shimmerwidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class trendingScreen extends StatefulWidget {
  const trendingScreen({super.key});

  @override
  State<trendingScreen> createState() => _trendingScreenState();
}

class _trendingScreenState extends State<trendingScreen> {
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
        appBar: commonAppbar(title: "Treanding Charity", context: context),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('CharityData')
                .orderBy("Time", descending: true)
                .limit(5)
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
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var document = documents[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                          style: AppTextStyle.regularTextStyle
                                              .copyWith(
                                                  color: AppColor.blackColor,
                                                  fontWeight: FontWeight.w700,
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
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${document['OwnerName']}",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyle
                                                    .smallTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColor.greyColor,
                                                        fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: LinearPercentIndicator(
                                            animation: true,
                                            animationDuration: 1000,
                                            lineHeight: 5.0,
                                            percent: documents[index]
                                                ["Percentage"],
                                            barRadius:
                                                const Radius.circular(10),
                                            progressColor: AppColor.greenColor,
                                            backgroundColor: AppColor.greyColor
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
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppTextStyle
                                                    .smallTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greenColor,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: AppTextStyle
                                                    .smallTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greyColor,
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
            }));
  }
}
