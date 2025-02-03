import 'dart:convert';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/FastTagRecharge/Successfully.dart';
import 'package:ehr/bbps/FastTagRecharge/fasttage.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FastTagFatchBill extends StatefulWidget {
  final List<FastTagInfo> fastTagInfoList;

  FastTagFatchBill({required this.fastTagInfoList});
  @override
  State<StatefulWidget> createState() => _FastTagFatchBill();
}

class _FastTagFatchBill extends State<FastTagFatchBill> {
  @override
  void initState() {
    super.initState();
    dataFound();
    // OnFatchBill();
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BILLERID = prefs.getString("BillerID") ?? '';
      AMOUNTENTER = prefs.getString("AMOUNT") ?? '';

      AccountBalance = prefs.getString("AccountBalance") ?? '';
     // accountnumber = prefs.getString("AccountNUMber") ?? '';
      billamountApi = prefs.getString("BillAMOUNT") ?? '';
      RequestID = prefs.getString("RequestID") ?? '';
      ronak = prefs.getString("ronak") ?? '';

  
    });
  }

  String BILLERID = "";
  String AMOUNTENTER = "";
  String AccountBalance = "";
  String accountnumber = "";
  String RequestID = "";
  String Message = "";

  String ronak = "";

  String billamountApi = "";
  String Customename = "";

  // List<FastTagInfo> fastTagInfoList = [];

  TextEditingController AmountTxt = TextEditingController();

  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FastTag()),
    );

    // Prevent the default back button behavior
    return false;
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
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Fatch Bill",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FastTag()),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              backgroundColor: const Color(0xFF0057C2),
              actions: [
                Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            'assets/images/BAssu.jpg', width: 50, 
                          ),
                        ),
                      ),
              ],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Text(
                          "Amount",
                          style: TextStyle(
                              color: Color(0xFF0057C2),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextFormField(
                            controller: AmountTxt,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight
                                    .bold // Set the color for the input text
                                ),
                            decoration: const InputDecoration(
                              hintText: "Enter Amount",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.fastTagInfoList.length,
                          itemBuilder: (context, index) {
                            final payee = widget.fastTagInfoList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          payee.infoName,
                                          style: const TextStyle(
                                            color: Color(0xFF0057C2),
                                            fontSize: 16,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          payee.description,
                                          style: const TextStyle(
                                            color: Color(0xFF0057C2),
                                            fontSize: 16,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () async {

                            if (AmountTxt.text == null ||
                                  AmountTxt.text == "") {
                                Message = "Please Enter Amount ";
                                DialogboxAlertt(Message);
                                return;
                              }
                          OnSubmitButton();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0057C2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _getButtonFontSize(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void DialogboxAlert(String message) {
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
        });
      },
    );
  }

  void Dialgbox(String MESSAGE) {
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
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                MESSAGE,
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
        });
      },
    );
  }

  // API Code............................................................

  void DialogboxAlertt(String message) {
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
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => FastTag()));
                  },
                  child: const Text(
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
        "customerMobile": "7014133057",
        "amount": AmountTxt.text,
        "billerId": BILLERID,
        "custConvFee": "",
        "ip": "",
        "customeraccountnumber": "",
        "Remark": "",
        "Custid": empKid,
        "userid": useridd,
        "accNo": accountnumber.toString(),  // replace with patment txn id 
        "email": "",
        "date": "",
        "vendorId": "",
        "activityId": "",
        "mode": "",
        "type": "Fastag",
        "custRole": "",
        "brnCode": empBranchcode,
        "mobile": "",
        "IFSC": empBranchcode,
        "paymentMode": "Internet Banking",
        "requestId": RequestID.toString(),
        "billAmount": AmountTxt.text,
        "dueDate": "",
        "billDate": "",
        "billNumber": "NA",
        "customerName": "",
        "billPeriod": "NA",
        "Paramvalue": AMOUNTENTER.toString(),
        "info": ronak
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
            Map<String, dynamic> billData = responseData["Data"][0];

            String RespCustomerName = billData["RespCustomerName"].toString();
            String RespAmount = billData["RespAmount"].toString();
            String responseCode = billData["responseCode"].toString();
            String txnRespType = billData["txnRespType"].toString().trim();
            String responseReason = billData["responseReason"].toString();
            String requestId = billData["requestId"].toString();
            String txnRefId = billData["txnRefId"].toString();
            String approvalRefNumber = billData["approvalRefNumber"].toString();
            String CustConvFee = billData["CustConvFee"].toString();

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillAmount", RespAmount);
            prefs.setString("CustomeName", RespCustomerName);
            prefs.setString("responseReason", responseReason);
            prefs.setString("approvalRefNumber", approvalRefNumber);

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SuccessfullyFastag()));
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
        //  Loader.hide();
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
}

class FastTagInfo {
  String infoName;
  String description;

  FastTagInfo({required this.infoName, required this.description});

  factory FastTagInfo.fromJson(Map<String, dynamic> json) {
    return FastTagInfo(
      infoName: json['infoName'],
      description: json['description'],
    );
  }
}
