import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
import 'package:ehr/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Leaverequest extends StatefulWidget {
  @override
  _LeaverequestState createState() => _LeaverequestState();
}

class _LeaverequestState extends State<Leaverequest> {
  String? leaveType;
  String? managertype;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? dayTypeStart = "Full Day";
  String? dayTypeEnd = "Full Day";
  String? dayTypeStartt = "";
  String? compOff;
  String? payable;
  bool isOutOfStation = false;
  bool isReportingManagerAvailable = false;
  bool firsthalf = false;
  bool secondhalf = false;
  String? halfDayTypeStart;
  bool compoff = false;
  bool payeble = false;
  bool childcare = false;
  String? managerToBeSanctionedBy;
  String? documentDescription;
  String? childAge;
  String? noOfChildren;
  DateTime childDOB = DateTime.now();
  String totalDays = "0";
  String? leaveReason;
  String? urgentWorkInHand;
  String? addressDuringLeave;
  String? documentPath;
  String? documentName;
  List<LeaveDataRequest> leaveTypes = [];
  List<ManagerList> managerList = [];
  List<CompOffList> compOffList = [];
  String leaveMessageShowAlert = "";
  String hdnLevPara = "";
  String NoOfChildrenn = "0";
  String IsPayablee = "0";
  bool isChecked = false;
  bool _isLoading = false;
  String? imgStr;
  String? name;
  String? extensionGet;
  String? firstthalf = "";
  String? seconddhalf = "";
 

  List<Map<String, dynamic>> array = [];
  List<int>? fileBytes = [];
  String selectedPayableValue = '';

  // String payable = '';

  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();
    fetchManagers();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      await EasyLoading.show(status: 'Loading...');

      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';

      String url =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callType=_allLeaveType';

