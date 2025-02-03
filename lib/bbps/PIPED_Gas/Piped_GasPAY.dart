import 'dart:convert';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/PIPED_Gas/PipedGas.dart';
import 'package:ehr/bbps/PIPED_Gas/Piped_GasSummary.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PipedGas_Fatch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => pipedGasBooking();
}

class pipedGasBooking extends State<PipedGas_Fatch> {
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
      accountnumber = prefs.getString("AccountNUMber") ?? '';
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

  String ronak = "";
  String Message="";

  String billamountApi = "";
  String Customename = "";

  String consumerNo = "";
  String lpgbiller = "";
  String consumerName = "";
  String billamtt = "";
  String payAmt = "";
  // String consumerNo="";

  // TextEditingController consumerNo = TextEditingController();
  // TextEditingController lpg_biller = TextEditingController();

  // TextEditingController consumerName = TextEditingController();
  // TextEditingController BillAmout = TextEditingController();

  // TextEditingController payAmt = TextEditingController();

  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pipedGass()),
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
            appBar: AppBar(
              title: const Text(
                "Piped Gas",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pipedGass()),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.asset(
                      'assets/images/ass.png',
                      width: 85,
                      height: 75,
                    ),
                  ),
                ),
              ],
              backgroundColor: const Color(0xFF0057C2),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '9602767203',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Torrent Gas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(100.0),
                            color: Colors.white),
                        child: Image.asset("assets/images/BBPS_Logo.png")),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Text(
                      'Bill Payment for',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    'BRAJ KISHORE MORYA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '₹806.5',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0057C2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bill amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => pipedGasSumaary()));
                      // OnSubmitButton();
                    },
                    child: const Text(
                      'Pay ₹806.5',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0057C2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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

  Future<void> OnSubmitButton() async {
    try {


      Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/PostpaidBillpay";

      String jsonString = jsonEncode({
        "customerMobile": "7014133057",
        "amount": "", // Bill Amt
        "billerId": BILLERID,
        "custConvFee": "",
        "ip": "",
        "customeraccountnumber": "",
        "Remark": "",
        "Custid": AppInfoLogin.customerId,
        "userid": AppInfoLogin.Userid,
        "accNo": accountnumber.toString(),
        "email": "",
        "date": "",
        "vendorId": "",
        "activityId": "",
        "mode": "",
        "type": "Fastag",
        "custRole": "",
        "brnCode": AppInfoLogin.BranchCode,
        "mobile": "",
        "IFSC": AppInfoLogin.branchIFSC.trim(),
        "paymentMode": "Internet Banking",
        "requestId": RequestID.toString(),
        "billAmount": "", // bill amt
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

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => SuccessfullyFastag()));
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
