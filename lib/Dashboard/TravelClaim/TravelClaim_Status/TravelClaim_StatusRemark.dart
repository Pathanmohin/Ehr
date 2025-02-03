import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Successalertbox.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TravelClaimRemark extends StatefulWidget {
  final String Remark;

  TravelClaimRemark({super.key, required this.Remark});
  @override
  _TravelClaimRemark createState() => _TravelClaimRemark();
}

class _TravelClaimRemark extends State<TravelClaimRemark> {
  TextEditingController _Remarkk = new TextEditingController();
  @override
  void initState() {
    super.initState();
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
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remark",
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
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextFormField(
                          controller: _Remarkk,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black, fontSize: 15

                              // Set the color for the input text
                              ),
                          decoration: InputDecoration(
                            hintText: "Remark",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        _TravelClaimCancel();
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
                              "Submit",
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

  Future<void> _TravelClaimCancel() async {
    try {
      if (_Remarkk.text == null || _Remarkk.text.toString() == "") {
        Alert_DialogBox.showAlert(context, "Please Enter Remarks");
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String EmpKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=cancelclaim' +
              '&travelclaimid=' +
              widget.Remark +
              '&remark=' +
              _Remarkk.text;

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        String messagee = jsonData[0]['Column2'];
        await EasyLoading.dismiss();

        Success_Alert_DialogBox.showAlert(context, jsonData[0]['Column2']);
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      await EasyLoading.dismiss();
      Alert_DialogBox.showAlert(context, "Server Error");
    }
  }
}

//////  API Intergration   ///////////