      final response = await http.get(Uri.parse(url));
      await EasyLoading.dismiss();
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          leaveTypes = LeaveDataRequest.fromJsonList(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Displaying an alert in case of error
      showDialog(
        context: context,
        builder: (context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text(
                'Alert',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: const Text(
                'Unable to connect to the server',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  Future<void> fetchManagers() async {
    try {
      String currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';

      String url =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=RMNotAvailable&empcode=$userId&currdate=$currentDate&EmpKid=$empKid';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          managerList = ManagerList.fromJsonList(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Displaying an alert in case of error
      showDialog(
        context: context,
        builder: (context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text(
                'Alert',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: const Text(
                'Unable to connect to the server',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  Future<void> compoOffLeave(BuildContext context) async {
    String leaveTypeData = leaveType.toString().split('-')[0];
    try {
      String currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=FillCompOffLeaveforTake&EmpKid=$empKid&FromDate=${DateFormat('dd/MM/yyyy').format(startDate)}&ToDate=${DateFormat('dd/MM/yyyy').format(endDate)}&LevType=$leaveTypeData';

      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          compOffList = CompOffList.fromJsonList(data);
        });
        // List<CompOffList> compOffList = data.map((item) => CompOffList.fromJson(item)).toList();

        // Assuming you have a list widget or any other UI element to show the data
        // showCompOffList(context, compOffList);
      } else {
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      showAlert(context, "You don't have leave balance of selected leave!!");
      print('ERROR: $e');
    }
  }

  void showAlert(BuildContext context, String message) {
    // Display alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text(
                'Alert',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: Text(
                message,
                style: const TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
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

  Future<void> changeEvent() async {
    String leaveTypeData = leaveType.toString().split('-')[0];

    if (leaveTypeData.isNotEmpty && startDate != "" && endDate != "") {
      if (endDate.isBefore(startDate)) {
        await _showAlert(
            "Alert", "To Date must be greater than or equal to From Date");
        return;
      }

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        ServerDetails serverDetails = ServerDetails();

        String userId = prefs.getString("userID") ?? '';
        String empKid = prefs.getString('EmpKid') ?? '';
        String dayStatus = dayTypeStart == "Full Day" ? "F" : "H";
        String dayStatusFromDay = dayTypeEnd == "Full Day" ? "F" : "H";

        String restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=LeaveCalc'
            '&empcode=$userId'
            '&leaveCode=$leaveTypeData'
            '&FromDate=${DateFormat('dd/MM/yyyy').format(startDate)}'
            '&FromDateStatus=$dayStatus'
            '&ToDate=${DateFormat('dd/MM/yyyy').format(endDate)}'
            '&ToDateStatus=$dayStatusFromDay'
            '&NoOfChildren=$NoOfChildrenn'
            '&lapsDate='
            '&IsPayable=$IsPayablee'
            '&FromHalfStatus=&ToHalfStatus=&IsChildDisable=Y&ChildAge=0';

        final response = await http.get(Uri.parse(restUrl.replaceAll(' ', '')));
        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          List<LevCal> trends =
              responseData.map((data) => LevCal.fromJson(data)).toList();

          prefs.setString('Column1', trends[0].column1.toString());
          prefs.setString('Column2', trends[0].column2);
          prefs.setString('Column3', trends[0].column3.toString());
          prefs.setString('Column4', trends[0].column4.toString());
          prefs.setString('Column5', trends[0].column5.toString());
          prefs.setString('Column6', trends[0].column6.toString());
          prefs.setString('Column7', trends[0].column7.toString());
          prefs.setString('Column8', trends[0].column8);
          prefs.setString('LeaveBehaveCode', trends[0].leaveBehaveCode);
          prefs.setString('Msg', trends[0].msg);
          prefs.setString('levPara', trends[0].levPara.toString());
          prefs.setString('DocReq', trends[0].docReq);
          prefs.setString('Payable', trends[0].payable);
          prefs.setString('ApprovalLevel', trends[0].approvalLevel.toString());

          leaveMessageShowAlert = trends[0].msg;
          hdnLevPara = trends[0].levPara.toString();

          String returnval =
              '${trends[0].retValue}~${trends[0].column1}~${trends[0].column4}~${trends[0].column5}~${trends[0].column7}~${trends[0].column8}~${trends[0].leaveBehaveCode}';

          if (double.parse(trends[0].retValue.toString()) > 0) {
            prefs.setString('retValue', trends[0].retValue.toString());
            setState(() {
              totalDays = prefs.getString('retValue')!;
//rtnVal = true;
            });
          } else {
            if (leaveMessageShowAlert.isEmpty) {
              showErrorMsg(returnval, "");
            } else {
              await _showAlert("Alert", leaveMessageShowAlert);
              setState(() {
                totalDays.isEmpty;
              });
            }
          }

          // Handle UI updates based on LeaveBehaveCode
          _handleLeaveBehaveCode(
              prefs.getString('LeaveBehaveCode')!, prefs.getString('DocReq')!);
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  void _handleLeaveBehaveCode(String leaveBehaveCode, String docReq) {
    setState(() {
      if (leaveBehaveCode != null) {
        if (leaveBehaveCode == "202") {
          payeble = false;
          childcare = true;
          compoff = false;
        } else if (leaveBehaveCode == "114") {
          payeble = false;
          compoff = false;
        } else if (leaveBehaveCode == "115") {
          payeble = true;
          compoff = false;
        } else if (leaveBehaveCode == "119") {
          compoff = true;

          // Compo_OFF_Leave();
        } else if (leaveBehaveCode == "113") {
          childcare = true;

          //  childDate_lapdate = child_DOB.Date.ToString("dd/MM/yyyy");
          //  if (child_DOB_stackflow.IsVisible == true)
          //  {
          //      Child_age_value_str = Child_age_value.Text;
          //  }
          //  else
          //  {
          //      Child_age_value_str = "0";
          //  }
        } else {
          payeble = false;
          childcare = false;
          compoff = false;
        }
      }
    });
  }

  Future<void> _showAlert(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title,
                  style: const TextStyle(fontFamily: "TimesNewRoman")),
              content: Text(message,
                  style: const TextStyle(fontFamily: "TimesNewRoman")),
              actions: [
                TextButton(
                  child: const Text("OK",
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                      )),
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

  Future<void> showErrorMsg(String errorType, String msg) async {
    List<String> strError = errorType.split('~');

    if (msg.isEmpty) {
      double errorcode = double.parse(strError[0]);
      switch (errorcode) {
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
        case -301:
          msg =
              "You can't apply leave on Holiday, Please select working day in To Date!!";
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
          msg = "Wrong laps Date.";
          break;
        case -1114:
          msg = "Wrong laps Date.";
          break;
        case -1115:
          msg = "Wrong lapse date.";
          break;
        case -1166:
          msg = "As per data, You have already availed leave for this child.";
          break;
        case -1177:
          msg = "s per data, You have already availed leave for this child.";
          break;
        case -166:
          msg = "You can not apply this type of leave for this year.";
          break;
        case -177:
          msg = "You can not apply this type of leave for this year.";
          break;
        case -116:
          msg = "No of children limit exceed";
          break;
        case -117:
          msg = "Number of children limit exceeded";
          break;
        // case -11113:
        //     msg = Msg.Replace("'", "");
        //     break;
        // case -11114:
        //     msg = Msg.Replace("'", "");
        //     break;
        // case -12000:
        //     msg = Msg.Replace("", "");
        //     break;
        // case -1234:
        //     msg = Msg.Replace("", "");
        //     break;

        // case -12001:
        //     msg = Msg.Replace("'", "");
        //     break;

        // case -118:
        //     msg = Msg.Replace("'", "");
        //     break;
        // case -119:
        //     msg = Msg.Replace("'", "");
        //     break;
        case -1001:
          msg =
              "Transfer is on your request, So You cannot take selected leave!!";
          break;
        case -1111:
          msg = ("Child's Age Limit Exceed!!");
          break;
      }
    }

    if (msg.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: Text(
                msg,
                style: const TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }

    if (double.parse(strError[0]) > 0) {}
  }

  Future<void> buttonClickedProceed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    try {
      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';
      String empKid = prefs.getString('EmpKid') ?? '';
      String dayStatus = dayTypeStart == "Full Day" ? "F" : "H";
      String dayStatusFromDay = dayTypeEnd == "Full Day" ? "F" : "H";
      if (dayStatus == "H") {
        firstthalf = "1H";
      } else if (dayStatusFromDay == "H") {
        seconddhalf = "2H";
      }
      String leaveTypeData = leaveType.toString().split('-')[0];
      String startdate = DateFormat('dd/MM/yyyy').format(startDate);
      String enddate = DateFormat('dd/MM/yyyy').format(startDate);
      if (leaveTypeData == "null" || leaveTypeData == "") {
        await _showAlert("Alert", "Please select leave type");
        return;
      }

      if (totalDays == null || totalDays == "") {
        await _showAlert("Alert", "Please fill mandatory details");
        return;
      }

      if (leaveReason == null || leaveReason == "") {
        await _showAlert("Alert", "Please enter reason");
        return;
      }

      if (urgentWorkInHand == null || urgentWorkInHand == "") {
        await _showAlert("Alert", "Please enter Urgent Work in hand");
        return;
      }

      if (isChecked && (managertype == null || managertype == "")) {
        await _showAlert("Alert", "Please enter Manager list");
        return;
      }

      // if (value == "yes" && leaveAddressController.text.isEmpty) {
      //   await _showAlert("Alert", "Please enter Address");
      //   return;
      // }

      if (prefs.getString('DocReq') == "Y" && imgStr == null) {
        await _showAlert("Alert",
            "Doctor prescription from registered practitioner needs to be uploaded");
        return;
      }

      if (prefs.getString('LeaveBehaveCode') == "207" &&
          addressDuringLeave == null &&
          addressDuringLeave == "") {
        await _showAlert("Alert", "Please select Address During Leave");
        return;
      }

      if (prefs.getString('LeaveBehaveCode') == "115") {
        if (IsPayablee == null || IsPayablee == "") {
          await _showAlert("Alert", "Please select payable");
          return;
        }
      }

      if (endDate.isBefore(startDate)) {
        await _showAlert(
            "Alert", "To Date must be greater than or equal to From Date");
        return;
      }
      await EasyLoading.show(status: 'Marking Leave...');

      Map<String, dynamic> requestBody = {
        'LeaveListDetails': {
          'LeaveData': [
            {
              "levcode": leaveTypeData,
              "levParaID": hdnLevPara,
              "empcode": userId,
              "FromDate": startdate,
              "ToDate": enddate,
              "FromDateStatus": dayStatus,
              "ToDateStatus": dayStatusFromDay,
              "TotalLeaves": totalDays,
              "eReason": leaveReason,
              "SanctionedBy": managertype ?? "0",
              "RequestApp": "M",
              "workInHand": urgentWorkInHand,
              "eAddress": addressDuringLeave ?? "",
              "ChildAge": noOfChildren ?? "0",
              "PayType": IsPayablee ?? "0",
              "currdate": currentDate,
              "levRequestType": "",
              "lapsDate": "",
              "IsMandatory": "Y",
              "FromHalfStatus": firstthalf ?? "",
              "ToHalfStatus": seconddhalf ?? "",
              "IsChildDisable": "N",
              "CompOffReqId": "2",
              "Name": name ?? " ",
              "Extension": extensionGet ?? " ",
              "Content": "DOCUMENTUPLOAD" + (imgStr ?? " ") + "DOCUMENTUPLOAD",
              "Description": documentDescription ?? " ",
            }
          ]
        }
      };

      String jsonString = jsonEncode(requestBody);

      print("Request JSON: $jsonString"); // Debug print

      var url = Uri.parse(
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/Mobile/LeaveRequest.ashx');
      var response = await http.post(url,
          body: jsonString,
          headers: {'Content-Type': 'application/json'},
          encoding: Encoding.getByName("utf-8"));

      print("Response status: ${response.statusCode}"); // Debug print
      print("Response body: ${response.body}"); // Debug print

      // var response = await http.post(url, body: jsonEncode(requestBody), headers: {
      //   'Content-Type': 'application/json',
      // });

      // if (response.statusCode == 200) {
      //   var responseBody = jsonDecode(response.body);
      //   String message=responseBody.toString();
      if (response.statusCode == 200) {
        var responseBody;
        try {
          responseBody = jsonDecode(response.body);
        } catch (e) {
          responseBody = response.body;
        }

        if (responseBody == "Saved Sucessfully.") {
          await EasyLoading.dismiss();
          await __showAlert("Alert", "Leave requested successfully.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          await EasyLoading.dismiss();
          await __showAlert("Alert", responseBody.toString());
        }
      } else {
        await EasyLoading.dismiss();
        await __showAlert("Alert", "Unable to connect to the server");
      }
    } catch (e) {
      await EasyLoading.dismiss();
      print("Error: $e");
    }
    // setState(() {
    //   // Re-enable UI
    //   _isLoading = false;
    // });
  }

  Future<void> __showAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      message,
                      style: const TextStyle(
                        fontFamily: "TimesNewRoman",
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
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

  Future<void> _pickFile() async {

if(documentDescription==null || documentDescription=="")
{
await _showAlert("Alert", "Please Enter Document Description!");
          return;
}
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'text', 'png', 'jpeg', 'xls', 'xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if (file.size > 512000) {
        await _showAlertDialog("Uh oh", "Document Size Limit 500kb");
        return;
      }
      //  if (file.bytes != null && file.size <= 512000) {
      //     setState(() {
      //       fileBytes = file.bytes;
      //       name = file.name;
      //       extensionGet = '.' + file.extension!;
      //       array.add({"path": documentDescription, "name": name});
      //     });
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Document Size Limit 500KB')),
      //     );
      //   }

      //fileBytes = file.bytes!;
      name = file.name;
      extensionGet = '.' + file.extension!;

      String? docname =
          documentDescription; // Replace with your document name logic

      Map<String, dynamic> imagePath = {
        "path": docname,
        "name": name,
      };
      array.add(imagePath);

      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  Future<void> _showAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontFamily: "TimesNewRoman",
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      message,
                      style: const TextStyle(
                        fontFamily: "TimesNewRoman",
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
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

  void _deleteTapped(int index) {
    setState(() {
      array.removeAt(index);
    });
  }

  void onSelectPayable(String? newValue) {
    if (newValue != null) {
      setState(() {
        payable = newValue;
        if (payable == 'Full Pay') {
          IsPayablee = '2';
          changeEvent();
        } else if (payable == 'Half Pay') {
          IsPayablee = '0';
          changeEvent();
        } else {
          IsPayablee = '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Leave Type",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            DropdownButton<String>(
              isExpanded: true,
              value: leaveType,
              items: leaveTypes.map((leaveType) {
                return DropdownMenuItem<String>(
                  value: leaveType.value,
                  child: Builder(builder: (context) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.1)),
                        child: Text(
                          '${leaveType.value} - ${leaveType.text}',
                          style: const TextStyle(fontFamily: "TimesNewRoman"),
                        ));
                  }),
                );
              }).toList(),
              hint: const Text(
                'Select Leave Type',
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              onChanged: (newValue) {
                setState(() {
                  leaveType = newValue!;
                  changeEvent();
                });
              },
            ),
            const Text("From Date",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            Row(
              children: <Widget>[
                Expanded(
                  child: Builder(builder: (context) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.1)),
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText:
                                    DateFormat('dd/MM/yyyy').format(startDate),
                                hintStyle: const TextStyle(
                                  fontFamily: "TimesNewRoman",
                                )),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dayTypeStart,
                    items: <String>['Full Day', 'Half Day'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Builder(builder: (context) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontFamily: "TimesNewRoman"),
                              ));
                        }),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dayTypeStart = newValue!;
                        firsthalf = newValue == 'Half Day';
                        if (!firsthalf) halfDayTypeStart = null;
//{dayTypeStart = newValue;}
                      });
                      changeEvent();
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Visibility(
                  visible: firsthalf,
                  child: Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      // value: dayTypeStart == "Full Day" ? null : "2nd half",
                      value: halfDayTypeStart,
                      //value: dayTypeStart,
                      items:
                          <String>['1st half', '2nd half'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style:
                                  const TextStyle(fontFamily: "TimesNewRoman")),
                        );
                      }).toList(),
                      //  onChanged: null,
                      // disabledHint: const Text('2nd half'),
                      onChanged: (newValue) {
                        setState(() {
                          halfDayTypeStart = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Text("To Date",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: DateFormat('dd/MM/yyyy').format(endDate),
                          hintStyle:
                              const TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dayTypeEnd,
                    items: <String>['Full Day', 'Half Day'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Builder(builder: (context) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(value,
                                  style: const TextStyle(
                                      fontFamily: "TimesNewRoman")));
                        }),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dayTypeEnd = newValue!;
                        secondhalf = newValue == 'Half Day';

                        if (!secondhalf) {
                          dayTypeEnd = newValue;
                        }
                      });
                      changeEvent();
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Visibility(
                  visible: secondhalf,
                  child: Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dayTypeEnd == "Full Day" ? null : "1st Half",

                      items:
                          <String>['1st Half', '2nd Half'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style:
                                  const TextStyle(fontFamily: "TimesNewRoman")),
                        );
                      }).toList(),
                      onChanged: null,
                      disabledHint: const Text('1st Half'),
                      // onChanged: dayTypeEnd == "Full Day" ? null : (newValue) {
                      //   setState(() {
                      //     dayTypeEnd = newValue;
                      //   });
                      // },
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: compoff,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Comp-Off*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: compOff,
                    items: compOffList.map((compoff) {
                      return DropdownMenuItem<String>(
                        value: compoff.compOffDate,
                        child: Builder(builder: (context) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                '${compoff.compOffDate} ',
                                style: const TextStyle(
                                    fontFamily: "TimesNewRoman"),
                              ));
                        }),
                      );
                    }).toList(),
                    hint: const Text(
                      '--Select--',
                      style: TextStyle(fontFamily: "TimesNewRoman"),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        compOff = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: payeble,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Payable",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: payable,
                    items: <String>['Full Pay', 'Half Pay'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Builder(builder: (context) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontFamily: "TimesNewRoman"),
                              ));
                        }),
                      );
                    }).toList(),
                    hint: const Text(
                      '--Select--',
                      style: TextStyle(fontFamily: "TimesNewRoman"),
                    ),
                    onChanged: onSelectPayable,
                    // onChanged: (newValue) {
                    //   setState(() {
                    //     payable = newValue!;
                    //   });
                    // },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: childcare,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Enter Child's Age",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter Child's Age",
                      hintStyle: TextStyle(fontFamily: "TimesNewRoman"),
                    ),
                    onChanged: (value) {
                      setState(() {
                        childAge = value;
                      });
                    },
                  ),
                  const Text("No of Children",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: "No of Children",
                        hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
                    onChanged: (value) {
                      setState(() {
                        noOfChildren = value;
                      });
                    },
                  ),
                  const Text("Children DOB (dd-mm-yyyy)",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  GestureDetector(
                    onTap: () => _selectChildDOB(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: DateFormat('dd/MM/yyyy').format(childDOB),
                            hintStyle:
                                const TextStyle(fontFamily: "TimesNewRoman")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text("Total Days",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Total Days",
                  hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
              readOnly: true,
              controller: TextEditingController(text: totalDays),
            ),
            const Text("Reason of Leave",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter Reason",
                  hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
              onChanged: (value) {
                setState(() {
                  leaveReason = value;
                });
              },
            ),
            const Text("Urgent Work in Hand",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter Urgent Work",
                  hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
              onChanged: (value) {
                setState(() {
                  urgentWorkInHand = value;
                });
              },
            ),
            Visibility(
              visible: isOutOfStation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Address During Leave (if out of station)",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: "Enter Address",
                        hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
                    onChanged: (value) {
                      setState(() {
                        addressDuringLeave = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text(
                "Out of Station",
                style: TextStyle(fontFamily: "TimesNewRoman"),
              ),
              value: isOutOfStation,
              onChanged: (value) {
                setState(() {
                  isOutOfStation = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Is Reporting Manager not available?",
                  style: TextStyle(fontFamily: "TimesNewRoman")),
              value: isReportingManagerAvailable,
              onChanged: (value) {
                setState(() {
                  isReportingManagerAvailable = value;
                });
              },
            ),
            Visibility(
              visible: isReportingManagerAvailable,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Sanctioned by (Manager)",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF547EC8),
                          fontFamily: "TimesNewRoman")),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: managertype,
                    items: managerList.map((managertype) {
                      return DropdownMenuItem<String>(
                        value: managertype.codeName,
                        child: Builder(builder: (context) {
                          return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text('${managertype.codeName} ',
                                  style: const TextStyle(
                                      fontFamily: "TimesNewRoman")));
                        }),
                      );
                    }).toList(),
                    hint: const Text('Select  Manager ',
                        style: TextStyle(fontFamily: "TimesNewRoman")),
                    onChanged: (newValue) {
                      setState(() {
                        managertype = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Document Description",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF547EC8),
                    fontFamily: "TimesNewRoman")),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter Document Description",
                  hintStyle: TextStyle(fontFamily: "TimesNewRoman")),
              onChanged: (value) {
                setState(() {
                  documentDescription = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _pickFile,
                  child: const Text("Upload Document",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "TimesNewRoman")),
                ),
//               
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: array.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(array[index]['name'],
                          style:
                              const TextStyle(fontFamily: "TimesNewRoman")),
                      subtitle: Text(array[index]['path']?? 'Default Path',
                          style:
                              const TextStyle(fontFamily: "TimesNewRoman")),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => _deleteTapped(index),
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                  horizontal: 20), // Optional: Adjust margin as needed
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: buttonClickedProceed,
                child: const Text('Submit',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "TimesNewRoman")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
        changeEvent();
      });
    }
  }

 



  Future<void> _selectChildDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: childDOB,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != childDOB) {
      setState(() {
        childDOB = picked;
      });
    }
  }

  // void _uploadDocument() {}
}

class LeaveDataRequest {
  final int kid;
  final String value;
  final String text;

  LeaveDataRequest(
      {required this.kid, required this.value, required this.text});

  factory LeaveDataRequest.fromJson(Map<String, dynamic> json) {
    return LeaveDataRequest(
      kid: json['kid'],
      value: json['value'],
      text: json['text'],
    );
  }

  static List<LeaveDataRequest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LeaveDataRequest.fromJson(json)).toList();
  }
}

class ManagerList {
  final String codeName;

