import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approved_show.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approvel.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Approved.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_First.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/model.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TravelClaimSecondStatus extends StatefulWidget {
  final List<JourneyData> JJourney;
  final List<LocalConveyence> localConvenecy;
  final List<otherExpence> otherexpense;
  final List<Summary> summarydetails;
  final List<BoardingData> boardgingdata;

  final String TravelID;
  // Constructor to receive the journeyList
  TravelClaimSecondStatus(
      {required this.JJourney,
      required this.localConvenecy,
      required this.otherexpense,
      required this.summarydetails,
      required this.boardgingdata,
      required this.TravelID});
  @override
  _TravelClaimSecondStatus createState() => _TravelClaimSecondStatus();
}

//TextEditingController();
TextEditingController Time = TextEditingController();

class _TravelClaimSecondStatus extends State<TravelClaimSecondStatus> {
  final TextEditingController totalEstimatedController =
      TextEditingController();

  TextEditingController _lodgingcharged = TextEditingController();
  TextEditingController _foodbillamount = TextEditingController();
  TextEditingController _amountwithouttax = TextEditingController();
  TextEditingController _HotelName = TextEditingController();
  TextEditingController _StartPoint = TextEditingController();
  TextEditingController _EndPoint = TextEditingController();
  TextEditingController _Basicfair = TextEditingController();
  TextEditingController _distance = TextEditingController();
  TextEditingController _uploadfile = TextEditingController();
  TextEditingController _Departuretime = TextEditingController();
  TextEditingController _Arrivaltime = TextEditingController();

  String employeeName = "";
  String designation = "";
  String employeeNo = "";
  String departmentWing = "";
  String managerName = "";
  String travelRequestID = "";
  String dateRange = "";
  String claimStatus = "";
  String destination = "";
  String gradepay = "";
  String cityClass = "";
  String mailAddress = "";
  String maxEligibleAmount = "";
  String daAmount = "";
  String daParaReq = "";
  String daAllowance = "";
  String hotelAmount = "";
  String haParaReq = "";
  String taxiAmount = "";
  String taParaReq = "";

