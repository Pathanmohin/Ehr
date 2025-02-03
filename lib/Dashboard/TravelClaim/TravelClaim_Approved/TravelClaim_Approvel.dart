import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approved_show.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_Second.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/demo_travel.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/model.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Successalertbox.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TravelClaimapprovelfirst extends StatefulWidget {
  List<JourneyData> Journey_ListDate;
  List<LocalConveyence> Local_ListDate;
  List<otherExpence> Other_ListDate;
  List<BoardingData> Boardging_ListDate;
  // Constructor to receive the journeyList
  TravelClaimapprovelfirst(
      {required this.Journey_ListDate,
      required this.Local_ListDate,
      required this.Other_ListDate,
      required this.Boardging_ListDate});

  @override
  _TravelClaimapprovelfirst createState() => _TravelClaimapprovelfirst();
}

class ApprovelLevel {
  int? ApprovalLevelAction_Kid;
  int? ID;
  String? Name;

  List<ApprovelLevel>? childModelsList;

  ApprovelLevel({
    this.ApprovalLevelAction_Kid,
    this.ID,
    this.Name,
  });

  factory ApprovelLevel.fromJson(Map<String, dynamic> json) {
    return ApprovelLevel(
      ApprovalLevelAction_Kid: json['ApprovalLevelAction_Kid'],
      ID: json['ID'],
      Name: json['Name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ApprovalLevelAction_Kid': ApprovalLevelAction_Kid,
      'ID': ID,
      'Name': Name,
    };
  }
}

class Journey {
  List<Map<String, dynamic>> journeyDataList;

  // Constructor to accept the journey data
  Journey({required this.journeyDataList});

  // Convert Journey object to JSON
  List<Map<String, dynamic>> toJson() {
    return journeyDataList; // Directly return the list of maps
  }
}

class BOARDGING {
  List<Map<String, dynamic>> BoardgingDataList;

  // Constructor to accept the journey data
  BOARDGING({required this.BoardgingDataList});

  // Convert Journey object to JSON
  List<Map<String, dynamic>> toJson() {
    return BoardgingDataList; // Directly return the list of maps
  }
}

class Local {
  List<Map<String, dynamic>> localDataList;

  // Constructor to accept the journey data
  Local({required this.localDataList});

  // Convert Journey object to JSON
  List<Map<String, dynamic>> toJson() {
    return localDataList; // Directly return the list of maps
  }
}

class Other {
  List<Map<String, dynamic>> otherDataList;

  // Constructor to accept the journey data
  Other({required this.otherDataList});

  // Convert Journey object to JSON
  List<Map<String, dynamic>> toJson() {
    return otherDataList; // Directly return the list of maps
  }
}

TextEditingController Time = TextEditingController();

class _TravelClaimapprovelfirst extends State<TravelClaimapprovelfirst> {
  final TextEditingController totalEstimatedController =
      TextEditingController();

  TextEditingController _fareRemarks = TextEditingController();
  TextEditingController _BoardgingRemark = TextEditingController();
  TextEditingController _OtherRemark = TextEditingController();
  TextEditingController _LocalRemarks = TextEditingController();
  TextEditingController _DaRemarks = TextEditingController();
  TextEditingController _Remarkss = TextEditingController();
  TextEditingController _FareApprovel = TextEditingController();
  TextEditingController _DAAMOUNT = TextEditingController();
  TextEditingController _Boardgingamounr = TextEditingController();
  TextEditingController _OtherExepnceamount = TextEditingController();
  TextEditingController _LocalConvancyAmount = TextEditingController();
  TextEditingController _TotalAmount = TextEditingController();
  // TextEditingController _fareRemarks = TextEditingController();
  // TextEditingController _fareRemarks = TextEditingController();
  List<ApprovelLevel> fromAccountList = <ApprovelLevel>[];
  ApprovelLevel? SelectTravelHotel;
  String? journeydetaisl;
  String? SelectAction;
  bool journey = false;
  bool boarding = false;
  bool savePassword = false;
  bool savePasswordd = false;
  String selectedOption = "";
  String? _JourneyAmtt;
  String? _OthAmtt;
  String? _Remarkk;
  String? _HigherAmtt;
  String? _DaAmtt;
  String? _BoardAmtt;
  String? _TotAmtt;
  String? _AdvAmtt;
  String? _LocalConAmtt;
  String? _ClaimParaID;
  String? _AdvanceID;
  String? _TrainConnectDataDeduct;
  String? _OtherDeduct;
  String? _Empid;
  String? _TrvId;
  double? estimatedFare;
  double? estimatedBoardingLodging;
  double? otherExpense;
  double? totalEstimatedCost;
  double? advanceAmount;
  var SecondTravelMode;
  String? LabelTextField;

