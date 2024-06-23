import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/Config/appTextStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class donationTransactionPage extends StatefulWidget {
  const donationTransactionPage({super.key});

  @override
  State<donationTransactionPage> createState() =>
      _donationTransactionPageState();
}

class _donationTransactionPageState extends State<donationTransactionPage> {
  Stream<QuerySnapshot> getUserDebitTransaction() {
    DocumentReference parentuser = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return parentuser
        .collection("perticulerUserData")
        .orderBy("Time", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      body: StreamBuilder(
          stream: getUserDebitTransaction(),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: AppColor.blackColor,
                        ),
                      ),
                      Text(
                        "Debit Transaction",
                        style: AppTextStyle.mediumTextStyle.copyWith(),
                      ),
                      const SizedBox(
                        height: 40,
                        width: 40,
                      )
                    ],
                  ),
                ),
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
                        height: 80,
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "${documents[index]["Charityimage"]}"),
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
                                          "${documents[index]["Charityname"]}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: AppTextStyle.mediumTextStyle
                                              .copyWith(
                                            fontSize: 18,
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     const CircleAvatar(
                                        //       radius: 12,
                                        //       backgroundImage: AssetImage(
                                        //           ImagePath.childrenCharityImage),
                                        //     ),
                                        //     const SizedBox(
                                        //       width: 5,
                                        //     ),
                                        //     SizedBox(
                                        //       width:
                                        //           MediaQuery.of(context).size.width /
                                        //               2,
                                        //       // color: AppColor.blueColor,
                                        //       child: Text(
                                        //           "Healthy food for the homeless",
                                        //           overflow: TextOverflow.ellipsis,
                                        //           maxLines: 1,
                                        //           style: AppTextStyle.mediumTextStyle
                                        //               .copyWith(
                                        //                   color: AppColor.blackColor
                                        //                       .withOpacity(0.4),
                                        //                   fontSize: 15,
                                        //                   fontWeight:
                                        //                       FontWeight.w500)),
                                        //     ),
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              color: AppColor.redColor,
                                            ),
                                            Text(
                                              "-${documents[index]["Amount"]}",
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                      color: AppColor.redColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Spacer(),
                                            Text(
                                              " ${documents[index]["Day"]} ${documents[index]["Mounth"]} ${documents[index]["Year"]}",
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                      color: AppColor.greyColor
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
                )
              ],
            );
          }),
    );
  }
}
