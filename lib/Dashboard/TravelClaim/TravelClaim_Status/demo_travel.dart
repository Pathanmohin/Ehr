// import 'dart:convert';

// import 'package:ehr/Dashboard/Dashboard.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approved_show.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approvel.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Approved.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_First.dart';
// import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/model.dart';
// import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
// import 'package:ehr/app.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class TravelClaimSecondStatus extends StatefulWidget {
//   // Constructor to receive the journeyList

//   final List<JourneyData> JJourney;
//   final List<LocalConveyence> localConvenecy;
//   final List<otherExpence> otherexpense;
//   final List<Summary> summarydetails;
//   final List<BoardingData> boardgingdata;
//   // Constructor to receive the journeyList
//   TravelClaimSecondStatus(
//       {required this.JJourney,
//       required this.localConvenecy,
//       required this.otherexpense,
//       required this.summarydetails,
//       required this.boardgingdata});
//   @override
//   _TravelClaimSecondStatus createState() => _TravelClaimSecondStatus();
// }

// class _TravelClaimSecondStatus extends State<TravelClaimSecondStatus> {
//   @override
//   void initState() {
//     super.initState();
//     //sendJourneyData();
//     dataFound();
//     SubmitAPI();
//   }

//   Future<void> dataFound() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       travelClaim = prefs.getString("TravelClaim") ?? '';
//       Name = prefs.getString("labelname") ?? '';
//     });
//   }

//   final TextEditingController totalEstimatedController =
//       TextEditingController();

//   TextEditingController _lodgingcharged = TextEditingController();
//   TextEditingController _foodbillamount = TextEditingController();
//   TextEditingController _amountwithouttax = TextEditingController();
//   TextEditingController _HotelName = TextEditingController();
//   TextEditingController _StartPoint = TextEditingController();
//   TextEditingController _EndPoint = TextEditingController();
//   TextEditingController _Basicfair = TextEditingController();
//   TextEditingController _distance = TextEditingController();
//   TextEditingController _uploadfile = TextEditingController();
//   TextEditingController _Departuretime = TextEditingController();
//   TextEditingController _Arrivaltime = TextEditingController();

//   String employeeName = "";
//   String designation = "";
//   String employeeNo = "";
//   String departmentWing = "";
//   String managerName = "";
//   String travelRequestID = "";
//   String dateRange = "";
//   String claimStatus = "";
//   String destination = "";
//   String gradepay = "";
//   String cityClass = "";
//   String mailAddress = "";
//   String maxEligibleAmount = "";
//   String daAmount = "";
//   String daParaReq = "";
//   String daAllowance = "";
//   String hotelAmount = "";
//   String haParaReq = "";
//   String taxiAmount = "";
//   String taParaReq = "";

//   String? journeydetaisl;
//   String? boardingdetail;
//   bool journey = false;
//   bool boarding = false;
//   String travelClaim = "";
//   String Name = "";
//   List<TextEditingController> controllers = [];

//   // Add JourneyData wrapped in Table1 to the journey list

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Travel Claim Request",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => TravelClaimSecond()),
//             // );
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Labe("Employee Name", employeeName),
//               Labe("Designation", designation),
//               Labe("Employee No", employeeNo),
//               Labe("DepartmentWing", departmentWing),
//               Labe("Manager Name", managerName),
//               Labe("Travel Request ID", travelRequestID),
//               Labe("Date Range", dateRange),
//               Labe("Claim Status", claimStatus),
//               Labe("Destination", destination),
//               Labe("Grade Pay", gradepay),
//               Labe("Travel City Class", cityClass),
//               Labe("Max Eligible Amount", maxEligibleAmount),
//               Labe("Mail Address", mailAddress),
//               Hader_Label("Details Of Journey"),
//               const SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 height: 300,
//                 child: ListView.builder(
//                   itemCount: widget.JJourney.length,
//                   itemBuilder: (context, index) {
//                     final itemm = widget.JJourney[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TaxDateBoardging("Departure Date", itemm.depDate,
//                             "Departure Time", itemm.depTime),
//                         TaxDateBoardging("Departure Start Point",
//                             itemm.depPlace, "Arrival Date", itemm.arrDate),
//                         TaxDateBoardging("Arrival Time", itemm.arrTime,
//                             "Arrival End Point", itemm.arrPlace),
//                         TaxDateBoardging("Travel Mode", itemm.trvMode,
//                             "Basic Fare", itemm.farePaid.toString()),
//                         TaxDateBoardging("Distance", itemm.distance.toString(),
//                             "Purpose Visit", itemm.purVisit),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 300,
//                 child: ListView.builder(
//                   itemCount: widget.boardgingdata.length,
//                   itemBuilder: (context, index) {
//                     final itemmm = widget.boardgingdata[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TaxDateBoardging(
//                             "From date", itemmm.from, "To date", itemmm.to),
//                         TaxDateBoardging("Type Of Hotel", itemmm.HotelType,
//                             "Name Of Hotel", itemmm.hotelName),
//                         TaxDateBoardging("Lodging Charged", itemmm.dailyRate,
//                             "Food Bill Amount", itemmm.FoodBillAmt),

