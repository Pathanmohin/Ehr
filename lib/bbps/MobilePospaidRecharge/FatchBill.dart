import 'dart:convert';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/MobilePospaidRecharge/Successfullytransation.dart';
import 'package:ehr/bbps/MobilePospaidRecharge/mobilepostpaid.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FatchBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _fatchbill();
}

class _fatchbill extends State<FatchBill> {
  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostPaid()),
    );

    // Prevent the default back button behavior
    return false;
  }

  String BillAmount = '';
  String DueDate = "";
  String CustomeName = "";
  String BillDate = "";
  String Remarks = "";
  String BillNumnber = "";
  String RequestID = "";
  String BillPeriod = "";
  String CustomerMOBILENUMBER = "";
  String BILLERID = "";
  String Message = "";

  @override
  void initState() {
    super.initState();
    dataFound();
    // updateNumberInWords();
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BillAmount = prefs.getString("BillAmount") ?? '';
      CustomeName = prefs.getString("CustomeName") ?? '';
      DueDate = prefs.getString("DueDate") ?? '';
      BillDate = prefs.getString("BillDate") ?? '';
      BillNumnber = prefs.getString("BillNumnber") ?? '';
      RequestID = prefs.getString("RequestID") ?? '';
      BillPeriod = prefs.getString("BillPeriod") ?? '';
      CustomerMOBILENUMBER = prefs.getString("CustomerMobileNumber") ?? '';
      BILLERID = prefs.getString("BillerID") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    double _getButtonFontSize(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 600) {
        return 14.0; // Large screen
      } else if (screenWidth > 400) {
        return 15.0; // Medium screen
      } else {
        return 16.0; // Default size
      }
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Builder(
          builder: (context) {
            return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text(
                      "Fetch Bill",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    backgroundColor: const Color(0xFF0057C2),
                    actions: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            'assets/images/ass.png',
                          ),
                        ),
                      ),
                    ],
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BBPS()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                      //change your color here
                    ),
                  ),
                  body: SingleChildScrollView(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text(
                                    "Bill Amount:",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    BillAmount,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text(
                                    "Due Date:",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    DueDate,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text(
                                    "Bill Date:",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    BillDate,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text("Bill Number:",
                                      style: TextStyle(
                                          fontSize: 16, color: Color(0xFF0057C2))),
                                ),
                                Flexible(
                                  child: Text(
                                    BillNumnber,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text("Customer Name:",
                                      style: TextStyle(
                                          fontSize: 16, color: Color(0xFF0057C2))),
                                ),
                                Flexible(
                                  child: Text(
                                    CustomeName,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text("Bill Period:",
                                      style: TextStyle(
                                          fontSize: 16, color: Color(0xFF0057C2))),
                                ),
                                Flexible(
                                  child: Text(
                                    BillPeriod,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF0057C2)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                                child: SizedBox(
                              width: size.width * 0.9,
                              height: 2,
                              child: Center(
                                  child: Container(
                                color: Colors.black26,
                              )),
                            )),
                          ),
                          InkWell(
                            onTap: () async {
                              // Your onTap functionality here
              
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, left: 10.0, right: 10.0, bottom: 10.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0057C2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Add some spacing between the icon and the text
              
                                      Text(
                                        "PAY",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: _getButtonFontSize(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const SizedBox(width: 8),
                                      // Image.asset("assets/images/next.png"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
            );
          }
        ));
  }

  Future<void> _checkLatency() async {
    final stopwatch = Stopwatch()..start();

    try {
      var response = await http.get(Uri.parse('https://www.google.com/'));

      print(response.statusCode);

      stopwatch.stop();
      if (response.statusCode == 200) {
        if (stopwatch.elapsedMilliseconds > 5000) {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              headerBackgroundColor: Colors.yellow,
              title: 'Oops...',
              text:
                  "There’s a minor network issue at the moment. Click 'Yes' to keep your connection active, but be aware it might be risky. Select 'No' to log off securely.",
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              onConfirmBtnTap: () {
                Navigator.pop(context);

                OnSubmitButton();
              },
              onCancelBtnTap: () {
                Navigator.pop(context);
              },
              showCancelBtn: true,
              confirmBtnColor: Colors.green,
              barrierDismissible: false);
        } else {
          OnSubmitButton();
        }
      } else {
        OnSubmitButton();
      }
    } catch (e) {
      OnSubmitButton();
    }
  }

  Future<void> OnSubmitButton() async {
    try {
     SharedPreferences prefs = await SharedPreferences.getInstance();

       String empKid = prefs.getString('EmpKid') ?? ''; 
       String useridd = prefs.getString('userID') ?? ''; 
       String empBranchcode = prefs.getString('userID') ?? ''; 



      Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/PostpaidBillpay";

      String jsonString = jsonEncode({
        "customerMobile": CustomerMOBILENUMBER,
        "amount": BillAmount.toString(),
        "billerId": BILLERID,
        "BillerCat": "Mobile Postpaid",
        "custConvFee": "",
        "ip": "",
        "customeraccountnumber": "",   // replace with txn id
        "Remark": "",
        "Custid": empKid,
        "userid":useridd,
        "accNo": "",
        "email": "",
        "date": "",
        "vendorId": "",
        "activityId": "",
        "mode": "",
        "type": "",
        "custRole": "",
        "brnCode": empBranchcode,
        "mobile": "",
        "IFSC": empBranchcode,
        "paymentMode": "payment gateway",
        "requestId": RequestID,
        "dueDate": DueDate,
        "billDate": BillDate,
        "billNumber": BillNumnber,
        "customerName": CustomeName,
        "billPeriod": BillPeriod,
        "Paramvalue": "",
        "billAmount": BillAmount.toString(),
      });

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
      };

      // Convert data to JSON

      String encrypted =
          AESencryption.encryptString(jsonString, Constants.AESENCRYPTIONKEY);

      final parameters = <String, dynamic>{
        "data": jsonString,
      };

      try {
        // Make POST request
        var response = await http.post(
          Uri.parse(apiUrl),
          body: jsonString,
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
        );

        // Check if request was successful
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData["Result"] == "Sucess") {
            Loader.hide();
            var decryptedResult = responseData["Data"];

            Map<String, dynamic> billData = responseData["Data"][0];

            String RespCustomerName = billData["RespCustomerName"].toString();
            String RespDueDate = billData["RespDueDate"].toString();
            String RespBillDate = billData["RespBillDate"].toString();
            String RespAmount = billData["RespAmount"].toString();
            String responseCode = billData["responseCode"].toString();
            String txnRespType = billData["txnRespType"].toString().trim();
            String responseReason = billData["responseReason"].toString();
            String RespBillNumber = billData["RespBillNumber"].toString();
            String txnRefId = billData["txnRefId"].toString();
            String approvalRefNumber = billData["approvalRefNumber"].toString();
            String RespBillPeriod = billData["RespBillPeriod"].toString();
            String CustConvFee = billData["CustConvFee"].toString();

            DateFormat originalFormat = DateFormat('dd-MM-yyyy');
            DateFormat targetFormat = DateFormat('yyyy-MM-dd');

            DateTime originalDate = originalFormat.parse(RespDueDate);
            String postpaidDueDate = targetFormat.format(originalDate);

            DateTime originalDatee = originalFormat.parse(RespBillDate);
            String PostpaidBilldate = targetFormat.format(originalDatee);

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("RespCustomerName", RespCustomerName);
            prefs.setString("RespDueDate", postpaidDueDate);
            prefs.setString("RespBillDate", PostpaidBilldate);
            prefs.setString("RespAmount", RespAmount);
            prefs.setString("responseCode", responseCode);
            prefs.setString("txnRespType", txnRespType);
            prefs.setString("responseReason", responseReason);
            prefs.setString("RespBillNumber", RespBillNumber);
            prefs.setString("txnRefId", txnRefId);
            prefs.setString("approvalRefNumber", approvalRefNumber);
            prefs.setString("RespBillPeriod", RespBillPeriod);
            prefs.setString("CustConvFee", CustConvFee);
            prefs.setString("RequestID", RequestID);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuccessfullyPostpaid()));
          } else {
            Loader.hide();
            var decryptedResult = responseData["Data"] as List<dynamic>;
            var decryptedResultt = decryptedResult[0] as Map<String, dynamic>;

            String decryptedResulttt =
                decryptedResultt["errorMessage"] as String;

            Message = decryptedResulttt;
            DialogboxAlert(Message);
            return;
          }
        } else {
          Loader.hide();
          Message = "Server Failed....!";
          DialogboxAlert(Message);
          return;
        }
      } catch (error) {
        Loader.hide();
        Message = "Server Failed....!";
        DialogboxAlert(Message);
        return;
      }
    } catch (e) {
      Loader.hide();
      Message = "Unable to Connect to the Server";
      DialogboxAlert(Message);
      return;
    }
  }

  void DialogboxAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
              child: AlertDialog(
                title: const Text(
                  'Alert',
                  style: TextStyle(fontSize: 16),
                ),
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
