import 'package:charity_donation/CommonWidget/Shimmer%20widget/shimmerwidget.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:charity_donation/Config/imagePath.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class peopleDonaterScreen extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  const peopleDonaterScreen(
      {super.key, required this.id, required this.title, required this.image});

  @override
  State<peopleDonaterScreen> createState() => _peopleDonaterScreenState();
}

class _peopleDonaterScreenState extends State<peopleDonaterScreen> {
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

  Stream<QuerySnapshot> getAdminSubcollectionStream() {
    // Get a reference to the parent document
    DocumentReference parentDocumentRef =
        FirebaseFirestore.instance.collection('CharityData').doc(widget.id);

    // Return a stream of the subcollection
    return parentDocumentRef
        .collection('userTransection')
        .orderBy("amountTime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroudColor,
        body:

            // var usertrancetiondata = snapshot.data!.docs;
            ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
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
                  Spacer(),
                  Text(
                    "Donation",
                    style: AppTextStyle.mediumTextStyle.copyWith(),
                  ),
                  Spacer()
                ],
              ),
            ),
            Container(
              height: 200,
              color: AppColor.appColor,
              child: Image.network(
                "${widget.image}",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.title}",
              textAlign: TextAlign.center,
              style: AppTextStyle.regularTextStyle.copyWith(
                  color: AppColor.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: getAdminSubcollectionStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.appColor,
                      ),
                    );
                  }
                  var documents = snapshot.data!.docs;

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Container(
                          height: 90,
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
                                          width: 70,
                                          color: AppColor.backgroudColor,
                                        ))
                                    : Container(
                                        // height: 0,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroudColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: documents[index]
                                                        ["userImage"] ==
                                                    ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                        ImagePath.kidsImage),
                                                    fit: BoxFit.cover)
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        documents[index]
                                                            ["userImage"]),
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.7,
                                            // color: AppColor.blueColor,
                                            child: Text(
                                              "${documents[index]["userName"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.currency_rupee_outlined,
                                                color: AppColor.greenColor,
                                              ),
                                              Text(
                                                "+${documents[index]["Amount"]}",
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greenColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Spacer(),
                                              Text(
                                                "${documents[index]["amountDay"]} ${documents[index]["amountMounth"]} ${documents[index]["amountYear"]}",
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color: AppColor
                                                            .greyColor
                                                            .withOpacity(0.9),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                              ),
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
                  );
                })
          ],
        ));
  }
}
