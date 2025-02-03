import 'dart:convert';
import 'package:ehr/Dashboard/BackDateInsert.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Approved/TravelClaim_Approvel.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Dashbaordd.dart';
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

class TravelClaimapproved extends StatefulWidget {
  @override
  _TravelClaimapproved createState() => _TravelClaimapproved();
}

class _TravelClaimapproved extends State<TravelClaimapproved> {
  List<AttendApprovell> attendHistoryyy = [];

  List<AttendHistory> attendHistory = [];
  List<JourneyData> journey = [];
  List<LocalConveyence> Localconvency = [];
  List<otherExpence> OtherExpense = [];
  List<Summary> Summaryy = [];
  List<BoardingData> Boardgingdata = [];
  List<ACTIONDATA> ActionData = [];
  String? Viewadata;

  @override
  void initState() {
    super.initState();
    onGetList();
  }

  Future<void> onGetList() async {
    try {
      // Server details
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     
      String empKid = prefs.getString('EmpKid') ?? '';
      await EasyLoading.show(status: 'Loading...');

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=claimauthlist&EmpKid=' +
              empKid.toString();

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
        } else {
          List<dynamic> data = json.decode(response.body);

          setState(() {
            attendHistoryyy =
                data.map((json) => AttendApprovell.fromJson(json)).toList();
          });
          await EasyLoading.dismiss();
        }

        // });
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
              "Travel Claim Approval",
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
                      builder: (context) => TravelClaimDashboard()),
                );
              },
            ),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: attendHistoryyy.length,
              itemBuilder: (context, index) {
                final item = attendHistoryyy[index];
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
                          buildTextFieldd("Claim Type:", item.ClaimType),
                          buildTextFieldd("Name:", item.EmployeeName),
                          buildTextFieldd("Claim Code:", item.claimCode),
                          buildTextFieldd("Date Range:", item.DateRange),
                          buildTextFieldd("Request Date:", item.RequestDate),
                          buildTextFieldd("Claim Amount:", item.ReqCost),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // Define the Details button's functionality

                                    String Status = "Approvel";
                                    String LabelName = "Next";
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
                                    'Authorize', // Details button label
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
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

  Future<void> ViewClaim(String TRVID) async {
    try {
      // Server details
      await EasyLoading.show(status: 'Loading...');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     
      String empKid = prefs.getString('EmpKid') ?? '';
      String USERID = prefs.getString('userID') ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=viewstatus' +
              '&EmpKid=' +
              empKid.toString() +
              '&trvid=' +
              TRVID.toString() +
              '&status=R';

      final response = await http.get(Uri.parse(restUrl.toString()));

      if (response.statusCode == 200) {
        await EasyLoading.dismiss();
        final jsonData = json.decode(response.body);
        List<dynamic> Journey = json.decode(response.body)['JourneyData'];
        List<dynamic> Boardging = json.decode(response.body)['BoardingData'];
        List<dynamic> Otherexp = json.decode(response.body)['Otherexp'];
        List<dynamic> localconvey =
            json.decode(response.body)['LocalConveyence'];
        List<dynamic> Cliamsummary = json.decode(response.body)['Claimsummary'];

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
        });
        var AccountSummary = Summaryy[0];
        prefs.setString("_JourneyAmt", AccountSummary.JourneyAmt);
        prefs.setString("_OthAmt", AccountSummary.OthAmt);
        prefs.setString("_HigherAmt", AccountSummary.HigherAmt);
        prefs.setString("_Remark", AccountSummary.Remark);
        prefs.setString("_DaAmt", AccountSummary.DaAmt);
        prefs.setString("_BoardAmt", AccountSummary.BoardAmt);
        prefs.setString("_AdvAmt", AccountSummary.AdvAmt);
        prefs.setString("_TotAmt", AccountSummary.TotAmt);
        prefs.setString("_ClaimParaID", AccountSummary.ClaimParaID);
        prefs.setString("_AdvanceID", AccountSummary.AdvanceID);
        prefs.setString(
            "_TrainConnectDataDeduct", AccountSummary.TrainConnectDataDeduct);
        prefs.setString("_OtherDeduct", AccountSummary.OtherDeduct);
        prefs.setString("_LocalConAmt", AccountSummary.LocalConAmt);
        prefs.setString("_Empid", AccountSummary.Empid);
        prefs.setString("_TrvId", AccountSummary.TrvId);
        prefs.setString("_Currlvl", AccountSummary.Currlvl);
        prefs.setString("_ApprovalLevelID", AccountSummary.ApprovalLevelID);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TravelClaimSecondStatus(
                    JJourney: journey,
                    localConvenecy: Localconvency,
                    otherexpense: OtherExpense,
                    summarydetails: Summaryy,
                    boardgingdata: Boardgingdata,
                    TravelID: Viewadata.toString())));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      await EasyLoading.dismiss();
      Alert_DialogBox.showAlert(context, "Server Error");
      print('Error: $e');
    }
  }

  void _view(AttendApprovell item) {
    try {
      // Navigator.pop(context);

      String itemmm = item.UrlString;

      List<String> splitDte = itemmm.toString().split("=");

      String _selectedFromDate = splitDte[2];
      List<String> splitDtee = _selectedFromDate.toString().split("&");
      Viewadata = splitDtee[0];

      ViewClaim(Viewadata.toString());

      //ViewClaim(Viewadata);
    } catch (e) {
      print('Error: $e');
    }
  }
}

Widget buildTextFieldd(String Textlabel, String DataText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            Textlabel,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "TimesNewRoman",
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              DataText,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "TimesNewRoman",
                color: secondaryColor,
              ),
            ),
          ),
        ],
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

class AttendApprovell {
  String Empid;
  String claimCode;
  String EmployeeName;
  String DateRange;
  String RequestDate;
  String ClaimType;
  String ReqCost;
  String UrlString;

  AttendApprovell(
      {required this.Empid,
      required this.claimCode,
      required this.EmployeeName,
      required this.DateRange,
      required this.RequestDate,
      required this.ClaimType,
      required this.ReqCost,
      required this.UrlString});

  factory AttendApprovell.fromJson(Map<String, dynamic> json) {
    return AttendApprovell(
        Empid: json['Empid'].toString(),
        claimCode: json['claimCode'],
        EmployeeName: json['EmployeeName'],
        DateRange: json['DateRange'],
        RequestDate: json['RequestDate'],
        ClaimType: json['ClaimType'],
        ReqCost: json['ReqCost'].toString(),
        UrlString: json['UrlString'].toString());
  }
}

class AttendHistory {
  String Claimtype;
  String empCode;
  String eName;
  String ClaimCode;
  String ClaimFDate;
  String ClaimTDate;
  int Amount;
  int ClaimID;
  String ClaimStatusName;
  String ClaimStatus;
  int ClaimTypeID;
  int Level;
  int UserID;
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
        Amount: json['Amount'],
        ClaimID: json['ClaimID'],
        ClaimStatusName: json['ClaimStatusName'],
        ClaimStatus: json['ClaimStatus'],
        ClaimTypeID: json['ClaimTypeID'],
        Level: json['Level'],
        UserID: json['UserID'],
        RequestDate: json['RequestDate'],
        IsReEdit: json['IsReEdit'],
        ClaimURL: json['ClaimURL']);
  }
}
