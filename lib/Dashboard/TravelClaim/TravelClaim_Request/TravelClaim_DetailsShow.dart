import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_First.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Second.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Model/HotelMode.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TravelClaimDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TravelClaimDetails();
}

class _TravelClaimDetails extends State<TravelClaimDetails> {
  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TravelClaimFirst()),
    );

    // Prevent the default back button behavior
    return false;
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeName = prefs.getString("_employeeName") ?? '';
      _designation = prefs.getString("_designation") ?? '';
      _employeeNo = prefs.getString("_employeeNo") ?? '';
      _departmentWing = prefs.getString("_departmentWing") ?? '';
      _managerName = prefs.getString("_managerName") ?? '';
      _travelRequestID = prefs.getString("_travelRequestID") ?? '';
      _claimStatus = prefs.getString("_claimStatus") ?? '';
      _destination = prefs.getString("_destination") ?? '';
      _gradepay = prefs.getString("_gradepay") ?? '';
      _cityClass = prefs.getString("_cityClass") ?? '';
      _mailAddress = prefs.getString("_mailAddress") ?? '';
      _maxEligibleAmount = prefs.getString("_maxEligibleAmount") ?? '';
      _dateRange = prefs.getString("_dateRange") ?? '';
      //_gradepay = prefs.getString("_gradepay") ?? '';
    });
  }

  String _managerName = "";
  String _designation = "";
  String _employeeName = "";
  String _departmentWing = "";
  String _employeeNo = "";
  String _travelRequestID = "";
  String _destination = "";
  String _claimStatus = "";
  String _gradepay = "";
  String _cityClass = "";
  String _mailAddress = "";
  String _maxEligibleAmount = "";
  String _dateRange = "";
  List<travelmodes> fromAccountList = <travelmodes>[];

  // prefs.setString("", cityClass);
  // prefs.setString("_mailAddress", mailAddress);
  // prefs.setString("_maxEligibleAmount", maxEligibleAmount);
  // prefs.setString("_daParaReq", daParaReq.toString());
  // prefs.setString("_daAllowance", daAllowance.toString());
  // prefs.setString("_hotelAmount", hotelAmount.toString());
  // prefs.setString("_haParaReq", haParaReq.toString());
  // prefs.setString("_taxiAmount", taxiAmount.toString());
  // prefs.setString("_taParaReq", taParaReq.toString());

  @override
  void initState() {
    super.initState();
    dataFound();
  }

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
                  title: const Text(
                    "Travel Claim Request",
                    style: TextStyle(
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
                            builder: (context) => TravelClaimFirst()),
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
                      Labe("Employee Name", _employeeName),
                      Labe("Designation", _designation),
                      Labe("Employee No", _employeeNo),
                      Labe("DepartmentWing", _departmentWing),
                      Labe("Manager Name", _managerName),
                      Labe("Travel Request ID", _travelRequestID),
                      Labe("Date Range", _dateRange),
                      Labe("Claim Status", _claimStatus),
                      Labe("Destination", _destination),
                      Labe("Grade Pay", _gradepay),
                      Labe("Travel City Class", _cityClass),
                      Labe("Max Eligible Amount", _maxEligibleAmount),
                      Labe("Mail Address", _mailAddress),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TravelClaimSecond()));
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
                                    "Next",
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

  Future<void> _TravelMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_TravelMode';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // List<dynamic> jsonResponse = jsonDecode(responseData["data"]);

        int all = 0;
        for (var config in jsonData) {
          travelmodes vObject = new travelmodes();

          vObject.kid = config["kid"];
          vObject.value = config["value"];
          vObject.text = config["text"];

          fromAccountList.add(vObject);
        }
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      Alert_DialogBox.showAlert(context, "Unable to Connect to the Server");
    }
  }
}

Widget Labe(String First_label, String Second_Label) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(First_label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontFamily: "TimesNewRoman",
              )),
        ),
        Flexible(
          child: Text(
            Second_Label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: "TimesNewRoman",
            ),
          ),
        )
      ],
    ),
  );
}
