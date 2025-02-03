import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TravelClaimFirst extends StatefulWidget {
  @override
  _TravelClaimFirst createState() => _TravelClaimFirst();
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

class _TravelClaimFirst extends State<TravelClaimFirst> {
  List<TravelRequestID> TravelID = [];
  var ClaimRequestID;
  String Claimrequestid = "";

  @override
  void initState() {
    super.initState();
    _TravelRequestID();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));

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
                  "Travel Claim Request",
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
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Travel Request ID",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                color: Color(0xFF547EC8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          child: DropdownButton<TravelRequestID>(
                              value: ClaimRequestID,
                              hint: const Text(
                                'Select Travel Request ID',
                                style: TextStyle(
                                  fontFamily: "TimesNewRoman",
                                  color: Color(0xFF898989),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  ClaimRequestID = newValue!;
                                });
                                Claimrequestid = newValue!.Requestid.toString();
                              },
                              items: TravelID.map((TravelRequestID obj) {
                                return DropdownMenuItem<TravelRequestID>(
                                  value: obj,
                                  child: Builder(builder: (context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler: TextScaler.linear(1.1)),
                                      child: Text(
                                        obj.Requestid,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        prefs.setString("Claimrequestid", Claimrequestid);
                        if (ClaimRequestID == null || ClaimRequestID == "") {
                          _showAlertDialog("Alert",
                              "Please Select a travel request ID to Generate Travel Claim");
                          return;
                        }

                        SubmitAPI();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Create Claim",
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

  //////  API Intergration   ///////////

  Future<void> SubmitAPI() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String EmpKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=employeedetails' +
              '&empId=' +
              EmpKid.toString() +
              "&trvid=" +
              Claimrequestid.toString();
      //"&trvid=Trv3631/240501-240508";

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        await EasyLoading.dismiss();
        List<dynamic> jsonData = jsonDecode(response.body);
        var employee = jsonData[0];
        String _ClaimParaID = employee['ClaimParaID'].toString();
        String employeeName = employee['Employee Name'];
        String designation = employee['Designation'];
        String employeeNo = employee['Employee No.'];
        String departmentWing = employee['DepartmentWing'];
        String managerName = employee['Manager Name'];
        String travelRequestID = employee['Travel Request ID'];
        String dateRange = employee['Date Range'];
        String claimStatus = employee['Travelrequest Status'];
        String destination = employee['Destination'];
        String gradepay = employee['Gradepay'].toString();
        String cityClass = employee['CityClass'];
        String mailAddress = employee['MailAddress'];
        String maxEligibleAmount = employee['Max Eligible Amount'].toString();
        int daAmount = employee['DAAmount'];
        String daParaReq = employee['DAParaReq'];
        String daAllowance = employee['DA_Allowance'].toString();
        String hotelAmount = employee['Hotel_Amount'].toString();
        String haParaReq = employee['HAParaReq'].toString();
        String taxiAmount = employee['TAXIAmount'].toString();
        String taParaReq = employee['TAParaReq'].toString();

        final prefs = await SharedPreferences.getInstance();
        prefs.setString("_ClaimParaID", _ClaimParaID.toString().trim());
        prefs.setString("_employeeName", employeeName.trim());
        prefs.setString("_designation", designation.trim());
        prefs.setString("_employeeNo", employeeNo.trim());
        prefs.setString("_departmentWing", departmentWing.trim());
        prefs.setString("_managerName", managerName.trim());
        prefs.setString("_travelRequestID", travelRequestID.trim());
        prefs.setString("_dateRange", dateRange.trim());
        prefs.setString("_claimStatus", claimStatus.trim());
        prefs.setString("_destination", destination.trim());
        prefs.setString("_gradepay", gradepay.trim());
        prefs.setString("_cityClass", cityClass.trim());
        prefs.setString("_mailAddress", mailAddress.trim());
        prefs.setString("_maxEligibleAmount", maxEligibleAmount.trim());
        prefs.setString("_daParaReq", daParaReq.toString().trim());
        prefs.setString("_daAllowance", daAllowance.toString().trim());
        prefs.setString("_hotelAmount", hotelAmount.toString().trim());
        prefs.setString("_haParaReq", haParaReq.toString().trim());
        prefs.setString("_taxiAmount", taxiAmount.toString().trim());
        prefs.setString("_taParaReq", taParaReq.toString().trim());
        prefs.setString('_Claimrequestid', Claimrequestid.toString().trim());
        prefs.setString('_daAmount', daAmount.toString().trim());

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TravelClaimDetails()));

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
      _showAlertDialog("Alert", "No Data Available");
    }
  }

  Future<void> _TravelRequestID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String EmpKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=claimrequestid' +
              '&empkid=' +
              EmpKid.toString();

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        try {
          List<dynamic> jsonData = jsonDecode(response.body);
          await EasyLoading.dismiss();
          setState(() {
            TravelID =
                jsonData.map((data) => TravelRequestID.fromJson(data)).toList();
          });
        } catch (e) {
          await EasyLoading.dismiss();
          setState(() {});

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
                      "No Data Available",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TravelClaimDashboard()));
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
      } else {
        await EasyLoading.dismiss();
        _showAlertDialog("Alert", "Unable to Connect to the Server");
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