  String? journeydetaisl;
  String? boardingdetail;
  bool journey = false;
  bool boarding = false;
  String travelClaim = "";
  String Name = "";
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    dataFound();
    SubmitAPI();
  }

  String? _JourneyAmt;
  String? _OthAmt;
  String? _Remark;
  String? _HigherAmt;
  String? _DaAmt;
  String? _BoardAmt;
  String? _TotAmt;
  String? _AdvAmt;
  String? _LocalConAmt;

  String? _ClaimStatus;
  String? _ClaimCode;
  String? Fromdate;
  String? Todate;
  String? claimstatuss;

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      travelClaim = prefs.getString("TravelClaim") ?? '';
      Name = prefs.getString("labelname") ?? '';
      _JourneyAmt = prefs.getString("_JourneyAmt") ?? '';
      _OthAmt = prefs.getString("_OthAmt") ?? '';
      _HigherAmt = prefs.getString("_HigherAmt") ?? '';
      _Remark = prefs.getString("_Remark") ?? '';
      _DaAmt = prefs.getString("_DaAmt") ?? '';
      _BoardAmt = prefs.getString("_BoardAmt") ?? '';
      _AdvAmt = prefs.getString("_AdvAmt") ?? '';
      _TotAmt = prefs.getString("_TotAmt") ?? '';
      _LocalConAmt = prefs.getString("_LocalConAmt") ?? '';

      _ClaimStatus = prefs.getString("_ClaimStatus") ?? '';
      _ClaimCode = prefs.getString("_ClaimCode") ?? '';
      Fromdate = prefs.getString("_LocalConAmt") ?? '';
      Todate = prefs.getString("Todate") ?? '';
      claimstatuss = prefs.getString("claimstatuss") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Show Details",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => TravelClaimStatusfirst()),
            // );

            if (travelClaim == "Approvel") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelClaimapproved()));
            } else if (travelClaim == "Status") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelClaimApproved(
                            ClaimStatus: '',
                            ClaimCode: '',
                            Fromdate: '',
                            Todate: '',
                            claimstatuss: '',
                          )));
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Labe("Employee Name", employeeName),
              Labe("Designation", designation),
              Labe("Employee No", employeeNo),
              Labe("DepartmentWing", departmentWing),
              Labe("Manager Name", managerName),
              Labe("Travel Request ID", travelRequestID),
              Labe("Date Range", dateRange),
              Labe("Claim Status", claimStatus),
              Labe("Destination", destination),
              Labe("Grade Pay", gradepay),
              Labe("Travel City Class", cityClass),
              Labe("Max Eligible Amount", maxEligibleAmount),
              Labe("Mail Address", mailAddress),

              SizedBox(
                height: 10,
              ),
              Hader_Label("Details Of Journey"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: widget.JJourney.length,
                  itemBuilder: (context, index) {
                    final itemm = widget.JJourney[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaxDateBoardging("Departure Date", itemm.depDate,
                            "Departure Time", itemm.depTime),
                        TaxDateBoardging("Departure Start Point",
                            itemm.depPlace, "Arrival Date", itemm.arrDate),
                        TaxDateBoardging("Arrival Time", itemm.arrTime,
                            "Arrival End Point", itemm.arrPlace),
                        TaxDateBoardging("Travel Mode", itemm.trvMode,
                            "Basic Fare", itemm.farePaid.toString()),
                        TaxDateBoardging("Distance", itemm.distance.toString(),
                            "Purpose Visit", itemm.purVisit),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Hader_Label("Boardging/Lodging Details Require"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  itemCount: widget.boardgingdata.length,
                  itemBuilder: (context, index) {
                    final itemmm = widget.boardgingdata[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaxDateBoardging(
                            "From date", itemmm.from, "To date", itemmm.to),
                        TaxDateBoardging("Type Of Hotel", itemmm.HotelType,
                            "Name Of Hotel", itemmm.hotelName),
                        TaxDateBoardging("Lodging Charged", itemmm.dailyRate,
                            "Food Bill Amount", itemmm.FoodBillAmt),

                        // Label(),
                        // Entry(itemmm.FoodBillAmt),
                        // Label("Amount Without Tax"),
                        // Entry(itemmm.TotAmt),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Hader_Label("Details Of Local Conveyance"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: widget.localConvenecy.length,
                    itemBuilder: (context, index) {
                      final itemmmm = widget.localConvenecy[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaxDateBoardging("From Date", itemmmm.LocalFrom,
                              "To Date", itemmmm.LocalTo),
                          TaxDateBoardging("Travel Mode", itemmmm.TrvMode,
                              "Expense Remarks", itemmmm.LocalExp),

                          //
                          // Label("Amount Without Tax"),
                          // Entry(itemmmm.LocalTotal),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Hader_Label("Details Of Other Expenses"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: widget.otherexpense.length,
                    itemBuilder: (context, index) {
                      final itemmmmm = widget.otherexpense[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaxDateBoardging("From Date", itemmmmm.FromDate,
                              "To Date", itemmmmm.ToDate),
                          TaxDateBoardging("Expense Remarks", itemmmmm.Remark,
                              "Amount Without Tax", itemmmmm.TotAmt),
                        ],
                      );
                    },
                  ),
                ),
              ),

              buildTextField("Journey Fare Total(A)", _JourneyAmt.toString()),
              buildTextField("Boarding/Lodging Total(B)", _BoardAmt.toString()),
              buildTextField("Other Expense Total(C)", _OthAmt.toString()),
              buildTextField(
                  "Local Conveyance Total(D)", _LocalConAmt.toString()),
              buildTextField("Advance Taken", _AdvAmt.toString()),
              buildTextField("Total (A+B+C+D+E)", _TotAmt.toString()),
              buildTextField("Remarks", _Remark.toString()),

              // buildTextField("Other Expense Total(C)", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              // buildTextField("Local Conveyance Total(D)", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              // buildTextField("D.A Amount(E)", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              // buildTextField("Advance Taken", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              // buildTextField("Total (A+B+C+D+E)", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              // buildTextField("Remarks", (value) {
              //   setState(() {
              //     //  purposeDetails = value;
              //   });
              // }, controller: _StartPoint),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (travelClaim == "Approvel") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TravelClaimapprovelfirst(
                                  Journey_ListDate: widget.JJourney,
                                  Local_ListDate: widget.localConvenecy,
                                  Other_ListDate: widget.otherexpense,
                                  Boardging_ListDate: widget.boardgingdata,
                                )));
                  } else if (travelClaim == "Status") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (Context) => TravelClaimDashboard()));
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return Builder(builder: (context) {
                    //       return MediaQuery(
                    //         data: MediaQuery.of(context).copyWith(
                    //             textScaler: const TextScaler.linear(1.1)),
                    //         child: AlertDialog(
                    //           title: const Text(
                    //             'Alert',
                    //             style: TextStyle(fontSize: 12),
                    //           ),
                    //           content: const Text(
                    //             'Working Progress',
                    //             style: TextStyle(fontSize: 12),
                    //           ),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text(
                    //                 'OK',
                    //                 style: TextStyle(fontSize: 16),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     });
                    //   },
                    // );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        Name,
                        style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String EntryText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(hintText: EntryText, enabled: false),
          ),
        ),
      ],
    );
  }

  // Widget buildTextField(String labelText, String EntryText) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 5, left: 10),
  //         child: Text(
  //           labelText,
  //           style: const TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: "TimesNewRoman",
  //               color: Color(0xFF547EC8)),
  //           textAlign: TextAlign.start,
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(right: 10, left: 10),
  //         child: Container(
  //           margin: EdgeInsets.only(top: 5),
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           height: 40,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(color: Colors.grey),
  //           ),
  //           child: TextFormField(
  //             keyboardType: TextInputType.number,
  //             style: TextStyle(color: Colors.black, fontSize: 15

  //                 // Set the color for the input text
  //                 ),
  //             decoration: InputDecoration(
  //               hintText: EntryText,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<void> SubmitAPI() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String EmpKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=employeedetails' +
              '&empId=' +
              "15771" +
              "&trvid=Trv3631/240501-240508";

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        await EasyLoading.dismiss();
        List<dynamic> jsonData = jsonDecode(response.body);
        var employee = jsonData[0];
        setState(() {
          employeeName = employee['Employee Name'];
          designation = employee['Designation'];
          employeeNo = employee['Employee No.'];
          departmentWing = employee['DepartmentWing'];
          managerName = employee['Manager Name'];
          travelRequestID = employee['Travel Request ID'];
          dateRange = employee['Date Range'];
          claimStatus = employee['Travelrequest Status'];
          destination = employee['Destination'];
          gradepay = employee['Gradepay'];
          cityClass = employee['CityClass'];
          mailAddress = employee['MailAddress'];
          maxEligibleAmount = employee['Max Eligible Amount'].toString();
        });
        // daAmount = employee['DAAmount'].toString();
        // daParaReq = employee['DAParaReq'].toString();
        // daAllowance = employee['DA_Allowance'].toString();
        // hotelAmount = employee['Hotel_Amount'].toString();
        // haParaReq = employee['HAParaReq'].toString();
        // taxiAmount = employee['TAXIAmount'].toString();
        // taParaReq = employee['TAParaReq'].toString();

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => TravelClaimDetails()));

        // setState(() {
        //   TravelID =
        //       jsonData.map((data) => TravelRequestID.fromJson(data)).toList();
        // });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      await EasyLoading.dismiss();
      setState(() {});
      // Alert_DialogBox.showAlert(context, "Unable to Connect to the Server");
    }
  }

  Widget Labe(String First_label, String Second_Label) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(First_label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: "TimesNewRoman",
                )),
          ),
          Flexible(
            child: Text(
              Second_Label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "TimesNewRoman",
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Hader_Label(String First_label) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(First_label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF547EC8),
                  fontFamily: "TimesNewRoman",
                )),
          ),
        ],
      ),
    );
  }

  Widget Label(
    String First_label,
    String Second_Label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Flexible(
              child: Text(First_label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "TimesNewRoman",
                  )),
            ),
          ),
          Flexible(
            child: Text(Second_Label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: "TimesNewRoman",
                )),
          ),
        ],
      ),
    );
  }

  Widget Entry(
    String Entry_label,
    String Label_seconde,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 150,
          height: 45, // Matching width for TextFormField container
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: Entry_label,
              border: InputBorder.none, // Remove the inner border
            ),
          ),
        ),
        Container(
          width: 150,
          height: 45, // Matching width for TextFormField container
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: Label_seconde,
              border: InputBorder.none, // Remove the inner border
            ),
          ),
        ),
      ]),
    );
  }

  Widget TaxDateBoardging(
    String Name,
    String SecondName,
    String name_Entry,
    String Secondname_Entry,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                Name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 150,
                height: 45, // Matching width for TextFormField container
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: SecondName,
                    enabled: false,
                    border: InputBorder.none, // Remove the inner border
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                name_Entry,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 150,
                height: 45, // Matching width for TextFormField container
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: Secondname_Entry,
                    enabled: false,
                    border: InputBorder.none, // Remove the inner border
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
