import 'package:ehr/Dashboard/Claim/ClaimDashboard.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approved_show.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_First.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_First.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Toure/Tourdiary.dart';
import 'package:flutter/material.dart';

class TravelClaimDashboard extends StatefulWidget {
  const TravelClaimDashboard({super.key});

  @override
  State<TravelClaimDashboard> createState() => _TravelClaimDashboard();
}

class _TravelClaimDashboard extends State<TravelClaimDashboard> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const ClaimDashboard()));

            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Travel Claim",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClaimDashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.card_travel,
                                size: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Travel Claim",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    //  Gpfsavetitle.title = "GPF Request";

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TravelClaimFirst()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Icon(
                                            Icons.emoji_transportation,
                                            size: 32,
                                          )),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Claim Request",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    //  Gpfsavetitle.title = "GPF Status";

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => const WebViewExample()));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TravelClaimStatusfirst()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Icon(
                                            Icons.check_box,
                                            size: 32,
                                          )),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TravelClaimapproved()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Icon(
                                            Icons.approval,
                                            size: 32,
                                          )),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Approval",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.only(left: 34),
                        //         child: InkWell(
                        //             onTap: () {
                        //               // Navigator.push(
                        //               //     context,
                        //               //     MaterialPageRoute(
                        //               //         builder: (context) =>
                        //               //             const WebViewExample()));
                        //             },
                        //             child: Column(
                        //               children: [
                        //                 Container(
                        //                   decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10.0),
                        //                     color: Colors.white,
                        //                     boxShadow: [
                        //                       BoxShadow(
                        //                         color: Colors.grey
                        //                             .withOpacity(0.3),
                        //                         spreadRadius: 3,
                        //                         blurRadius: 7,
                        //                         offset: const Offset(0, 3),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   child: const Padding(
                        //                     padding: EdgeInsets.all(8.0),
                        //                     child: Center(
                        //                         // child: Image.asset(
                        //                         //   'assets/images/insurance-claim.png',
                        //                         //   width: 30,
                        //                         // ),
                        //                         child: Icon(
                        //                       Icons.move_down_outlined,
                        //                       size: 32,
                        //                     )),
                        //                   ),
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 5,
                        //                 ),
                        //                 const Text(
                        //                   "Tour Diary",
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.bold),
                        //                 )
                        //               ],
                        //             )
                        //             ),
                           //   ),
                          //  ],
                         // ),
                        //),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
