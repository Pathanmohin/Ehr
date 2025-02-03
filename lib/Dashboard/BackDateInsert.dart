// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ehr/Dashboard/Attendance.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BackdateInsertPage extends StatefulWidget {
  @override
  final String backDate;

  BackdateInsertPage({super.key, required this.backDate});
  _BackdateInsertPageState createState() => _BackdateInsertPageState();
}

class _BackdateInsertPageState extends State<BackdateInsertPage> {
  List<ParameterAttendencelist> trends1 = [];

  TimeOfDay _inTime = TimeOfDay.now();
  TimeOfDay _outTime = TimeOfDay.now();
  String? _selectedAttendanceType;
  String? _remark;
  List<Map<String, dynamic>> array = [];

  @override
  void initState() {
    super.initState();
    OnGetparameter();
  }

  Future<void> _selectINTime(BuildContext context, bool isInTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isInTime
          ? _inTime
          : TimeOfDay.now(), // Default to current time if isInTime is false
    );
    if (picked != null && picked != _inTime) {
      setState(() {
        if (isInTime) {
          _inTime = picked;
        }
      });
    }
  }

  Future<void> _selectOutTime(BuildContext context, bool isOutTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOutTime
          ? _outTime
          : TimeOfDay.now(), // Default to current time if isOutTime is false
    );
    if (picked != null && picked != _outTime) {
      setState(() {
        if (isOutTime) {
          _outTime = picked;
        }
      });
    }
  }

  Future<void> OnGetparameter() async {
    ServerDetails serverDetails = ServerDetails();

    final String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?calltype=_MstAttendRemark';
    try {
      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<ParameterAttendencelist> parameterattendlist =
            (json.decode(response.body) as List)
                .map((data) => ParameterAttendencelist.fromJson(data))
                .toList();

        setState(() {
          trends1 = parameterattendlist;
          if (trends1.isNotEmpty) {
            _selectedAttendanceType = '${trends1[0].kid}-${trends1[0].text}';
          }
        });
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onProceed() async {
    try {
      double intym = _inTime.hour + _inTime.minute / 60.0;
      double outtym = _outTime.hour + _outTime.minute / 60.0;

      if (_inTime == const TimeOfDay(hour: 0, minute: 0)) {
        await _showAlert("Alert", "InTime is required..!");
        return;
      } else if (_outTime == const TimeOfDay(hour: 0, minute: 0)) {
        await _showAlert("Alert", "OutTime is required..!");
        return;
      } else if (outtym < intym) {
        await _showAlert("Alert", "Out Time cannot be less than InTime..!");
        return;
      } else if (_remark == null || _remark!.isEmpty) {
        await _showAlert("Alert", "Remark is required..!");
        return;
      }

      // String backdatee = "31-03-2024"; // Application.Current.Properties["Backdate"]
      List<String> parts = widget.backDate.split('-');
      String datePart = parts[0]; // "31/03/2024"

      DateTime date = DateFormat("dd/MM/yyyy").parse(datePart);
      String backDate = DateFormat("yyyy/MM/dd").format(date);
      String backDate_mm = DateFormat("MM").format(date);
      String backDate_yyyy = DateFormat("yyyy").format(date);

      // Mock Server Details
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String attendenceP = _selectedAttendanceType.toString().split('-')[0];

      var imagePath = {
        "Rdate": backDate,
        "intime": "$backDate ${_inTime.format(context)}",
        "outtime": "$backDate ${_outTime.format(context)}",
        "remark": _remark,
        "attendType": attendenceP, // Example attendance type
      };
      array.add(imagePath);

      //var json = jsonEncode(array);

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=AttendanceBackDateInsert&empid=$empKid&month=$backDate_mm&year=$backDate_yyyy&Date=$backDate&Intime=${_inTime.format(context)}&OutTime=${_outTime.format(context)}&remarkMst=$attendenceP&Remarks=$_remark";
      // &JsonData=$json";

      print("URL: $restUrl");

      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        if (response.body == "Saved Succesfully") {
          await _showwAlert("Alert", "Saved Succesfully");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          await _showwAlert("Alert", response.body);
        }
      } else {
        await _showwAlert("Alert", "Unable to Connect to the Server");
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));
    } catch (e) {
      print("Exception: $e");
      await _showwAlert("Alert", "Unable to Connect to the Server");
    }
  }

  _showAlert(String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
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

  _showwAlert(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AttendancePage()));
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Back Date Insert",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "TimesNewRoman",
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AttendancePage()));
              },
            ),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'Back Date: ${widget.backDate}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: "TimesNewRoman",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildTimePickerRow('IN', _inTime, true),
                  const SizedBox(height: 10),
                  _buildOutTimePickerRow('OUT', _outTime, true),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPicker(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildRemarkEntry(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildProceedButton(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimePickerRow(String label, TimeOfDay time, bool isInTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: Frame(
            borderColor: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 15, left: 15, top: 8, bottom: 10),
              child: Text(
                label,
                style:
                    const TextStyle(height: 1.2, fontFamily: "TimesNewRoman"),
              ),
            ),
          ),
        ),
        Frame(
          borderColor: Colors.orange,
          child: GestureDetector(
            onTap: () => _selectINTime(context, isInTime),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                time.format(context),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutTimePickerRow(String label, TimeOfDay time, bool isOutTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: Frame(
            borderColor: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                label,
                style:
                    const TextStyle(height: 1.2, fontFamily: "TimesNewRoman"),
              ),
            ),
          ),
        ),
        Frame(
          borderColor: Colors.orange,
          child: GestureDetector(
            onTap: () => _selectOutTime(context, isOutTime),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                time.format(context),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPicker() {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Attendance Type',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                    fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                items: trends1.map((ParameterAttendencelist item) {
                  return DropdownMenuItem<String>(
                    value: '${item.kid}-${item.text}',
                    child: Text('${item.kid}-${item.text}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAttendanceType = newValue;
                  });
                },
                hint: const Text(
                  'Select Type',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 12,
                  ),
                ),
                value: _selectedAttendanceType,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRemarkEntry() {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Remark',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Remark',
                  hintStyle:
                      TextStyle(fontSize: 12, fontFamily: "TimesNewRoman"),
                ),
                onChanged: (value) {
                  _remark = value;
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProceedButton() {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                side: const BorderSide(color: Colors.orange, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: _onProceed,
              child: const Text(
                'Proceed',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: "TimesNewRoman"),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class Frame extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const Frame({super.key, required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
