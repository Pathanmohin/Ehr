import 'dart:convert';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Backdateauthorizedmgrpage extends StatefulWidget {
  @override
  _BackdateauthorizedmgrpageState createState() =>
      _BackdateauthorizedmgrpageState();
}

class BackDateDetail {
  String date;
  String remarks;
  String intime;
  String outtime;
  String total;
  int Kid;

  BackDateDetail(
      {required this.date,
      required this.remarks,
      required this.intime,
      required this.outtime,
      required this.total,
      required this.Kid});

  factory BackDateDetail.fromJson(Map<String, dynamic> json) {
    return BackDateDetail(
        date: json['Date'],
        remarks: json['Remarks'],
        intime: json['Intime'],
        outtime: json['outtime'],
        total: json['Total'],
        Kid: json['Kid']);
  }
}

class _BackdateauthorizedmgrpageState extends State<Backdateauthorizedmgrpage> {
  List<BackDateDetail> backdateList = [];
  List<BackDateDetail> selectedItems = [];
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _onGetList();
  }

  Future<void> _onGetList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? backKid = prefs.getString('BackKid');

      ServerDetails serverDetails = ServerDetails();

      if (backKid != null) {
        // Replace with your application name
        String restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceShowApprov&kid=$backKid';

        final response = await http.get(Uri.parse(restUrl));

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<BackDateDetail> fetchedList =
              data.map((json) => BackDateDetail.fromJson(json)).toList();

          setState(() {
            backdateList = fetchedList.map((item) {
              if (item.remarks.contains('~')) {
                List<String> remarks = item.remarks.split('~');
                item.remarks = remarks[1];
                // item.action = remarks[0];
              }
              return item;
            }).toList();
          });
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('BackKid is null');
      }
    } catch (e) {
      print('ERROR: $e');
      _showAlertDialog('Unable to Connect to the Server');
    }
  }

  _showAlertDialog(String message) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
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

  void _checkboxCheckChanged(bool? value, BackDateDetail item) {
    setState(() {
      if (value == true) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }

  Future<void> OnGetListafterAPPROVE() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? backKid = prefs.getString('BackKid');

      ServerDetails serverDetails = ServerDetails();

      if (backKid != null) {
        // Replace with your application name
        String restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceShowApprov&kid=$backKid';

        final response = await http.get(Uri.parse(restUrl));

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<BackDateDetail> fetchedList =
              data.map((json) => BackDateDetail.fromJson(json)).toList();

          setState(() {
            backdateList = fetchedList.map((item) {
              if (item.remarks.contains('~')) {
                List<String> remarks = item.remarks.split('~');
                item.remarks = remarks[1];
                // item.action = remarks[0];
              }
              return item;
            }).toList();
          });
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      } else {
        throw Exception('BackKid is null');
      }
    } catch (e) {
      print('ERROR: $e');
      _showAlertDialog('Unable to Connect to the Server');
    }
  }

  Future<void> _approvedClicked(String Type) async {
    try {
      if (selectedItems.isEmpty) {
        _showAlertDialog("Please select Atleast One Authorize Detail");
        return;
      }
      if (remarkController.text == null || remarkController.text == "") {
        _showAlertDialog("Please Enter Remark");
        return;
      }
      await EasyLoading.show(status: 'Loading...');
      String data = selectedItems.map((item) => item.Kid).join(',');

      final prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();


      // Replace with your application name
      String empId = prefs.getString('EmpKid') ?? '';
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceShowApprovListok&Empid=$empId&Data=$data,&Status=$Type&iRemark=${remarkController.text}';
      final uri = Uri.parse(restUrl.replaceAll(' ', ''));


      final response = await http.get(uri);

      if (response.statusCode == 200) {
        String content = response.body;
        // if (prefs.getString('notiKid') != null) {
        //   await EasyLoading.dismiss();
        //   _showAlertDialog(content);

        //   _deleteNotification(prefs.getString('notiKid')!);
        // } else {
        await EasyLoading.dismiss();
        await _showAlertDialog(content);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        // OnGetListafterAPPROVE();
        // }
      } else {
        await EasyLoading.dismiss();

        throw Exception('Failed to approve');
      }
    } catch (e) {
      await EasyLoading.dismiss();

      print('ERROR: $e');
      _showAlertDialog('Unable to Connect to the Server');
    }
  }

  Future<void> _deleteNotification(String Kid) async {
    try {
      ServerDetails serverDetails = ServerDetails();

      // Replace with your application name

      // Construct the URL
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=NotificationDelete&kid=$Kid';
      final uri = Uri.parse(restUrl.replaceAll(' ', ''));

      // Make the HTTP GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the server returns an OK response, navigate to MainPage
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        throw Exception('Failed to delete notification');
      }
    } catch (e) {
      // Handle exceptions
      print('ERROR: $e');
      _showAlertDialog('Unable to Connect to the Server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Back Date Entry",
          style: TextStyle(
              color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: backdateList.length,
                itemBuilder: (context, index) {
                  var item = backdateList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFBD830A)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: const Color(0xFFF6F6F6),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Date: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Text(item.date,
                                  style: const TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              const SizedBox(width: 100),
                              const Text('Remark: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Text(item.remarks,
                                  style: const TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Intime: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Text(item.intime,
                                  style: const TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              const SizedBox(width: 120),
                              const Text('Outtime: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Text(item.outtime,
                                  style: const TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Total: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Text(item.total,
                                  style: const TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              const SizedBox(width: 130),
                              const Text('Action Remark: ',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              const Text("",
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Action',
                                  style: TextStyle(
                                      color: Color(0xFF547EC8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesNewRoman",
                                      fontSize: 12)),
                              Checkbox(
                                value: selectedItems.contains(item),
                                onChanged: (bool? value) {
                                  _checkboxCheckChanged(value, item);
                                },
                                checkColor: Colors.blue,
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Remark',
                      style: TextStyle(
                          color: Color(0xFF547EC8),
                          fontSize: 12,
                          fontFamily: "TimesNewRoman",
                          fontWeight: FontWeight.bold)),
                  TextField(
                    controller: remarkController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Remark',
                      hintStyle: TextStyle(color: Colors.black54),
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _approvedClicked("A");
                  },
                  child: const Text('Approve',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _approvedClicked("X");
                    // Handle reject action
                  },
                  child: const Text('Reject',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
