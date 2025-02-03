import 'dart:convert';
import 'package:ehr/Dashboard/BackDateInsert.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_StatusRemark.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_First.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/TravelClaim_Status_Second.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/demo_travel.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Status/model.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Color.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TravelClaimApproved extends StatefulWidget {
  final String ClaimStatus;
  final String ClaimCode;
  final String Fromdate;
  final String Todate;
  final String claimstatuss;

  TravelClaimApproved(
      {super.key,
      required this.ClaimStatus,
      required this.ClaimCode,
      required this.Fromdate,
      required this.Todate,
      required this.claimstatuss});

  @override
  _TravelClaimApproved createState() => _TravelClaimApproved();
}

class _TravelClaimApproved extends State<TravelClaimApproved> {
  //List<AttendHistory> attendHistory = [];
  // final List<String> claimData = [
  //   'EMP123',
  // ];

  List<AttendHistory> attendHistory = [];
  List<JourneyData> journey = [];
  List<LocalConveyence> Localconvency = [];
  List<otherExpence> OtherExpense = [];
  List<Summary> Summaryy = [];
  List<BoardingData> Boardgingdata = [];
  List<ACTIONDATA> ActionData = [];
  int? selectedIndex;
  String? claimstatus;
  String? fromDate;
  String? ToDate;
  String? restUrl;
  String? ronak;
  String? Viewadataa;
  bool ViewButton = false;
  bool CancelButton = false;
  @override
  void initState() {
    super.initState();

    // ViewClaim("Ronak");
    onGetList();
  }

  Future<void> onGetList() async {
    try {
      // Server details
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await EasyLoading.show(status: 'Loading...');

      ServerDetails serverDetails = ServerDetails();
     
      String empKid = prefs.getString('EmpKid') ?? '';
      String? fromdate;
      String? ToDate;
      String? ClaimCodee;
      String? ClaimStatusID;

      if (widget.Fromdate != "null") {
        fromdate = widget.Fromdate;
      }
      if (widget.Fromdate == "0") {
        fromdate = ronak;
      }
      if (widget.Todate != "null") {
        ToDate = widget.Todate;
      }
      if (widget.ClaimCode != "null") {
        ClaimCodee = widget.ClaimCode.toString();
      }
      if (widget.ClaimStatus == "R") {
        setState(() {
          ViewButton = true;
          CancelButton = true;
        });
      } else {
        setState(() {
          ViewButton = true;
        });
      }
      if (widget.ClaimStatus == null || widget.ClaimStatus == "") {
        ClaimStatusID = "R";
      } else {
        ClaimStatusID = widget.ClaimStatus;
      }

      if (widget.claimstatuss == "Null") {
        restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=claimstatus&EmpKid=' +
                empKid.toString() +
                '&status=' +
                widget.ClaimStatus +
                '&claimcode=' +
                widget.ClaimCode +
                '&fromdate=' +
                '&todate=';
      } else {
        restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=claimstatus&EmpKid=' +
                empKid.toString() +
                '&status=' +
                ClaimStatusID.toString() +
                '&claimcode=' +
                widget.ClaimCode +
                "&fromdate=${fromdate ?? ''}&todate=${ToDate ?? ''}";
        // '&fromdate='+
        // ${fromdate ?? ''}+
        // '&todate=' +
        // ToDate.toString();
      }

      final response = await http.get(Uri.parse(restUrl.toString()));

      if (response.statusCode == 200) {
        if (response.body == "[]") {
          await EasyLoading.dismiss();
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
                                  builder: (Context) =>
                                      TravelClaimStatusfirst()));
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
        } else {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            attendHistory =
                data.map((json) => AttendHistory.fromJson(json)).toList();
          });
          await EasyLoading.dismiss();
          // if (widget.claimstatuss == "Null") {
          //   List<dynamic> filteredData =
          //       data.where((item) => item['ClaimStatus'] == "R").toList();

          //   setState(() {
          //     try {
          //       attendHistory = filteredData
          //           .map((json) => AttendHistory.fromJson(json))
          //           .toList();
          //     } catch (e) {
          //       print('Error in mapping: $e');
          //     }
          //   });
          // } else {
          //   setState(() {
          //     try {
          //       setState(() {
          //         attendHistory =
          //             data.map((json) => AttendHistory.fromJson(json)).toList();
          //       });

