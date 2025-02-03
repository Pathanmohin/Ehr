// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'dart:convert';
import 'package:ehr/Dashboard/LeaveDashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeaveApprovalPage extends StatefulWidget {
  final String backDate;

  const LeaveApprovalPage({super.key, required this.backDate});

  @override
  _LeaveApprovalPageState createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  String leaveType = '';
  String? startDate;
  String? fromDateStatus;
  String? endDate;
  String? toDateStatus;
  double leaveApproved = 0.0;
  String reason = '';
  String approvalparameter = "";
  bool isLoading = true;
  bool isLoadingParameters = true;
  List<String> approvalParameters = [];
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLeaveDetails();
    // _getParameter();
    if (approvalParameters.isNotEmpty) {
      approvalparameter = approvalParameters[0];
    }
  }

  Future<void> _getLeaveDetails() async {
    try {
      String parts = widget.backDate;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveCancel&empcode=$userId&RequestID=$parts';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          var item = data[0];
          setState(() {
            leaveType = item['LeaveName'] ?? '';
            startDate = item['FromDate'] ?? '';
            fromDateStatus = item['FromDateStatus'] ?? '';
            endDate = item['ToDate'] ?? '';
            toDateStatus = item['ToDateStatus'] ?? '';
            leaveApproved =
                double.tryParse(item['LeaveApproved'].toString()) ?? 0.0;
            reason = item['ReasonEng'] ?? '';
            isLoading = false;
          });
        }
        _getParameter();
      } else {
        _showAlert('Unable to connect to the server');
      }
    } catch (e) {
      _showAlert('Unable to connect to the server');
      print('ERROR: $e');
    }
  }

  Future<void> _getParameter() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String parts = widget.backDate;

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveAuthListAction&RequestID=$parts';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ParameterList> parameters =
            data.map((item) => ParameterList.fromJson(item)).toList();

        setState(() {
          approvalParameters = parameters
              .map((p) => '${p.approvalActionFlag}-${p.approvalActionEname}')
              .toList();
          // Remove duplicates if any
          approvalParameters = approvalParameters.toSet().toList();
          isLoadingParameters = false;
          // Initialize approvalparameter with the first item if the list is not empty
          if (approvalParameters.isNotEmpty) {
            approvalparameter = approvalParameters[0];
          }
        });
      } else {
        _showAlert('Unable to connect to the server');
      }
    } catch (e) {
      _showAlert('Unable to connect to the server');
      print('ERROR: $e');
    }
  }

  Future<void> _approveClicked() async {
    try {
      if (remarkController.text.isEmpty) {
        _showAlert('Please enter Remark');
        return;
      }
      await EasyLoading.show(status: 'Loading...');
      String approvalParameter = approvalparameter.toString().split('-')[0];
      String parts = widget.backDate;
      String remark = remarkController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String levKid = prefs.getString("LevKid") ?? '';
      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';
      String managerID = prefs.getString("ManagerID") ?? '';

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=LeaveAuthRejectRequest&RequestID=$parts&leaveStatus=$approvalParameter&empcode=$userId&ManagerId=$managerID&Remark=$remark&empkid=$empKid';

      final response = await http.get(Uri.parse(restUrl));
      await EasyLoading.dismiss();
      if (response.statusCode == 200) {
        String content = response.body;
        List<String> Data = content.split(":");
        String Contecnt = Data[1].trim();

        _showAlertWithCallback(Contecnt, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Leavedashboard()));
        });

        //  if (content == "Message: APPROVE SUCCESFULLY") {
        //   _showAlertWithCallback('Leave Approved Successfully', () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Leavedashboard()));
        //   });

        // } else if (content == "Message: REJECT SUCCESFULLY") {
        //   _showAlertWithCallback('Leave Rejected Successfully', () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Leavedashboard()));
        //   });
        // }
        // else if (content == "Message: RECOMMEND SUCCESFULLY") {
        //   _showAlertWithCallback('Leave Recommed Successfully', () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Leavedashboard()));
        //   });
        // }
        // else {
        //   _showAlert('Leave cancellation failed.');
        // }
      } else {
        _showAlert('Unable to connect to the server');
      }
    } catch (e) {
      _showAlert('Unable to connect to the server');
      print('ERROR: $e');
    }
  }

  void _rejectClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Leavedashboard()),
    );
  }

  void _showAlertWithCallback(String message, VoidCallback callback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alert',
            style: TextStyle(fontFamily: "TimesNewRoman"),
          ),
          content: Text(message,
              style: const TextStyle(fontFamily: "TimesNewRoman")),
          actions: <Widget>[
            TextButton(
              child: const Text('OK',
                  style: TextStyle(fontFamily: "TimesNewRoman")),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlert(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leave Approval",
          style: TextStyle(
              color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildLabel('Leave Type'),
                  _buildTextField(leaveType, isEnabled: false),
                  _buildLabel('From Date'),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: _buildTextField(startDate ?? '',
                              isEnabled: false)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdownButton(
                          'Select Day',
                          ['Full Day', 'Half Day'],
                          selectedValue:
                              fromDateStatus == 'F' ? 'Full Day' : 'Half Day',
                          isEnabled: false,
                        ),
                      ),
                    ],
                  ),
                  _buildLabel('To Date'),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              _buildTextField(endDate ?? '', isEnabled: false)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdownButton(
                          'Select Day',
                          ['Full Day', 'Half Day'],
                          selectedValue:
                              toDateStatus == 'F' ? 'Full Day' : 'Half Day',
                          isEnabled: false,
                        ),
                      ),
                    ],
                  ),
                  _buildLabel('Total Days'),
                  _buildTextField(leaveApproved.toString(), isEnabled: false),
                  _buildLabel('Reason'),
                  _buildTextField(
                    reason,
                    isEnabled: false,
                  ),
                  _buildLabel('Action'),
                  _buildDropdownButton(
                    'Select Action',
                    approvalParameters,
                    selectedValue: approvalparameter,
                    onChanged: (value) {
                      setState(() {
                        approvalparameter = value!;
                      });
                    },
                  ),
                  _buildLabel('Remark'),
                  TextField(
                    controller: remarkController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Remark',
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "TimesNewRoman",
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildButton(
                          'Proceed', Colors.white, Colors.red, _approveClicked),
                      const SizedBox(width: 10),
                      _buildButton('Cancel', Colors.white, Colors.blue, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Leavedashboard()));
                      }),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF547EC8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: "TimesNewRoman",
        ),
      ),
    );
  }

  Widget _buildTextField(String placeholder,
      {bool isEnabled = true, int? maxLength}) {
    return TextField(
      enabled: isEnabled,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontFamily: "TimesNewRoman",
        fontSize: 12,
      ),
    );
  }

  Widget _buildDropdownButton(String hint, List<String> items,
      {String? selectedValue,
      bool isEnabled = true,
      Function(String?)? onChanged}) {
    // Ensure the selected value is valid
    String? validSelectedValue =
        (selectedValue != null && items.contains(selectedValue))
            ? selectedValue
            : null;

    return DropdownButton<String>(
      hint: Text(hint),
      value: validSelectedValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: isEnabled ? onChanged : null,
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: "TimesNewRoman",
        fontSize: 12,
      ),
    );
  }

  Widget _buildButton(String text, Color textColor, Color backgroundColor,
      VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        // side: BorderSide(color: Color(0xFFBD830A), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "TimesNewRoman",
          fontSize: 12,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class ParameterList {
  final String approvalActionFlag;
  final String approvalActionEname;

  ParameterList(
      {required this.approvalActionFlag, required this.approvalActionEname});

  factory ParameterList.fromJson(Map<String, dynamic> json) {
    return ParameterList(
      approvalActionFlag: json['ApprovalAction_Flag'] as String,
      approvalActionEname: json['ApprovalAction_Ename'] as String,
    );
  }
}
