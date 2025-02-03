import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ehr/bbps/MobileRecharge/mobilerecharge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CCAvenuePaymentPage extends StatefulWidget {
  @override
  _CCAvenuePaymentPageState createState() => _CCAvenuePaymentPageState();
}

class _CCAvenuePaymentPageState extends State<CCAvenuePaymentPage> {
   String Message = "";
  late InAppWebViewController _webViewController;

  // Replace with your CCAvenue credentials
  final String merchantId = "269695";
  final String accessCode = "AVKS82GA65AF50SKFA";
  final String workingKey = "CECF391C37CB66771391AFCF9A39727C";
  final String redirectUrl = "https://www.precisecart.com";
  final String cancelUrl = "https://www.precisecart.com";

  String paymentUrl = "";

  @override
  void initState() {
    super.initState();
    _generateChecksum();
  }

  Future<void> _generateChecksum() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique Order ID
    String amount = "100.00"; // Example amount
    String currency = "INR";

    // Build the data string for checksum
    String data =
        "merchant_id=$merchantId&order_id=$orderId&amount=$amount&currency=$currency&redirect_url=$redirectUrl&cancel_url=$cancelUrl";

    // Generate checksum (this should ideally be done on a server)
    String checksum = _generateChecksumLocally(data, workingKey);
    
