// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:ehr/app.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/LeaveCancel.dart';
import 'package:ehr/Dashboard/LeaveDashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leavecancelbyemployee extends StatefulWidget {
  @override
  final String backDate;

  Leavecancelbyemployee({required this.backDate});
  _LeavecancelbyemployeeState createState() => _LeavecancelbyemployeeState();
}

class _LeavecancelbyemployeeState extends State<Leavecancelbyemployee> {
  TextEditingController lveTypeController = TextEditingController();
  TextEditingController totalDaysController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  bool RtnVal = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String selectedFromDateStatus = "Full Day";
  String selectedToDateStatus = "Full Day";
  String dayStatus = "F";
  String dayStatusFromDay = "F";

  @override
  void initState() {
    super.initState();
    onGetList();
  }

  Future<void> onGetList() async {
    try {
      String parts = widget.backDate.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String managerID = prefs.getString('ManagerID') ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveCancel&empcode=$userId&RequestID=$parts';

      var response = await http.get(Uri.parse(restUrl));
      var content = jsonDecode(response.body);

      setState(() {
        for (var item in content) {
          lveTypeController.text = item['LeaveName'];
          startDate = DateFormat("dd/MM/yyyy").parse(item['FromDate']);
          prefs.setString('FromDateStatus', item['FromDateStatus']);
          selectedFromDateStatus = prefs.getString('FromDateStatus') == 'F'
              ? 'Full Day'
              : 'Half Day';
          endDate = DateFormat("dd/MM/yyyy").parse(item['ToDate']);
          prefs.setString('ToDateStatus', item['ToDateStatus']);
          selectedToDateStatus =
              prefs.getString('ToDateStatus') == 'F' ? 'Full Day' : 'Half Day';
          totalDaysController.text = item['LeaveApproved'].toString();
          reasonController.text = item['ReasonEng'];
//prefs.setString('Empid', item['EmpID']).toString();
        }
      });
    } catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Alert",
              style: TextStyle(fontFamily: "TimesNewRoman"),
            ),
            content: const Text(
              "Unable to Connect to the Server",
              style: TextStyle(fontFamily: "TimesNewRoman"),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(fontFamily: "TimesNewRoman"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      log("ERROR ${ex.toString()}");
    }
  }

