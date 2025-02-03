
// import 'package:ehr/Dashboard/Claim/ClaimDashboard.dart';
// import 'package:ehr/Dashboard/Claim/Local_ConvencyApprovel.dart';
// import 'package:ehr/Dashboard/Claim/Local_Request.dart';
// import 'package:ehr/Dashboard/Claim/Local_StatusClaim.dart';
// import 'package:flutter/material.dart';

// class LocalConvencyClaim extends StatefulWidget {
//   const LocalConvencyClaim({super.key});

//   @override
//   State<StatefulWidget> createState() => _LocalConvencyClaim();
// }

// class _LocalConvencyClaim extends State<LocalConvencyClaim> {
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return MediaQuery(
//         data: MediaQuery.of(context)
//             .copyWith(textScaler: const TextScaler.linear(1.1)),
//         child: WillPopScope(
//           onWillPop: () async {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ClaimDashboard()));

//             return false;
//           },
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: const Text(
//                 "Local Conveyance Claim",
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
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ClaimDashboard()));
//                 },
//               ),
//               backgroundColor: Colors.blue,
//             ),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
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
//                                 Icons.card_travel,
//                                 size: 32,
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "Local Conveyance Claim",
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

//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 LocalClaimStatus()));

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
//                                             Icons.emoji_transportation,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       const Text(
//                                         "Claim Request",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     ],
//                                   )),
//                               InkWell(
//                                   onTap: () {
//                                     //  Gpfsavetitle.title = "GPF Status";

                                    
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 localStatus()));
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
//                                             Icons.check_box,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       const Text(
//                                         "Status",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     ],
//                                   )),
//                               InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 LocalApproval()));
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
//                                             Icons.approval,
//                                             size: 32,
//                                           )),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       const Text(
//                                         "Approval",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       )
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