          //       // });
          //     } catch (e) {
          //       print('Error: $e');
          //     }
          //   });
          // }
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      await EasyLoading.dismiss();
      Alert_DialogBox.showAlert(context, "Server Error");

      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Travel Claim Status",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "TimesNewRoman",
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelClaimStatusfirst()),
                );
              },
            ),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: attendHistory.length,
              itemBuilder: (context, index) {
                final item = attendHistory[index];
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
                          buildTextFieldd("Claim Code:", item.ClaimCode),
                          buildTextFieldd("Employee Name:", item.eName),
                          buildTextFieldd("Claim Type:", item.Claimtype),
                          buildTextFieldd("Claim From:", item.ClaimFDate),
                          buildTextFieldd("Claim To:", item.ClaimTDate),
                          buildTextFieldd("Request Date:", item.RequestDate),
                          buildTextFieldd(
                              "Claim Amount:", item.Amount.toString()),
                          // buildTextFieldd("Action:", "${attendHistory[index]}"),
                          buildText("Status:", item.ClaimStatusName),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: ViewButton,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Define the Details button's functionality
                                      String Status = "Status";
                                      String LabelName = "Back";
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      await prefs.setString(
                                          'TravelClaim', Status);
                                      await prefs.setString(
                                          'labelname', LabelName);

                                      _view(item);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .blue, // Customize Details button color
                                    ),
                                    child: const Text(
                                      'View', // Details button label
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 10), // Add spacing between buttons
                                Visibility(
                                  visible: CancelButton,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Define the Cancel button's functionality
                                      _viewcancel(
                                          item); // Example: Closes the current screen
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .blue, // Customize Cancel button color
                                    ),
                                    child: const Text(
                                      'Cancel', // Cancel button label
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  void _view(AttendHistory item) {
    try {
      // Navigator.pop(context);

      String itemmm = item.ClaimURL;
      String ClaimId = item.ClaimID.toString();
      String ClaimStatuss = item.ClaimStatus.toString();

      List<String> splitDte = itemmm.toString().split("=");

      String _selectedFromDate = splitDte[2];
      List<String> splitDtee = _selectedFromDate.toString().split("&");
      Viewadataa = splitDtee[0];

      ViewClaim(Viewadataa.toString(), ClaimStatuss.toString());

      //ViewClaim(Viewadata);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _viewcancel(AttendHistory item) {
    try {
      // Navigator.pop(context);

      String itemmm = item.ClaimID.toString();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TravelClaimRemark(
                    Remark: item.ClaimID.toString(),
                  )));
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildTextFieldd(String Textlabel, String DataText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(Textlabel,
            style: TextStyle(
                fontSize: 15,
                fontFamily: "TimesnewRoman",
                fontWeight: FontWeight.bold,
                color: secondaryColor)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(DataText,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "TimesnewRoman",
                  color: secondaryColor)),
        ),
      ],
    );
  }

  Widget buildText(String Textlabel, String DataText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(Textlabel,
            style: TextStyle(
                fontSize: 15,
                fontFamily: "TimesnewRoman",
                fontWeight: FontWeight.bold,
                color: Color(0xFF547EC8))),
        const SizedBox(width: 5),
        Flexible(
          child: Text(DataText,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "TimesnewRoman",
                  color: Colors.green)),
        ),
      ],
    );
  }

  // api

  Future<void> ViewClaim(String TRVID, String statusClaim) async {
    try {
      // Server details
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     
      String empKid = prefs.getString('EmpKid') ?? '';

      restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=viewstatus&EmpKid=' +
              empKid.toString() +
              '&trvid=' +
              TRVID.toString() +
              '&status=' +
              statusClaim.toString();

      final response = await http.get(Uri.parse(restUrl.toString()));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> Journey = json.decode(response.body)['JourneyData'];
        List<dynamic> Boardging = json.decode(response.body)['BoardingData'];
        List<dynamic> Otherexp = json.decode(response.body)['Otherexp'];
        List<dynamic> localconvey =
            json.decode(response.body)['LocalConveyence'];
        List<dynamic> Cliamsummary = jsonData['Claimsummary'];
        // List<dynamic> Action = json.decode(response.body)['action'];
        //  var ronak = Cliamsummary[0];
        //  String ronakk = ronak[0].

        setState(() {
          journey = Journey.map((json) => JourneyData.fromJson(json)).toList();
          Localconvency = localconvey
              .map((json) => LocalConveyence.fromJson(json))
              .toList();
          OtherExpense =
              Otherexp.map((json) => otherExpence.fromJson(json)).toList();
          Summaryy =
              Cliamsummary.map((json) => Summary.fromJson(json)).toList();
          Boardgingdata =
              Boardging.map((json) => BoardingData.fromJson(json)).toList();
          //ActionData = Action.map((json) => ACTIONDATA.fromJson(json)).toList();
        });
        var AccountSummary = Summaryy[0];
        //String rrr = ronaknyariya.JourneyAmt;

        // String _depatruretaxfromdate = AccountSummary.JourneyAmt;
        //           String _boardgingtaxdate = BoardgingTaxDate[0];

        prefs.setString("_JourneyAmt", AccountSummary.JourneyAmt);
        prefs.setString("_OthAmt", AccountSummary.OthAmt);
        prefs.setString("_HigherAmt", AccountSummary.HigherAmt);
        prefs.setString("_Remark", AccountSummary.Remark);
        prefs.setString("_DaAmt", AccountSummary.DaAmt);
        prefs.setString("_BoardAmt", AccountSummary.BoardAmt);
        prefs.setString("_AdvAmt", AccountSummary.AdvAmt);
        prefs.setString("_TotAmt", AccountSummary.TotAmt);
        prefs.setString("_LocalConAmt", AccountSummary.LocalConAmt);

        prefs.setString("_ClaimStatus", widget.ClaimStatus);
        prefs.setString("_ClaimCode", widget.ClaimCode);
        prefs.setString("_Fromdate", widget.Fromdate);
        prefs.setString("_Todate", widget.Todate);
        prefs.setString("_claimstatuss", widget.claimstatuss);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TravelClaimSecondStatus(
                    JJourney: journey,
                    localConvenecy: Localconvency,
                    otherexpense: OtherExpense,
                    summarydetails: Summaryy,
                    boardgingdata: Boardgingdata,
                    TravelID: Viewadataa.toString())));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class AttendHistory {
  String Claimtype;
  String empCode;
  String eName;
  String ClaimCode;
  String ClaimFDate;
  String ClaimTDate;
  String Amount;
  String ClaimID;
  String ClaimStatusName;
  String ClaimStatus;
  String ClaimTypeID;
  String Level;
  String UserID;
  String RequestDate;
  int IsReEdit;
  String ClaimURL;

  AttendHistory(
      {required this.Claimtype,
      required this.empCode,
      required this.eName,
      required this.ClaimCode,
      required this.ClaimFDate,
      required this.ClaimTDate,
      required this.Amount,
      required this.ClaimID,
      required this.ClaimStatusName,
      required this.ClaimStatus,
      required this.ClaimTypeID,
      required this.Level,
      required this.UserID,
      required this.RequestDate,
      required this.IsReEdit,
      required this.ClaimURL});

  factory AttendHistory.fromJson(Map<String, dynamic> json) {
    return AttendHistory(
        Claimtype: json['Claimtype'],
        empCode: json['empCode'],
        eName: json['eName'],
        ClaimCode: json['ClaimCode'],
        ClaimFDate: json['ClaimFDate'],
        ClaimTDate: json['ClaimTDate'],
        Amount: json['Amount'].toString(),
        ClaimID: json['ClaimID'].toString(),
        ClaimStatusName: json['ClaimStatusName'],
        ClaimStatus: json['ClaimStatus'],
        ClaimTypeID: json['ClaimTypeID'].toString(),
        Level: json['Level'].toString(),
        UserID: json['UserID'].toString(),
        RequestDate: json['RequestDate'],
        IsReEdit: json['IsReEdit'],
        ClaimURL: json['ClaimURL']);
  }
}
