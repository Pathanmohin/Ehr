
// import 'package:ehr/Dashboard/Claim/ClaimDashboard.dart';
// import 'package:ehr/Dashboard/Claim/Local_Convency_Dashboard.dart';
// import 'package:ehr/Dashboard/Claim/Staffpolicy.dart';
// import 'package:ehr/Dashboard/Dashboard.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
// import 'package:ehr/Dashboard/viewmore/GPF%20Management/gpfsavetitle.dart';
// import 'package:flutter/material.dart';

// class Staffpolicy extends StatefulWidget {
//   const Staffpolicy({super.key});

//   @override
//   State<Staffpolicy> createState() => _ClaimDashboard();
// }

// class _ClaimDashboard extends State<Staffpolicy> {
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return MediaQuery(
//         data: MediaQuery.of(context)
//             .copyWith(textScaler: const TextScaler.linear(1.1)),
//         child: WillPopScope(
//           onWillPop: () async {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => const ClaimDashboard()));

//             return false;
//           },
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: const Text(
//                 "GFP Claim",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: "TimesNewRoman",
//                   fontSize: 18,
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 color: Colors.white,
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Dashboard()));
//                 },
//               ),
//               backgroundColor: Colors.blue,
//             ),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [

//                  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 3,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.people_alt_rounded,
//                                 size: 32,
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "Policy Claim",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               InkWell(
//                                   onTap: () {
//                                     //  Gpfsavetitle.title = "GPF Request";

//                                    Gpfsavetitle.title = "GPF Request";

//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const StaffPolicyClaim()));
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.3),
//                                               spreadRadius: 3,
//                                               blurRadius: 7,
//                                               offset: const Offset(0, 3),
//                                             ),
//                                           ],
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Center(
//                                               child: Icon(
//                                             Icons.card_membership,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 8,
//                                       ),
//                                       const Text(
//                                        "Request",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   )),
//                               InkWell(
//                                   onTap: () {
                                    
//                               Gpfsavetitle.title = "GPF Status";
                                    
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const StaffPolicyClaim()));
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.3),
//                                               spreadRadius: 3,
//                                               blurRadius: 7,
//                                               offset: const Offset(0, 3),
//                                             ),
//                                           ],
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Center(
//                                               child: Icon(
//                                             Icons.summarize,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 8,
//                                       ),
//                                       const Text(
//                                         "Status",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
                                     
//                                     ],
//                                   )),

//                               InkWell(
//                                   onTap: () {
//                                     Gpfsavetitle.title = "GPF Approval";
                                    
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const StaffPolicyClaim()));
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.3),
//                                               spreadRadius: 3,
//                                               blurRadius: 7,
//                                               offset: const Offset(0, 3),
//                                             ),
//                                           ],
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Center(
//                                               child: Icon(
//                                             Icons.approval_rounded,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 8,
//                                       ),
//                                       const Text(
//                                         "Approval",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
                                     
//                                     ],
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
