import 'package:ehr/Dashboard/Claim/Local_Convency_Dashboard.dart';
import 'package:ehr/Dashboard/Claim/policyclaim/staffpolicy.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:flutter/material.dart';

class ClaimDashboard extends StatefulWidget {
  const ClaimDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _ClaimDashboard();
}

class _ClaimDashboard extends State<ClaimDashboard> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));

            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Claim",
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
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
                                Icons.policy,
                                size: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Claim",
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
                              // InkWell(
                              //     onTap: () {
                              //       //  Gpfsavetitle.title = "GPF Request";

                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   const Staffpolicy()));

                              //       // Navigator.push(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) =>
                              //       //             localStatusss()));
                              //     },
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0),
                              //             color: Colors.white,
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 color:
                              //                     Colors.grey.withOpacity(0.3),
                              //                 spreadRadius: 3,
                              //                 blurRadius: 7,
                              //                 offset: const Offset(0, 3),
                              //               ),
                              //             ],
                              //           ),
                              //           child: const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Center(
                              //                 child: Icon(
                              //               Icons.people_alt_rounded,
                              //               size: 32,
                              //             )),
                              //           ),
                              //         ),
                              //         const SizedBox(
                              //           height: 8,
                              //         ),
                              //         const Text(
                              //           "GPF Policy",
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //         Text(
                              //           "Claim",
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ],
                              //     )),

                              // InkWell(
                              //     onTap: () {

                              //       //  Gpfsavetitle.title = "GPF Status";

                              //       // Navigator.push(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) => const WebViewExample()));

                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   const LocalConvencyClaim()));
                              //     },
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0),
                              //             color: Colors.white,
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 color:
                              //                     Colors.grey.withOpacity(0.3),
                              //                 spreadRadius: 3,
                              //                 blurRadius: 7,
                              //                 offset: const Offset(0, 3),
                              //               ),
                              //             ],
                              //           ),
                              //           child: const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Center(
                              //                 child: Icon(
                              //               Icons.wheelchair_pickup,
                              //               size: 32,
                              //             )),
                              //           ),
                              //         ),
                              //         const SizedBox(
                              //           height: 8,
                              //         ),
                              //         const Text(
                              //           "Medical Claim ",
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //         Text("" ,style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ],
                              //     )),

                              // InkWell(
                              //     onTap: () {
                              //       // Navigator.push(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) =>
                              //       //             LocalApproval()));
                              //     },
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0),
                              //             color: Colors.white,
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 color:
                              //                     Colors.grey.withOpacity(0.3),
                              //                 spreadRadius: 3,
                              //                 blurRadius: 7,
                              //                 offset: const Offset(0, 3),
                              //               ),
                              //             ],
                              //           ),
                              //           child: const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Center(
                              //                 child: Icon(
                              //               Icons.whatshot_sharp,
                              //               size: 32,
                              //             )),
                              //           ),
                              //         ),
                              //         const SizedBox(
                              //           height: 8,
                              //         ),
                              //         Text(
                              //           "Nutrition",
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //         Text("Claim" ,style: TextStyle(
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ],
                              //     )),

                              InkWell(
                                  onTap: () {
                                    //  Gpfsavetitle.title = "GPF Request";

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TravelClaimDashboard()));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             localStatusss()));
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
                                        "Travel Claim",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10.0),
                //         color: Colors.white,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.3),
                //             spreadRadius: 3,
                //             blurRadius: 7,
                //             offset: const Offset(0, 3),
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         children: [
                //           const Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Row(
                //               children: [
                //                 Icon(
                //                   Icons.card_travel,
                //                   size: 32,
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 Text(
                //                   "Claim",
                //                   style: TextStyle(
                //                       fontSize: 16, fontWeight: FontWeight.bold),
                //                 )
                //               ],
                //             ),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 InkWell(
                //                     onTap: () {
                //                       //  Gpfsavetitle.title = "GPF Request";

                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   const TravelClaimDashboard()));

                //                       // Navigator.push(
                //                       //     context,
                //                       //     MaterialPageRoute(
                //                       //         builder: (context) =>
                //                       //             localStatusss()));
                //                     },
                //                     child: Column(
                //                       children: [
                //                         Container(
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(10.0),
                //                             color: Colors.white,
                //                             boxShadow: [
                //                               BoxShadow(
                //                                 color:
                //                                     Colors.grey.withOpacity(0.3),
                //                                 spreadRadius: 3,
                //                                 blurRadius: 7,
                //                                 offset: const Offset(0, 3),
                //                               ),
                //                             ],
                //                           ),
                //                           child: const Padding(
                //                             padding: EdgeInsets.all(8.0),
                //                             child: Center(
                //                                 child: Icon(
                //                               Icons.emoji_transportation,
                //                               size: 32,
                //                             )),
                //                           ),
                //                         ),
                //                         const SizedBox(
                //                           height: 5,
                //                         ),
                //                         const Text(
                //                           "Travel Claim",
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold),
                //                         )
                //                       ],
                //                     )),
                //                 InkWell(
                //                     onTap: () {
                //                       //  Gpfsavetitle.title = "GPF Status";

                //                       // Navigator.push(
                //                       //     context,
                //                       //     MaterialPageRoute(
                //                       //         builder: (context) => const WebViewExample()));
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   const LocalConvencyClaim()));
                //                     },
                //                     child: Column(
                //                       children: [
                //                         Container(
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(10.0),
                //                             color: Colors.white,
                //                             boxShadow: [
                //                               BoxShadow(
                //                                 color:
                //                                     Colors.grey.withOpacity(0.3),
                //                                 spreadRadius: 3,
                //                                 blurRadius: 7,
                //                                 offset: const Offset(0, 3),
                //                               ),
                //                             ],
                //                           ),
                //                           child: const Padding(
                //                             padding: EdgeInsets.all(8.0),
                //                             child: Center(
                //                                 child: Icon(
                //                               Icons.forum,
                //                               size: 32,
                //                             )),
                //                           ),
                //                         ),
                //                         const SizedBox(
                //                           height: 5,
                //                         ),
                //                         const Text(
                //                           "Local Conveyance ",
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold),
                //                         )
                //                       ],
                //                     )),

                //                 // InkWell(
                //                 //     onTap: () {
                //                 //       Navigator.push(
                //                 //           context,
                //                 //           MaterialPageRoute(
                //                 //               builder: (context) =>
                //                 //                   LocalApproval()));
                //                 //     },
                //                 //     child: Column(
                //                 //       children: [
                //                 //         Container(
                //                 //           decoration: BoxDecoration(
                //                 //             borderRadius:
                //                 //                 BorderRadius.circular(10.0),
                //                 //             color: Colors.white,
                //                 //             boxShadow: [
                //                 //               BoxShadow(
                //                 //                 color:
                //                 //                     Colors.grey.withOpacity(0.3),
                //                 //                 spreadRadius: 3,
                //                 //                 blurRadius: 7,
                //                 //                 offset: const Offset(0, 3),
                //                 //               ),
                //                 //             ],
                //                 //           ),
                //                 //           child: const Padding(
                //                 //             padding: EdgeInsets.all(8.0),
                //                 //             child: Center(
                //                 //                 child: Icon(
                //                 //               Icons.approval,
                //                 //               size: 32,
                //                 //             )),
                //                 //           ),
                //                 //         ),
                //                 //         const SizedBox(
                //                 //           height: 5,
                //                 //         ),
                //                 //         Text(
                //                 //           "Approval",
                //                 //           style: TextStyle(
                //                 //               fontWeight: FontWeight.bold),
                //                 //         )
                //                 //       ],
                //                 //     )),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