//                         // Label(),
//                         // Entry(itemmm.FoodBillAmt),
//                         // Label("Amount Without Tax"),
//                         // Entry(itemmm.TotAmt),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> SubmitAPI() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       ServerDetails serverDetails = ServerDetails();
//       String ip = serverDetails.getIPaddress();
//       String port = serverDetails.getPort();
//       String protocol = serverDetails.protocol();
//       String applicationName = serverDetails.getApplicationName();

//       String EmpKid = prefs.getString('EmpKid') ?? '';
//       await EasyLoading.show(status: 'Loading...');
//       String restUrl =
//           '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=employeedetails' +
//               '&empId=' +
//               "15771" +
//               "&trvid=Trv3631/240501-240508";

//       final response = await http.get(Uri.parse(restUrl));

//       if (response.statusCode == 200) {
//         await EasyLoading.dismiss();
//         List<dynamic> jsonData = jsonDecode(response.body);
//         var employee = jsonData[0];

//         employeeName = employee['Employee Name'];
//         designation = employee['Designation'];
//         employeeNo = employee['Employee No.'];
//         departmentWing = employee['DepartmentWing'];
//         managerName = employee['Manager Name'];
//         travelRequestID = employee['Travel Request ID'];
//         dateRange = employee['Date Range'];
//         claimStatus = employee['Claim Status'];
//         destination = employee['Destination'];
//         gradepay = employee['Gradepay'].toString();
//         cityClass = employee['CityClass'];
//         mailAddress = employee['MailAddress'];
//         maxEligibleAmount = employee['Max Eligible Amount'].toString();
//         daAmount = employee['DAAmount'].toString();
//         daParaReq = employee['DAParaReq'];
//         daAllowance = employee['DA_Allowance'].toString();
//         hotelAmount = employee['Hotel_Amount'].toString();
//         haParaReq = employee['HAParaReq'].toString();
//         taxiAmount = employee['TAXIAmount'].toString();
//         taParaReq = employee['TAParaReq'].toString();

//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => TravelClaimDetails()));

//         // setState(() {
//         //   TravelID =
//         //       jsonData.map((data) => TravelRequestID.fromJson(data)).toList();
//         // });
//       } else {
//         throw Exception('Failed ');
//       }
//     } catch (e) {
//       await EasyLoading.dismiss();
//       setState(() {});
//       // Alert_DialogBox.showAlert(context, "Unable to Connect to the Server");
//     }
//   }

//   Widget buildTextField(
//     String labelText,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 5, left: 10),
//           child: Text(
//             labelText,
//             style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: "TimesNewRoman",
//                 color: Color(0xFF547EC8)),
//             textAlign: TextAlign.start,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 10, left: 10),
//           child: Container(
//             margin: const EdgeInsets.only(top: 5),
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey),
//             ),
//             child: TextFormField(
//               keyboardType: TextInputType.number,
//               style: const TextStyle(color: Colors.black, fontSize: 15

//                   // Set the color for the input text
//                   ),
//               decoration: InputDecoration(
//                 hintText: labelText,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget Labe(String First_label, String Second_Label) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(First_label,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.black,
//                   fontFamily: "TimesNewRoman",
//                 )),
//           ),
//           Flexible(
//             child: Text(
//               Second_Label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//                 fontFamily: "TimesNewRoman",
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget Hader_Label(String First_label) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(First_label,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF547EC8),
//                   fontFamily: "TimesNewRoman",
//                 )),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget Label(
//     String First_label,
//     String Second_Label,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Flexible(
//               child: Text(First_label,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontFamily: "TimesNewRoman",
//                   )),
//             ),
//           ),
//           Flexible(
//             child: Text(Second_Label,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.black,
//                   fontFamily: "TimesNewRoman",
//                 )),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget Entry(
//     String Entry_label,
//     String Label_seconde,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10, left: 10),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Container(
//           width: 150,
//           height: 45, // Matching width for TextFormField container
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: TextFormField(
//             keyboardType: TextInputType.text,
//             style: const TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               hintText: Entry_label,
//               border: InputBorder.none, // Remove the inner border
//             ),
//           ),
//         ),
//         Container(
//           width: 150,
//           height: 45, // Matching width for TextFormField container
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: TextFormField(
//             keyboardType: TextInputType.text,
//             style: const TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               hintText: Label_seconde,
//               border: InputBorder.none, // Remove the inner border
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget TaxDateBoardging(
//     String Name,
//     String SecondName,
//     String name_Entry,
//     String Secondname_Entry,
//   ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Text(
//                 Name,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: "TimesNewRoman",
//                   color: Color(0xFF547EC8),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Container(
//                 width: 150,
//                 height: 45, // Matching width for TextFormField container
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     hintText: SecondName,
//                     border: InputBorder.none, // Remove the inner border
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 name_Entry,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: "TimesNewRoman",
//                   color: Color(0xFF547EC8),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Container(
//                 width: 150,
//                 height: 45, // Matching width for TextFormField container
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   style: const TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     hintText: Secondname_Entry,
//                     border: InputBorder.none, // Remove the inner border
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