  @override
  void initState() {
    super.initState();
    dataFound();
    _TravelMode();
    _FareApprovel.addListener(calculateTotalEstimatedCost);
    _Boardgingamounr.addListener(calculateTotalEstimatedCost);
    _OtherExepnceamount.addListener(calculateTotalEstimatedCost);
    _LocalConvancyAmount.addListener(calculateTotalEstimatedCost);
    _DAAMOUNT.addListener(calculateTotalEstimatedCost);
  }

  @override
  void dispose() {
    // Dispose controllers

    _FareApprovel.dispose();
    _Boardgingamounr.dispose();
    _OtherExepnceamount.dispose();
    _LocalConvancyAmount.dispose();
    _DAAMOUNT.dispose();
    _TotalAmount.dispose();
    super.dispose();
  }

  void calculateTotalEstimatedCost() {
    // _FareApprovel.text = _JourneyAmtt.toString();
    setState(() {
      double fareApproval = double.tryParse(_FareApprovel.text) ?? 0.0;
      double boardingApproval = double.tryParse(_Boardgingamounr.text) ?? 0.0;
      double otherExpenses = double.tryParse(_OtherExepnceamount.text) ?? 0.0;
      double localConveyance =
          double.tryParse(_LocalConvancyAmount.text) ?? 0.0;
      double daAmount = double.tryParse(_DAAMOUNT.text) ?? 0.0;

      double total = fareApproval +
          boardingApproval +
          otherExpenses +
          localConveyance +
          daAmount;

      // Update total amount controller
      _TotalAmount.text = total.toStringAsFixed(2); // Update the controller
    });
  }

  Future<void> _TravelMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     
      String EmpKid = prefs.getString('EmpKid') ?? '';
      String USERID = prefs.getString('userID') ?? '';
      String _Currlvl = prefs.getString('_Currlvl') ?? '';
      String _ApprovalLevelID = prefs.getString('_ApprovalLevelID') ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=ApprovalAction&loginby=' +
              USERID.toString() +
              '&EmpKid=' +
              EmpKid.toString() +
              '&currlevel=' +
              _Currlvl.toString() +
              '&ApprovalLevelID=' +
              _ApprovalLevelID.toString();

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        String rawResponse = response.body;

        // Extract only the first array
        int closingBracketIndex = rawResponse.indexOf('][');
        if (closingBracketIndex != -1) {
          rawResponse = rawResponse.substring(
              0, closingBracketIndex + 1); // Only first array
        }
        List<dynamic> jsonData = jsonDecode(rawResponse);

        // List<dynamic> jsonResponse = jsonDecode(responseData["data"]);

        int all = 0;
        for (var config in jsonData) {
          ApprovelLevel vObject = new ApprovelLevel();

          vObject.ApprovalLevelAction_Kid = config["ApprovalLevelAction_Kid"];
          vObject.ID = config["ID"];
          vObject.Name = config["Name"];

          fromAccountList.add(vObject);
        }

        // setState(() {
        //   // travelmodes = jsonData.map((data) => TravelMode.fromJson(data).text).toList();

        //   travelmodes =
        //       jsonData.map((data) => TravelMode.fromJson(data)).toList();
        // });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      //_showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  } //

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _JourneyAmtt = prefs.getString("_JourneyAmt") ?? '';
      _OthAmtt = prefs.getString("_OthAmt") ?? '';
      _HigherAmtt = prefs.getString("_HigherAmt") ?? '';
      _Remarkk = prefs.getString("_Remark") ?? '';
      _DaAmtt = prefs.getString("_DaAmt") ?? '';
      _BoardAmtt = prefs.getString("_BoardAmt") ?? '';
      _AdvAmtt = prefs.getString("_AdvAmt") ?? '';
      _TotAmtt = prefs.getString("_TotAmt") ?? '';
      _LocalConAmtt = prefs.getString("_LocalConAmt") ?? '';
      _ClaimParaID = prefs.getString("_ClaimParaID") ?? '';
      _AdvanceID = prefs.getString("_AdvanceID") ?? '';
      _TrainConnectDataDeduct =
          prefs.getString("_TrainConnectDataDeduct") ?? '';
      _OtherDeduct = prefs.getString("_OtherDeduct") ?? '';
      _Empid = prefs.getString("_Empid") ?? '';