  ManagerList({required this.codeName});

  factory ManagerList.fromJson(Map<String, dynamic> json) {
    return ManagerList(
      codeName: json['CodeName'],
    );
  }

  static List<ManagerList> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ManagerList.fromJson(json)).toList();
  }
}

class LevCal {
  int column1;
  String column2;
  double column3;
  double column4;
  int column5;
  int column6;
  int column7;
  String column8;
  String leaveBehaveCode;
  String msg;
  int levPara;
  String docReq;
  String payable;
  int approvalLevel;
  double retValue;

  LevCal({
    required this.column1,
    required this.column2,
    required this.column3,
    required this.column4,
    required this.column5,
    required this.column6,
    required this.column7,
    required this.column8,
    required this.leaveBehaveCode,
    required this.msg,
    required this.levPara,
    required this.docReq,
    required this.payable,
    required this.approvalLevel,
    required this.retValue,
  });

  factory LevCal.fromJson(Map<String, dynamic> json) {
    return LevCal(
      column1: json['Column1'] ?? 0, // Example default value if it's an int
      column2: json['Column2'] ?? '', // Example default value if it's a String
      column3: json['Column3'] != null
          ? json['Column3'].toDouble()
          : 0.0, // Convert to double if not null
      column4: json['Column4'] != null
          ? json['Column4'].toDouble()
          : 0.0, // Convert to double if not null
      column5: json['Column5'] ?? 0, // Example default value if it's an int
      column6: json['Column6'] ?? 0, // Example default value if it's an int
      column7: json['Column7'] ?? 0, // Example default value if it's an int
      column8: json['Column8'] ?? '', // Example default value if it's a String
      leaveBehaveCode: json['LeaveBehaveCode'] ?? '',
      msg: json['Msg'] ?? '',
      levPara: json['levPara'] ?? 0, // Example default value if it's an int
      docReq: json['DocReq'] ?? '',
      payable: json['Payable'] ?? '',
      approvalLevel:
          json['ApprovalLevel'] ?? 0, // Example default value if it's an int
      retValue: json['retValue'] != null
          ? json['retValue'].toDouble()
          : 0.0, // Convert to double if not null
    );
  }
}

class CompOffList {
  final String compOffDate;

  CompOffList({required this.compOffDate});

  factory CompOffList.fromJson(Map<String, dynamic> json) {
    return CompOffList(
      compOffDate: json['CompOffDate'] as String,
    );
  }

  static List<CompOffList> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CompOffList.fromJson(json)).toList();
  }
}
