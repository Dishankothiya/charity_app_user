import 'package:charity_donation/BottomBar/HomeScreen/AboutDonation/aboutDonation.dart';
import 'package:charity_donation/CommonWidget/Shimmer%20widget/shimmerwidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController search = TextEditingController();
  List allData = [];
  List resultList = [];

  //shimmer widget
  bool isloading = false;

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
  void initState() {
    // TODO: implement initState
    loaded();

    search.addListener(onSearchChange);
    super.initState();
  }

  onSearchChange() {
    print(search.text);
    searchResultList();
  }

  //this function to used serchlist

  searchResultList() {
    var showResult = [];
    if (search.text != "") {
      for (var clientSnapshort in allData) {
        var name = clientSnapshort["CharityName"].toString().toLowerCase();
        if (name.contains(search.text.toLowerCase())) {
          showResult.add(clientSnapshort);
        }
      }
    } else {
      showResult = List.from(allData);
    }
    setState(() {
      resultList = showResult;
    });
  }

  //data set on firebase
  getdata() async {
    var data = await FirebaseFirestore.instance
        .collection("CharityData")
        .orderBy("Time", descending: true)
        .get();
    setState(() {
      allData = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    search.removeListener(onSearchChange);
    search.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getdata();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CupertinoSearchTextField(
          controller: search,
        ),
        backgroundColor: AppColor.whiteColor,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => aboutDonation(id: resultList[index].id),
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
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          resultList[index]['ImageURL']),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${resultList[index]['CharityName']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.regularTextStyle.copyWith(
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
                                        "${resultList[index]['OwnerName']}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.greyColor,
                                                fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 1000,
                                    lineHeight: 5.0,
                                    percent: resultList[index]["Percentage"],
                                    barRadius: const Radius.circular(10),
                                    progressColor: AppColor.greenColor,
                                    backgroundColor:
                                        AppColor.greyColor.withOpacity(0.4),
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
                                        "${resultList[index]['Amount']} (${resultList[index]['Percentage']}%)",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                color: AppColor.greenColor,
                                                fontWeight: FontWeight.w500),
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
                                        "${resultList[index]['Date']} ${resultList[index]['MonthName']} ${resultList[index]['Year']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                color: AppColor.greyColor,
                                                fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