      _TrvId = prefs.getString("_TrvId") ?? '';

      _FareApprovel.text = _JourneyAmtt.toString();
      _Boardgingamounr.text = _BoardAmtt.toString();
      _OtherExepnceamount.text = _OthAmtt.toString();
      _LocalConvancyAmount.text = _LocalConAmtt.toString();
      _DAAMOUNT.text = _DaAmtt.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Travel Approval",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TravelClaimSecondStatus(
                        JJourney: [],
                        localConvenecy: [],
                        otherexpense: [],
                        summarydetails: [],
                        boardgingdata: [],
                        TravelID: '',
                      )),
            );
            //Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Showbuild(
                "Fare Approval(A)*",
                "500",
                controller: _FareApprovel,
              ),
              Showbuild("Boarding Approval(B)*", _Boardgingamounr.toString(),
                  controller: _Boardgingamounr),
              Showbuild("Other Expenses(C)*", _OtherExepnceamount.toString(),
                  controller: _OtherExepnceamount),
              Showbuild("Local Conveyance(D)*", _LocalConvancyAmount.toString(),
                  controller: _LocalConvancyAmount),
              Showbuild("Approval Of D.A Amount(E)*", _DAAMOUNT.toString(),
                  controller: _DAAMOUNT),

              ShowbuildTextField("Total Approved Claim Amount", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _TotalAmount),

              Labe("Payment Mode"),
              // This will hold the selected option, either "Cash" or "Bank"

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: selectedOption == "Cash",
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (newValue == true) {
                              selectedOption = "Cash";
                            } else {
                              selectedOption = ""; // Deselect if unchecked
                            }
                          });
                        },
                        activeColor: const Color.fromARGB(255, 8, 6, 6),
                      ),
                      Text(
                        "Cash",
                        style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedOption == "Bank",
                          onChanged: (bool? newValue) {
                            setState(() {
                              if (newValue == true) {
                                selectedOption = "Bank";
                              } else {
                                selectedOption = ""; // Deselect if unchecked
                              }
                            });
                          },
                          activeColor: const Color.fromARGB(255, 8, 6, 6),
                        ),
                        Text(
                          "Bank",
                          style: TextStyle(
                              fontFamily: "TimesNewRoman",
                              color: Colors.black,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ShowbuildTextField("Fare Remarks", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _fareRemarks),
              ShowbuildTextField("Boarding Remarks", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _BoardgingRemark),
              ShowbuildTextField("Other Expenses Remarks", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _OtherRemark),
              ShowbuildTextField("Local Conveyance Remarks", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _LocalRemarks),
              ShowbuildTextField("D.A Remarks", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _DaRemarks),
              SizedBox(
                height: 10,
              ),
              buildDropdownField<ApprovelLevel>(
                labelText: "Select Action*",
                items: fromAccountList,
                selectedItem: SecondTravelMode,
                onChanged: (value) {
                  setState(() {
                    SecondTravelMode = value;
                  });

                  LabelTextField = value!.ID.toString();
                },
                displayText: (SecondTravelMode) => SecondTravelMode.Name
                    .toString(), // Display only the text field
              ),
              // buildDropdownField<String>(
              //     labelText: "Select Action*",
              //     items: ["Approve", "Reject"],
              //     selectedItem: SelectAction,
              //     onChanged: (value) {
              //       setState(() {
              //         SelectAction = value;
              //       });
              //     },
              //     displayText: (Vehicle) => Vehicle),
              ShowbuildTextField("Remarks*", (value) {
                setState(() {
                  //  purposeDetails = value;
                });
              }, controller: _Remarkss),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  SubmitAPI();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TravelClaimThird()));

                  if (SelectAction == null || SelectAction == "") {
                    DialogboxAlert("Please Select Action");
                  } else if (_Remarkss.text == null || _Remarkss.text == "") {
                    DialogboxAlert("Please Enter Remarks");
                  }

                  if (selectedOption.isEmpty) {
                    DialogboxAlert("Please Select Payment Mode");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Authorize",
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

  Widget Labe(String First_label) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              First_label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> SubmitAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
   
    String _Currlvl = prefs.getString('_Currlvl') ?? '';
    String EmpKid = prefs.getString('EmpKid') ?? '';
    // List<Map<String, dynamic>> jsonList =
    //     widget.Boardging_ListDate.map((journey) => journey.toJson()).toList();

    String jsonData = json.encode(widget.Boardging_ListDate);
    String jsonDataaa = json.encode(widget.Journey_ListDate);
    String jsonDataa = json.encode(widget.Local_ListDate);
    String jsonDataaaa = json.encode(widget.Other_ListDate);

    List<dynamic> Boardging = jsonDecode(jsonData);
    List<dynamic> inputList = jsonDecode(jsonDataaa);
    List<dynamic> local = jsonDecode(jsonDataa);
    List<dynamic> other = jsonDecode(jsonDataaaa);

    List<Map<String, dynamic>> transformedList = inputList.map((item) {
      return {
        "Table1": {
          //"TaxAmount": "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~${item['FarePaid']},",
          "Kid": item['Kid'],
          "JourDepDate": item['DepDate'],
          "JourDepTime": item['DepTime'],
          "JourDepPlace": item['DepPlace'],
          "JourArrDate": item['ArrDate'],
          "JourArrTime": item['ArrTime'],
          "JourArrPlace": item['Arrplace'],
          "TravelMode": item['TrvMode'],
          "JourFare": item['FarePaid'],
          "JourDist": item['Distance'],
          "VisitPur": item['PurVisit'],
          "Remarks": item['Remarks']
        }
      };
    }).toList();
    List<Map<String, dynamic>> boardgingdate = Boardging.map((item) {
      return {
        "Table1": {
          //"TaxAmount": "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~${item['FarePaid']},",
          "Kid": item['Kid'],
          "BoardFromDate": item['From'],
          "BoardToDate": item['To'],
          "BoardHotelType": item['HotelName'],
          "BoardHotel": item['DailyRate'],
          "BoardRate": item['TotAmt'],
          "FoodBillAmount": item['HotelType'],
          "BoardtotAmt": item['FoodBillAmt'],
        }
      };
    }).toList();
    List<Map<String, dynamic>> OtherExpence = local.map((item) {
      return {
        "Table1": {
          //"TaxAmount": "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~${item['FarePaid']},",
          "Kid": item['Kid'],
          "OthFrom": item['FromDate'],
          "OthTo": item['ToDate'],
          "OthExp": item['Remark'],
          "OthTotal": item['TotAmt'],
        }
      };
    }).toList();
    List<Map<String, dynamic>> LocalConvency = other.map((item) {
      return {
        "Table1": {
          //"TaxAmount": "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~${item['FarePaid']},",
          "Kid": item['Kid'],
          "LocalFrom": item['LocalFrom'],
          "LocalTo": item['LocalTo'],
          "TrvMode": item['TrvMode'],
          "LocalExp": item['LocalExp'],
          "LocalTotal": item['LocalTotal'],
        }
      };
    }).toList();

    BOARDGING boardgingdata = BOARDGING(BoardgingDataList: boardgingdate);
    Journey journey = Journey(journeyDataList: transformedList);
    Local _LocalLIST = Local(localDataList: LocalConvency);
    Other _OTHERLIST = Other(otherDataList: OtherExpence);

    String B = json.encode(boardgingdate);
    String J = json.encode(transformedList);
    String L = json.encode(LocalConvency);
    String O = json.encode(OtherExpence);

    Map<String, dynamic> combinedData = {
      'Loginby': EmpKid,
      'TrvId': _TrvId.toString(),
      'Currlvl': _Currlvl.toString(),
      'HigherClass': '<HigherCls></HigherCls>',
      'ConnectTrav': '<Connect></Connect>',
      'ActionID': LabelTextField.toString(),
      'EmpID': _Empid.toString(),
      'JourneyTot': _JourneyAmtt.toString(),
      'boardTot': _BoardAmtt.toString(),
      'HigherClsTot': _HigherAmtt.toString(),
      'OthTotal': _OthAmtt.toString(),
      'TrainDataTot': _TrainConnectDataDeduct.toString(),
      'DaAmt': _DaAmtt.toString(),
      'remark': _Remarkk.toString(),
      'Journey': jsonDataaa,
      'BoardData': jsonData,
      'OthExp': jsonDataaaa,
      'LocalCon': jsonDataa,
      'ClaimParaID': _ClaimParaID.toString(),
      'AdvanceID': _AdvanceID.toString(),
      'fareremark': _fareRemarks.text,
      'boardremark': _BoardgingRemark.text,
      'othremark': _OtherRemark.text,
      'localremark': _LocalRemarks.text,
      'daremark': _DaRemarks.text,
      'LocalConTot': _LocalConvancyAmount.text,
      'journeyamount': _FareApprovel.text,
      'boardamount': _Boardgingamounr.text,
      'higheramount': _HigherAmtt.toString(),
      'trainamount': _TrainConnectDataDeduct.toString(),
      'otheramount': _OtherExepnceamount.text,
      'daamount': _DAAMOUNT.text,
    };
    String Data = json.encode(combinedData);
    try {
      //await EasyLoading.show(status: 'Loading...');
      var url = Uri.parse(
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/Mobile/TravalClaimAuth.ashx');

      var response = await http.post(url,
          body: Data,
          headers: {'Content-Type': 'application/json'},
          encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Assuming the response is a list and extracting the message
        final msg = responseData[0]['Msg'];

        Success_Alert_DialogBox.showAlert(context, msg);

        // setState(() {
        //   String _message = msg;
        // });
      }
    } catch (e) {
      await EasyLoading.dismiss();
      print("Error: $e");
    }
  }

  Widget buildDropdownField<T>({
    required String labelText,
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onChanged,
    required String Function(T)
        displayText, // Function to display text for each item
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            labelText,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: DropdownButton<T>(
            isExpanded: true,
            value: selectedItem,
            hint: const Text("Select",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "TimesNewRoman",
                    color: Colors.black)),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(displayText(item),
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Widget buildDropdownField<T>({
  //   required String labelText,
  //   required List<T> items,
  //   required T? selectedItem,
  //   required Function(T?) onChanged,
  //   required String Function(T)
  //       displayText, // Function to display text for each item
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 10),
  //         child: Text(
  //           labelText,
  //           style: const TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: "TimesNewRoman",
  //               color: Color(0xFF547EC8)),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(right: 10, left: 10),
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 5),
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(color: Colors.grey),
  //           ),
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton<T>(
  //               isExpanded: true,
  //               value: selectedItem,
  //               hint: const Text("Select Action",
  //                   style: TextStyle(
  //                       fontSize: 15,
  //                       fontFamily: "TimesNewRoman",
  //                       color: Colors.black)),
  //               items: items.map((T item) {
  //                 return DropdownMenuItem<T>(
  //                   value: item,
  //                   child: Text(displayText(item),
  //                       style: const TextStyle(
  //                           fontSize: 15,
  //                           fontFamily: "TimesNewRoman",
  //                           color: Colors.black)),
  //                 );
  //               }).toList(),
  //               onChanged: onChanged,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void DialogboxAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(
                'Alert',
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget buildTextField(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
    String? initialValue,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10),
          child: Text(
            labelText,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              enabled: isEnabled,
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15

                  // Set the color for the input text
                  ),
              decoration: InputDecoration(
                hintText: labelText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget ShowbuildTextField(
  String labelText,
  Function(String) onChanged, {
  bool isEnabled = true,
  String? initialValue,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5, left: 10),
        child: Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            enabled: isEnabled,
            controller: controller,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black, fontSize: 15, fontFamily: "TimesNewRoman",

              // Set the color for the input text
            ),
            decoration: InputDecoration(hintText: labelText),
          ),
        ),
      ),
    ],
  );
}

Widget Showbuild(
  String labelText,
  String entryText, {
  required TextEditingController controller,
}) {
  //controller.text = entryText;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5, left: 10),
        child: Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.black, fontSize: 15, fontFamily: "TimesNewRoman",

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              //hintText: Entry_Text,
              hintText:
                  controller.text.isEmpty ? 'Enter Amount' : controller.text,
            ),
          ),
        ),
      ),
    ],
  );
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