  Future<void> changeEvent() async {
    RtnVal = false;
    if (startDate.isAfter(endDate)) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "GSTN_HRMS",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          content: const Text(
            "To Date must be greater than or equal to From Date",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
            ),
          ],
        ),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String managerID = prefs.getString('ManagerID') ?? '';

      String dayStatus = selectedFromDateStatus == "Full Day" ? "F" : "H";
      String dayStatusFromDay = selectedToDateStatus == "Full Day" ? "F" : "H";

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=LeaveCalc&empcode=$userId&leaveCode=your_leave_code&FromDate=${DateFormat('dd/MM/yyyy').format(startDate)}&FromDateStatus=$dayStatus&ToDate=${DateFormat('dd/MM/yyyy').format(endDate)}&ToDateStatus=$dayStatusFromDay';

      var response = await http.get(Uri.parse(restUrl.replaceAll(" ", "")));

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        List<dynamic> trends = content;
        prefs.setString('Column1', trends[0]['Column1']);
        prefs.setString('Column2', trends[0]['Column2']);
        prefs.setString('Column3', trends[0]['Column3']);
        prefs.setString('Column4', trends[0]['Column4']);
        prefs.setString('Column5', trends[0]['Column5']);
        prefs.setString('Column6', trends[0]['Column6']);
        prefs.setString('Column7', trends[0]['Column7']);
        prefs.setString('Column8', trends[0]['Column8']);
        prefs.setString('LeaveBehaveCode', trends[0]['LeaveBehaveCode']);
        prefs.setString('Column9', trends[0]['Column9']);
        prefs.setString('levPara', trends[0]['levPara']);
        prefs.setString('DocReq', trends[0]['DocReq']);
        prefs.setString('Payable', trends[0]['Payable']);
        prefs.setString('ApprovalLevel', trends[0]['ApprovalLevel']);

        String alertmsg = "";
        String hdnlevbehaviorid = prefs.getString('Column8') ?? "";
        String hdnlevpara = prefs.getString('levPara') ?? "";

        String returnval =
            '${trends[0]['Column1']}~${trends[0]['Column4']}~${trends[0]['Column5']}~${trends[0]['Column7']}~${trends[0]['Column8']}~${trends[0]['LeaveBehaveCode']}';

        if (double.parse(trends[0]['Column1']) > 0) {
          prefs.setString('Column1', trends[0]['Column1']);
          totalDaysController.text = prefs.getString('Column1') ?? "";
          RtnVal = true;
        } else {
          showErrorMsg(returnval, alertmsg);
          totalDaysController.clear();
        }
      }
    } catch (ex) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          content: const Text(
            "Unable to Connect to the Server",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
            ),
          ],
        ),
      );
      print("ERROR ${ex.toString()}");
    }
  }

  Future<void> showErrorMsg(String errorType, String msg) async {
    List<String> strError = errorType.split('~');

    if (msg.isEmpty) {
      switch (int.parse(strError[0])) {
        case 0:
          msg = "You don't have leave balance of selected leave!!";
          break;
        case -10:
          msg =
              "Selected leave type definition is not available in system, so you cannot take selected leave!!";
          break;
        case -100:
          msg = "You already applied for leave for this period";
          break;
        case -200:
          msg = "You cannot take more leave in this year of this type!!";
          break;
        case -300:
          msg = "There is already a holiday on entered date(s)!!";
          break;
        case -400:
          msg = "You don't have sufficient leave!!!";
          break;
        case -500:
          msg = "You have to take minimum ${strError[1]} continuous leave. !!!";
          break;
        case -600:
          msg = "You can take maximum ${strError[2]} continuous leave. !!!";
          break;
        case -700:
          msg =
              "You cannot take this leave in combination with previously taken leave!!";
          break;
        case -800:
          msg = "You can't take RH on the specified date!!";
          break;
        case -900:
          msg =
              "This leave can be availed after ${strError[4]} month(s) of joining";
          break;
        case -111:
          msg = "Selected leave type is not applicable for you";
          break;
        case -112:
          msg = "Max leave in entire service limit exceeded.";
          break;
        case -113:
          msg = "Continuous leave limit exceeded.";
          break;
        case -114:
        case -1114:
        case -1115:
          msg = "Wrong lapse date.";
          break;
        case -116:
        case -117:
          msg = "Number of children limit exceeded";
          break;
        case -118:
        case -119:
        case -12000:
        case -12001:
          msg = msg.replaceAll("'", "");
          break;
        case -1001:
          msg =
              "Transfer is on your request, so you cannot take selected leave!!";
          break;
      }
    }

    if (msg.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          content: Text(
            msg,
            style: const TextStyle(fontFamily: "TimesNewRoman"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
            ),
          ],
        ),
      );
    }

    if (double.parse(strError[0]) > 0) {
      // Additional logic if needed
    }
  }

  void onDateSelected(DateTime date) {
    setState(() {
      startDate = date;
    });
  }

  void onEndDateSelected(DateTime date) {
    setState(() {
      endDate = date;
      if (endDate.isBefore(startDate)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "GSTN_HRMS",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              content: const Text(
                "To Date must be greater than or equal to From Date",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(fontFamily: "TimesNewRoman"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      changeEvent();
    });
  }

  void onPickerSelectFromDay(String value) {
    setState(() {
      selectedFromDateStatus = value;
      dayStatus = value == "Full Day" ? "F" : "H";
      changeEvent();
    });
  }

  void onPickerSelectToDay(String value) {
    setState(() {
      selectedToDateStatus = value;
      dayStatusFromDay = value == "Full Day" ? "F" : "H";
      changeEvent();
    });
  }

  Future<void> buttonClickedProceed() async {
    try {
      if (remarkController.text == null || remarkController.text == "") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(fontFamily: "TimesNewRoman"),
            ),
            content: const Text(
              'Please enter the Cancellation reason or Remark',
              style: TextStyle(fontFamily: "TimesNewRoman"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontFamily: "TimesNewRoman"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }
      await EasyLoading.show(status: 'Loading...');
      String partss = widget.backDate.toString();
      String remark = remarkController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String managerID = prefs.getString('ManagerID') ?? '';
      String dayStatus = selectedFromDateStatus == "Full Day" ? "F" : "H";
      String dayStatusFromDay = selectedToDateStatus == "Full Day" ? "F" : "H";

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=LeaveCancelRequeat&empcode=$userId&RequestID=$partss&canreason=$remark&FromDate=${DateFormat('dd/MM/yyyy').format(startDate)}&FromDateStatus=$dayStatus&ToDate=${DateFormat('dd/MM/yyyy').format(endDate)}&ToDateStatus=$dayStatusFromDay';

      var response = await http.get(Uri.parse(restUrl.replaceAll(" ", "")));

      if (response.statusCode == 200) {
        String content = response.body;
        if (content == "Message:saved succesfully") {
          await EasyLoading.dismiss();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              content: const Text(
                "Leave Cancelled Successfully",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Leavedashboard()));
                    // Navigator.pushNamed(context, '/dashboard');
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontFamily: "TimesNewRoman"),
                  ),
                ),
              ],
            ),
          );
        } else {
          throw Exception("Leave cancellation failed.");
        }
      } else {
        throw Exception("Failed to request leave cancellation.");
      }
    } catch (ex) {
      await EasyLoading.dismiss();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          content: const Text(
            "Unable to Connect to the Server",
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
            ),
          ],
        ),
      );
      print("ERROR ${ex.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Leave Cancel",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Leavedashboard()));
              },
            ),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Leave Type',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                TextField(
                  controller: lveTypeController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Leave Type',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'From Date',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != startDate) {
                            onDateSelected(picked);
                          }
                        },
                        controller: TextEditingController(
                            text: "${startDate.toLocal()}".split(' ')[0]),
                        decoration: const InputDecoration(
                          hintText: 'Select Date',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontFamily: "TimesNewRoman",
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "TimesNewRoman",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedFromDateStatus,
                        onChanged: null,
                        // onChanged: (value) {
                        //   onPickerSelectFromDay(value.toString());
                        // },
                        items: ['Full Day', 'Half Day']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: "TimesNewRoman",
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          enabled: false, // Disable the dropdown
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'To Date',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != endDate) {
                            onEndDateSelected(picked);
                          }
                        },
                        controller: TextEditingController(
                            text: "${endDate.toLocal()}".split(' ')[0]),
                        decoration: const InputDecoration(
                          hintText: 'Select Date',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontFamily: "TimesNewRoman",
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "TimesNewRoman",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedToDateStatus,
                        onChanged: null,
                        // onChanged: (value) {
                        //   onPickerSelectToDay(value.toString());
                        // },
                        items: ['Full Day', 'Half Day']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: "TimesNewRoman",
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          enabled: false, // Disable the dropdown
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Total Days',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                TextField(
                  controller: totalDaysController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Total Days',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reason',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                TextField(
                  controller: reasonController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter Reason',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Remark',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                TextField(
                  controller: remarkController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Remark',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      buttonClickedProceed();
                      // Implement the proceed button functionality
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: "TimesNewRoman",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
