import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Approved.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TravelClaimStatusfirst extends StatefulWidget {
  @override
  _TravelClaimStatusfirst createState() => _TravelClaimStatusfirst();
}

class SalaryEss {
  final String name;

  SalaryEss({required this.name});

  factory SalaryEss.fromJson(Map<String, dynamic> json) {
    return SalaryEss(
      name: json['Name'],
    );
  }
}

class _TravelClaimStatusfirst extends State<TravelClaimStatusfirst> {
  List<TravelRequestID> TravelID = [];
  var ClaimRequestID;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? _Approvalrequestid;
  String? _Approvelname;

  String? _selectedToDate;
  String? _selectedFromDate;
  String? name;

  TextEditingController _ClaimCode = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TravelClaimDashboard()));

        return false;
      },
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.1)),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  "Travel Claim Status",
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
                          builder: (context) => TravelClaimDashboard()),
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField("Claim Code", (value) {
                      setState(() {
                        String purposeDetails = value;
                      });
                    }, controller: _ClaimCode),
                    buildDropdownField<String>(
                        labelText: "Claim Status",
                        items: [
                          "Initate",
                          "Requested",
                          "Rejected",
                          "Approved",
                          "Cancelled"
                        ],
                        selectedItem: _Approvalrequestid,
                        onChanged: (value) {
                          setState(() {
                            _Approvalrequestid = value;
                          });

                          if (_Approvalrequestid == "Initate") {
                            _Approvelname = "I";
                          } else if (_Approvalrequestid == "Requested") {
                            _Approvelname = "R";
                          } else if (_Approvalrequestid == "Rejected") {
                            _Approvelname = "X";
                          } else if (_Approvalrequestid == "Approved") {
                            _Approvelname = "A";
                          } else if (_Approvalrequestid == "Cancelled") {
                            _Approvelname = "C";
                          }
                        },
                        displayText: (Vehicle) => Vehicle),
                    buildDateFields("Claim From Date"),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_selectedFromDate != null) {
                          if (_selectedToDate == null) {
                            Alert_DialogBox.showAlert(
                                context, "Please Select Claim To Date");
                            return;
                          }
                        } else if (_selectedToDate != null) {
                          if (_selectedFromDate == null) {
                            Alert_DialogBox.showAlert(
                                context, "Please Select Claim From Date");
                            return;
                          }
                        } else if (_Approvalrequestid == null ||
                            _Approvalrequestid == "") {
                          _Approvelname = "R";
                          name = "Null";
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TravelClaimApproved(
                                    ClaimCode: _ClaimCode.text,
                                    ClaimStatus: _Approvelname.toString(),
                                    Fromdate: _selectedToDate.toString(),
                                    Todate: _selectedToDate.toString(),
                                    claimstatuss: name.toString())));
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
                              "Search",
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
              )),
        );
      }),
    );
  }

  Widget buildTextField(
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
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
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
          padding: const EdgeInsets.only(right: 10, left: 10),
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
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
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
          ),
        ),
      ],
    );
  }

  Widget buildDateFields(String Name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
              child: Text(
                Name,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                    color: Color(0xFF547EC8)),
              ),
            ),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedFromDate = pickedDate;
                  });

                  List<String> splitDte =
                      selectedFromDate.toString().split(" ");

                  _selectedFromDate = splitDte[0];
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 5,
                ),
                child: Container(
                  width: 150,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    selectedFromDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedFromDate!)
                        : 'Select Date',
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Claim To Date",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedToDate = pickedDate;
                  });

                  List<String> splitDte = selectedToDate.toString().split(" ");

                  _selectedToDate = splitDte[0];
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: Container(
                  width: 150,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    selectedToDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedToDate!)
                        : 'Select Date',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "TimesNewRoman"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //////  API Intergration   ///////////

  Future<void> _TravelRequestID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String EmpKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=claimrequestid' +
              '&empkid=' +
              "15744";

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        await EasyLoading.dismiss();
        setState(() {
          TravelID =
              jsonData.map((data) => TravelRequestID.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      await EasyLoading.dismiss();
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class TravelRequestID {
  final String Requestid;

  TravelRequestID({
    required this.Requestid,
  });

  factory TravelRequestID.fromJson(Map<String, dynamic> json) {
    return TravelRequestID(Requestid: json['Code']);
  }
}
