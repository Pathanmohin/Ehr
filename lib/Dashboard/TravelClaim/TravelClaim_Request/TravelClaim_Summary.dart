import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Successalertbox.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TravelClaimSummary extends StatefulWidget {
  final List<Map<String, dynamic>> otherlist;
  final List<Map<String, dynamic>> locallist;
  final List<Map<String, dynamic>> boardginglist;
  final List<Map<String, dynamic>> journeylist;
  final List<Map<String, dynamic>> UploadDataFile;

  // Constructor to receive the journeyList
  TravelClaimSummary(
      {required this.otherlist,
      required this.locallist,
      required this.boardginglist,
      required this.journeylist,
      required this.UploadDataFile});
  @override
  State<StatefulWidget> createState() => _TravelClaimSummary();
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

class _TravelClaimSummary extends State<TravelClaimSummary> {
  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(Duration(milliseconds: 1));

    // Perform the navigation
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TravelClaimThird()),
    // );

    // Prevent the default back button behavior
    return false;
  }

  String? purposeDetails;

  @override
  void initState() {
    super.initState();
    dataFound();

    // sendJourneyData();
  }

  Future<void> sendJourneyData() async {
    // Assuming journeyDataList is populated with data from your UI or

    await EasyLoading.show(status: 'Loading...');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
   
    List<Map<String, dynamic>> jjourneyDataList = widget.journeylist;
    List<Map<String, dynamic>> boardginglist = widget.boardginglist;
    List<Map<String, dynamic>> _locallist = widget.locallist;
    List<Map<String, dynamic>> _otherlist = widget.otherlist;

    String EmpKid = prefs.getString('EmpKid') ?? '';

    String _Claimrequestidd = _Claimrequestid.toString();

    String dateRange = _dateRange.toString();

    // Function to calculate the number of days
    int calculateDaysDifference(String range) {
      // Split the string into two dates
      List<String> dates = range.split("To").map((e) => e.trim()).toList();

      // Parse the dates into DateTime objects
      DateTime startDate = DateTime.parse(
          "${dates[0].substring(6)}-${dates[0].substring(3, 5)}-${dates[0].substring(0, 2)}");
      DateTime endDate = DateTime.parse(
          "${dates[1].substring(6)}-${dates[1].substring(3, 5)}-${dates[1].substring(0, 2)}");

      // Calculate the difference in days
      return endDate.difference(startDate).inDays;
    }

    int daysDifference = calculateDaysDifference(dateRange);
    List<String> dates = dateRange.split('To').map((e) => e.trim()).toList();

    // Extract start and end dates
    String startDatee = dates[0]; // "01/05/2024"
    String endDatee = dates[1]; // "08/05/2024"

    DateTime startDateTime = DateTime.parse(
      "${startDatee.split('/')[2]}-${startDatee.split('/')[1]}-${startDatee.split('/')[0]}",
    );
    DateTime endDateTime = DateTime.parse(
      "${endDatee.split('/')[2]}-${endDatee.split('/')[1]}-${endDatee.split('/')[0]}",
    );

    // Convert DateTime to String in 'yyyy-MM-dd' format
    String formattedStartDate = startDateTime.toIso8601String().split('T')[0];
    String formattedEndDate = endDateTime.toIso8601String().split('T')[0];

    // //7~11.37~2024-05-01~2024-05-08"
    // 7~11.37~2024-05-01~2024-05-08

    String DAte = daysDifference.toString() +
        "~" +
        "11.37" +
        "~" +
        formattedStartDate.toString() +
        "~" +
        formattedEndDate.toString();
    String code = _Claimrequestid.toString();
    List<String> parts = code.split('/');
    String? DataFile;
    String? Filedate;

    // Extract parts
    String beforeSlash = parts[0]; // "Trv607"
    String jsonData = json.encode(widget.journeylist);
    String jsonDataaa = json.encode(widget.boardginglist);
    String jsonDataa = json.encode(widget.locallist);
    String jsonDataaaa = json.encode(widget.otherlist);
    DataFile = json.encode(widget.UploadDataFile);
    String empKidd = prefs.getString('EmpKid') ?? '';

    // if (DataFile == "[]") {
    //   Filedate = null;
    // } else {
    //   Filedate = DataFile.toString();
    // }

    // Remove the first 3 letters
    String TravelID = beforeSlash.substring(3);

    Map<String, dynamic> combinedData = {
      'EmpID': empKidd.toString(),
      'Journey': jsonData,
      'BoardData': jsonDataaa,
      'OthExpdata': jsonDataaaa,
      'LocalConData': jsonDataa,
      'travelClaim': DataFile,
      'HigherClass': "<HigherCls></HigherCls>",
      'ConnectTrav': "<Connect></Connect>",
      'Remark': _REMARKS.text,
      'TrvId': TravelID.toString(),
      'DaAmt': _DAAmount.text,
      'JourneyTot': _journeyfaretotal.text,
      'boardTot': _BoardintTotal.text,
      'HigherClsTot': "0",
      'TrainDataTot': "0",
      'OthTotal': _OtherTotal.text,
      'LocalConTot': _LoackToatl.text,
      'ClaimParaID': ClaimParaID.toString(),
      'AdvanceID': '0',
      'NoOfDays': DAte.toString(),
      'ContiHalt': 'N',
      'MaxNoOfDay4Halt': '0'
    };

    // Convert the Journey object to JSON
    String jsons = json.encode(combinedData);

    // Send the JSON to the API using HTTP method
    try {
      //await EasyLoading.show(status: 'Loading...');
      var url = Uri.parse(
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/Mobile/TravelclaimReq.ashx');

      var response = await http.post(url,
          body: jsons,
          headers: {'Content-Type': 'application/json'},
          encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await EasyLoading.dismiss();

        // Assuming the response is a list and extracting the message
        final msg = responseData[0]['Msg'];
        Success_Alert_DialogBox.showAlert(context, msg);

        setState(() {
          String _message = msg;
        });
      }
    } catch (e) {
      await EasyLoading.dismiss();
      Alert_DialogBox.showAlert(context, "Server Error");
      print("Error: $e");
    }
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      DepartureStartpoint = prefs.getString("_DepartureStartpoint") ?? '';
      DepartureEndpoint = prefs.getString("_DepartureEndpoint") ?? '';
      BasicFair = prefs.getString("_BasicFair") ?? '';
      distance = prefs.getString("_distance") ?? '';
      PurposeRemark = prefs.getString("_PurposeRemark") ?? '';
      ArrivalTime = prefs.getString("_ArrivalTime") ?? '';
      _DepartureTime = prefs.getString("_DepartureTime") ?? '';
      LabelTextField = prefs.getString("LabelTextField") ?? '';
      PurPoseKid = prefs.getString("PurPoseKid") ?? '';
      _NameHotel = prefs.getString("_NameHotel") ?? '';
      _lodgingcharged = prefs.getString("_lodgingcharged") ?? '';
      _foodbillamount = prefs.getString("_foodbillamount") ?? '';
      _amountwithouttax = prefs.getString("_amountwithouttax") ?? '';
      HotelTypeKid = prefs.getString("HotelTypeKid") ?? '';
      _LocalexpenseRemarks = prefs.getString("_LocalexpenseRemarks") ?? '';
      _localamount = prefs.getString("_localamount") ?? '';
      _OtherexpenseRemarks = prefs.getString("_OtherexpenseRemarks") ?? '';
      _Otheramount = prefs.getString("_Otheramount") ?? '';
      LocalTravelMode = prefs.getString("LocalTravelMode") ?? '';
      LocalConvencyStartDate = prefs.getString("_LocalConvencyStartDate") ?? '';
      LocalConvencyEndDate = prefs.getString("_LocalConvencyEndDate") ?? '';
      OtherStartDate = prefs.getString("_OtherStartDate") ?? '';
      OtherEndDate = prefs.getString("_OtherEndDate") ?? '';
      LocalConvencyTaxDate = prefs.getString("_LocalConvencyTaxDate") ?? '';
      OthertaxDate = prefs.getString("_OthertaxDate") ?? '';
      DepartureDate = prefs.getString("_DepartureDate") ?? '';
      ArrivalDate = prefs.getString("_ArrivalDate") ?? '';
      BoardgingFromDate = prefs.getString("_BoardgingFromDate") ?? '';
      BoardgingTodate = prefs.getString("_BoardgingTodate") ?? '';
      DepartureTaxDate = prefs.getString("_DepartureTaxDate") ?? '';
      BoardgonfTaxDate = prefs.getString("_BoardgonfTaxDate") ?? '';
      _Claimrequestid = prefs.getString("_Claimrequestid") ?? '';
      _dateRange = prefs.getString("_dateRange") ?? '';
      ClaimParaID = prefs.getString("_ClaimParaID") ?? '';
      JourneyTotalTax = prefs.getString("JourneyTotalTax") ?? '';
      _BoardgingTotaltax = prefs.getString("_BoardgingTotaltax") ?? '';
      _LocalTotalTax = prefs.getString("_LocalTotalTax") ?? '';
      _OtherTotalTax = prefs.getString("_OtherTotalTax") ?? '';
      _daAmount = prefs.getString("_OtherTotalTax") ?? '';

      _journeyfaretotal.text = JourneyTotalTax.toString();
      _BoardintTotal.text = _BoardgingTotaltax.toString();
      _LoackToatl.text = _LocalTotalTax.toString();
      _OtherTotal.text = _OtherTotalTax.toString();
      _DAAmount.text = _daAmount.toString();
      calculateTotal();
      // double basicFair = double.parse(BasicFair.toString());
      // double amountWithoutTax = double.parse(_amountwithouttax.toString());
      // double localAmount = double.parse(_localamount.toString());
      // double otherAmount = double.parse(_Otheramount.toString());
      // double total = basicFair + amountWithoutTax + localAmount + otherAmount;
      // _Total.text = total.toString();

      // prefs.setString("_ClaimParaID", _ClaimParaID);
    });
  }

  void calculateTotal() {
    // Parse all the string values into double
    double journeyFareTotal = double.tryParse(_journeyfaretotal.text) ?? 0.0;
    double boardingTotal = double.tryParse(_BoardintTotal.text) ?? 0.0;
    double localTotal = double.tryParse(_LoackToatl.text) ?? 0.0;
    double otherTotal = double.tryParse(_OtherTotal.text) ?? 0.0;
    double daAmount = double.tryParse(_DAAmount.text) ?? 0.0;

    // Add all the values
    double totalAmount =
        journeyFareTotal + boardingTotal + localTotal + otherTotal + daAmount;

    // Display the total in a TextField or use it as needed
    setState(() {
      _Total.text =
          totalAmount.toStringAsFixed(2); // Display with 2 decimal places
    });

    print("Total Amount: $totalAmount");
  }

  String? DepartureTaxDate;
  String? BoardgonfTaxDate;
  String? _dateRange;
  String? _OtherTotalTax;
  String? _LocalTotalTax;
  String? _BoardgingTotaltax;
  String? JourneyTotalTax;

  String? _Claimrequestid;
  String? DepartureDate;
  String? OthertaxDate;
  String? LocalTravelMode;
  String? ArrivalDate;
  String? BoardgingFromDate;
  String? BoardgingTodate;
  String? LocalConvencyStartDate;
  String? LocalConvencyEndDate;
  String? OtherStartDate;
  String? OtherEndDate;
  String? LocalConvencyTaxDate;
  String? DepartureStartpoint;
  String? DepartureEndpoint;
  String? BasicFair;
  String? distance;
  String? PurposeRemark;
  String? ArrivalTime;
  String? _DepartureTime;
  String? LabelTextField;
  String? PurPoseKid;
  String? _NameHotel;
  String? _lodgingcharged;
  String? _foodbillamount;
  String? HotelTypeKid;
  String? _amountwithouttax;
  String? _LocalexpenseRemarks;
  String? _localamount;
  String? _OtherexpenseRemarks;
  String? _Otheramount;
  String? ClaimParaID;
  String? _daAmount;

  TextEditingController _REMARKS = new TextEditingController();
  TextEditingController _journeyfaretotal = new TextEditingController();
  TextEditingController _BoardintTotal = new TextEditingController();
  TextEditingController _LoackToatl = new TextEditingController();
  TextEditingController _DAAmount = new TextEditingController();
  TextEditingController _Total = new TextEditingController();
  TextEditingController _OtherTotal = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    double _getButtonFontSize(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 600) {
        return 14.0; // Large screen
      } else if (screenWidth > 400) {
        return 15.0; // Medium screen
      } else {
        return 16.0; // Default size
      }
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    "Claim Summary",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blue,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TravelClaimThird(
                                  JourneyList: [],
                                  BoardgingList: [],
                                )),
                      );
                    },
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    //change your color here
                  ),
                ),
                body: SingleChildScrollView(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      SummartWidgetNot("Journey Fare Total(A)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _journeyfaretotal),
                      SizedBox(
                        height: 10,
                      ),
                      SummartWidgetNot("Boarding/Lodging Total(B)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _BoardintTotal),
                      SummartWidgetNot("Other Expense Total(C)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _OtherTotal),
                      SizedBox(
                        height: 10,
                      ),
                      SummartWidgetNot("Local Conveyance Total(D)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _LoackToatl),
                      SizedBox(
                        height: 10,
                      ),
                      SummartWidgetNot("D.A Amount(E)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _DAAmount),
                      SizedBox(
                        height: 10,
                      ),
                      SummartWidgetNot("Total(A+B+C+D)", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _Total),
                      SizedBox(
                        height: 10,
                      ),
                      SummartEditable("Remarks", (value) {
                        setState(() {
                          purposeDetails = value;
                        });
                      }, controller: _REMARKS),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: DropdownButton<String>(
                      //     isExpanded: true,
                      //     hint: Text("Select Class"),
                      //     items: uniqueValues.entries.map((entry) {
                      //       return DropdownMenuItem<String>(
                      //         value: entry.key,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               entry.key,
                      //               style:
                      //                   TextStyle(fontWeight: FontWeight.bold),
                      //             ),
                      //             Text(entry.value),
                      //           ],
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (value) {
                      //       // Handle dropdown selection change
                      //       print("Selected: $value");
                      //     },
                      //   ),
                      // ),
                      InkWell(
                        onTap: () async {
                          if (_REMARKS.text == null || _REMARKS.text == "") {
                            Alert_DialogBox.showAlert(
                                context, "Please Enter Remarks");
                            return;
                          }

                          sendJourneyData();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 50.0, left: 10.0, right: 10.0, bottom: 10.0),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Add some spacing between the icon and the text

                                  Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _getButtonFontSize(context),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                    ),
                                  ),
                                  // const SizedBox(width: 8),
                                  // Image.asset("assets/images/next.png"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
          );
        }));
  }
}

Widget SummartEditable(String labelText, Function(String) onChanged,
    {bool isEnabled = true,
    String? initialValue,
    required TextEditingController controller}) {
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
          controller: controller,
          enabled: isEnabled,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,

            // Set the color for the input text
          ),
          decoration: InputDecoration(
            hintText: labelText,
          ),
        ),
      ),
    ],
  );
}

Widget SummartWidgetNot(
  String labelText,
  Function(String) onChanged, {
  bool isEnabled = false,
  String? initialValue,
  required TextEditingController controller,
}) {
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
          controller: controller,
          enabled: isEnabled,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.black,

            // Set the color for the input text
          ),
          decoration: InputDecoration(
            hintText: labelText,
          ),
        ),
      ),
    ],
  );
}