    // Build the payment URL
    setState(() {
       paymentUrl =
          "https://www.precisecart.com/CobaSys/PaymentCollection.do?action=paymentCollect&Vendor=269695&RegNo=1022&EmailID=arun@gmail.com&Name=Arun%20Kumar&MobileNo=9625607031&Activity=Provisional&TransactionAmount=2461&referenceNo=33376133346&Checksum=97AB215D012A642407F53FF5014304BDAC3C347411E3BD7FE24B495EF92111A2EA708B3427DBB7205C1B350838D953B4C230C5C92F274C03FED4B709FF0A6C48&deptName=State%20Council%20of%20Homoeopathic%20System%20of%20Medicine&CallBackURL=http://application.hphomoeopathy.in//paymentHandler.action";


      // paymentUrl =
      //     "https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction&merchant_id=$merchantId&order_id=$orderId&amount=$amount&currency=$currency&redirect_url=$redirectUrl&cancel_url=$cancelUrl&checksum=$checksum&access_code=$accessCode";
    });
  }

  String _generateChecksumLocally(String data, String key) {
    // Generate checksum using HMAC SHA256
    var keyBytes = utf8.encode(key);
    var dataBytes = utf8.encode(data);
    var hmacSha256 = Hmac(sha256, keyBytes);
    var digest = hmacSha256.convert(dataBytes);
    return base64.encode(digest.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CCAvenue Payment', style: TextStyle(color: Colors.white),),  backgroundColor: const Color(0xFF0057C2),
       leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recharge()),
                );
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),),
       
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(

                 initialUrlRequest: URLRequest(
                        url: WebUri(
                          paymentUrl),
                      ),

                        initialSettings: InAppWebViewSettings(
                       javaScriptEnabled: true,
                          supportZoom: false,
                          builtInZoomControls: true,
                          displayZoomControls: true,
                          verticalScrollBarEnabled: true,
                          overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
                          pageZoom: 10,
                          textZoom: 120,
                          useWideViewPort: true,  // ✅ Helps with scrolling
                          loadWithOverviewMode: true, // ✅ Helps with scaling
                        ),

                   gestureRecognizers: { Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()) },

                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                // onLoadStop: (controller, url) async {
                //   // Inject JavaScript to set zoom scale to 200%
                //   await controller.evaluateJavascript(
                //       source: "document.body.style.zoom = '2';");
                // },
                onLoadStop: (controller, url) async {
                  if (url.toString() == redirectUrl) {
                    // Detect redirect to the success URL
                   // await OnSubmitButton(); // Call your GetBiller method
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Status"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, message);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  
  // Future<void> OnSubmitButton() async {
  //   try {
  //      SharedPreferences prefs = await SharedPreferences.getInstance();
  //     ServerDetails serverDetails = ServerDetails();
  //   String ip = serverDetails.getIPaddress();
  //   String port = serverDetails.getPortBBPS();
  //   String protocol = serverDetails.protocol();
  //      String? deviceId = await PlatformDeviceId.getDeviceId;
  //      String empKid = prefs.getString('EmpKid') ?? ''; 
  //      String useridd = prefs.getString('userID') ?? ''; 
  //      String empBranchcode = prefs.getString('userID') ?? ''; 

  //     Loader.show(context, progressIndicator: CircularProgressIndicator());

  //     // API endpoint URL

  //     String apiUrl = "$protocol$ip$port/rest/BBPSService/Billpay";

  //     String jsonString = jsonEncode({
  //       // "customerMobile": txtMobileNumber.text,
  //       // "amount": txtAmount.text,
  //       // "billerId": BILLERID,
  //       "Custid": empKid,
  //       "userid": useridd,
  //       "accNo": "",   // replace with payment geteway success txn id 
  //       "brnCode": empBranchcode,  //  emp branche code
  //       "custConvFee": "",
  //       "ip": "",
  //       "customeraccountnumber": "",
  //       "Remark": "",
  //       "email": "",
  //       "date": "",
  //       "vendorId": "",
  //       "activityId": "",
  //       "mode": "",
  //       "type": "",
  //       "custRole": "",
  //       "mobile": "",
  //     });

  //     Map<String, String> headers = {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     };

  //     // Convert data to JSON

  //     String encrypted =
  //         AESencryption.encryptString(jsonString, Constants.AESENCRYPTIONKEY);

  //     final parameters = <String, dynamic>{
  //       "data": jsonString,
  //     };

  //     try {
  //       // Make POST request
  //       var response = await http.post(
  //         Uri.parse(apiUrl),
  //         body: jsonString,
  //         headers: headers,
  //         encoding: Encoding.getByName('utf-8'),
  //       );

  //       // Check if request was successful
  //       if (response.statusCode == 200) {
  //         Map<String, dynamic> responseData = jsonDecode(response.body);
  //         if (responseData["Result"] == "Sucess") {
  //           Loader.hide();
  //           var decryptedResult = responseData["Data"];

  //           Map<String, dynamic> billData = responseData["Data"][0];

  //           String RespCustomerName = billData["RespCustomerName"].toString();
  //           String RespDueDate = billData["RespDueDate"].toString();
  //           String RespBillDate = billData["RespBillDate"].toString();
  //           String RespAmount = billData["RespAmount"].toString();
  //           String responseCode = billData["responseCode"].toString();
  //           String txnRespType = billData["txnRespType"].toString().trim();
  //           String responseReason = billData["responseReason"].toString();
  //           String requestId = billData["requestId"].toString();
  //           String RespBillNumber = billData["RespBillNumber"].toString();
  //           String txnRefId = billData["txnRefId"].toString();
  //           String approvalRefNumber = billData["approvalRefNumber"].toString();
  //           String RespBillPeriod = billData["RespBillPeriod"].toString();
  //           String CustConvFee = billData["CustConvFee"].toString();

  //           DateFormat originalFormat = DateFormat('yyyy-MM-dd');
  //           DateFormat targetFormat = DateFormat('dd-MM-yyyy');

  //           DateTime originalDate = originalFormat.parse(RespDueDate);
  //           String RESPONSDUEDATE = targetFormat.format(originalDate);

  //           DateTime originalDatee = originalFormat.parse(RespBillDate);
  //           String RESPONSEBILLDATE = targetFormat.format(originalDatee);



  //           final prefs = await SharedPreferences.getInstance();

  //           prefs.setString("BillAmount", RespAmount);
  //           prefs.setString("CustomeName", RespCustomerName);
  //           prefs.setString("DueDate", RESPONSDUEDATE);
  //           prefs.setString("BillDate", RESPONSEBILLDATE);

  //           prefs.setString("BillNumnber", RespBillNumber);
  //           prefs.setString("RequestID", requestId);
  //           prefs.setString("BillPeriod", RespBillPeriod);
  //           prefs.setString("txnRespTypee", txnRespType);
  //           prefs.setString("responseReasonn", responseReason);
  //           prefs.setString("RespBillPeriodd", RespBillPeriod);
  //           prefs.setString("CustConvFeee", CustConvFee);
  //           prefs.setString("txnRefIdd", txnRefId);
  //           prefs.setString("responseCode", responseCode);
  //           prefs.setString("RespBillNumber", RespBillPeriod);

  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => Successfully()));
  //         } else {
  //           Loader.hide();
  //           var decryptedResult = responseData["Data"] as List<dynamic>;
  //           var decryptedResultt = decryptedResult[0] as Map<String, dynamic>;

  //           String decryptedResulttt =
  //               decryptedResultt["errorMessage"] as String;

  //           Message = decryptedResulttt;
  //           DialogboxAlert(Message);
  //           return;
  //         }
  //       } else {
  //         Loader.hide();
  //         Message = "Server Failed....!";
  //         DialogboxAlert(Message);
  //         return;
  //       }
  //     } catch (error) {
  //       Loader.hide();
  //       Message = "Server Failed....!";
  //       DialogboxAlert(Message);
  //       return;
  //     }
  //   } catch (e) {
  //     Loader.hide();
  //     Message = "Unable to Connect to the Server";
  //     DialogboxAlert(Message);
  //     return;
  //   }
  // }

   void DialogboxAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }
}
