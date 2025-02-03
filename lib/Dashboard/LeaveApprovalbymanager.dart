import 'dart:convert';
import 'package:ehr/Dashboard/LeaveApprovalPage.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Leaveapprovalbymanager extends StatefulWidget {
  @override
  _LeaveapprovalbymanagerState createState() => _LeaveapprovalbymanagerState();
}

class _LeaveapprovalbymanagerState extends State<Leaveapprovalbymanager> {
  List<LeaveApproval> leaveApprovals = [];

  @override
  void initState() {
    super.initState();
    fetchLeaveApprovalList();
  }

  Future<void> fetchLeaveApprovalList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();

    String userId = prefs.getString("userID") ?? '';
    String empKid = prefs.getString('EmpKid') ?? '';

    final String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveAuthList&empcode=$userId';

    final response = await http.get(Uri.parse(restUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        leaveApprovals = List<LeaveApproval>.from(
            data.map((item) => LeaveApproval.fromJson(item)));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: leaveApprovals.length,
          itemBuilder: (context, index) {
            final item = leaveApprovals[index];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: const Color(0xFFF6F6F6),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('Name:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          Text(item.empName.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          const Text('Leave Type:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF547EC8))),
                          Text(item.code.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('Start Date:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          //  SizedBox(width: 30,),
                          Text(item.start.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          // SizedBox(width: 63,),
                          const Text('End Date:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF547EC8))),
                          // SizedBox(width: 12,),
                          Text(item.end.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('Status:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          Text(item.leaveRequestType.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  color: Color(0xFF547EC8))),
                          const Text('Action:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "TimesnewRoman",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF547EC8))),
                          GestureDetector(
                            onTap: () => _view(item),
                            child: const Text(
                              "View",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "TimesnewRoman",
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _view(LeaveApproval item) {
    try {
      Navigator.pop(context); // Close the current modal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeaveApprovalPage(
            backDate: item.levRequestKid.toString(),
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}

class LeaveApproval {
  int? srNo;
  int? levRequestKid;
  String? empJoinEmpNo;
  String? empName;
  double levRequestNoOfDays;
  String? start;
  String? end;
  String? type;
  String? code;
  String? category;
  String? wantLTC;
  int? leaveRequestRefID;
  String? leaveRequestType;

  LeaveApproval({
    required this.srNo,
    required this.levRequestKid,
    required this.empJoinEmpNo,
    required this.empName,
    required this.levRequestNoOfDays,
    required this.start,
    required this.end,
    required this.type,
    required this.code,
    required this.category,
    required this.wantLTC,
    required this.leaveRequestRefID,
    required this.leaveRequestType,
  });

  factory LeaveApproval.fromJson(Map<String, dynamic> json) {
    return LeaveApproval(
      srNo: json['SrNo'],
      levRequestKid: json['levRequest_Kid'],
      empJoinEmpNo: json['empJoin_empNo'] as String?,
      empName: json['EmpName'] as String?,
      levRequestNoOfDays: json['levRequest_NoOfDays'],
      start: json['Start'] as String?,
      end: json['End'] as String?,
      type: json['type'] as String?,
      code: json['code'] as String?,
      category: json['Category'] as String?,
      wantLTC: json['WantLTC'] as String?,
      leaveRequestRefID: json['LeaveRequest_RefID'],
      leaveRequestType: json['leaveRequest_type'] as String?,
    );
  }

  static List<LeaveApproval> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LeaveApproval.fromJson(json)).toList();
  }
}
