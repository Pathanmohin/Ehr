import 'dart:convert';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/creditcard/CreditCard.dart';
import 'package:ehr/bbps/creditcard/ShowAddCReditCard.dart';
import 'package:ehr/bbps/creditcard/SucessScreenCredit.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreditcardFatchBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditcardFatchBill();
}

class _CreditcardFatchBill extends State<CreditcardFatchBill> {
  String BillAmount = '';
  String DueDate = "";
  String CustomeName = "";
  String BillDate = "";
  String Remarks = "";
  String BillNumnber = "";
  String RequestID = "";
  String BillPeriod = "";
  String BILLERID = "";
  String Message = "";
  String CustomermobileNumber = "";
  String AccountBalance = "";
  String ACCOUNTNUMBER = "";
  String TYPE = "";
  String Name = "";
  var FromAccountNumber;
  bool CreditCARDACCOUNT = false;
  String selectAccountBalance = "";
  String AccountBalancee = "";
  String ACCOUNTBALANCESELECT = "";
  String accountnumber = "";
  String creditcardnumber = "";

  @override
  void initState() {
    super.initState();
    dataFound();
    // updateNumberInWords();
  }



 // final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BillAmount = prefs.getString("BillAmount") ?? '';
      CustomeName = prefs.getString("CustomeName") ?? '';
      DueDate = prefs.getString("DueDate") ?? '';
      BillDate = prefs.getString("BillDate") ?? '';
      BillNumnber = prefs.getString("BillNumnber") ?? '';
      RequestID = prefs.getString("RequestID") ?? '';
      BILLERID = prefs.getString("BillerID") ?? '';
      CustomermobileNumber = prefs.getString("MobilenumberCustomet") ?? '';
     // AccountBalance = prefs.getString("Balance") ?? '';
     // ACCOUNTNUMBER = prefs.getString("AccountNumber") ?? '';
      TYPE = prefs.getString("Type") ?? '';
      creditcardnumber = prefs.getString("CardNumber") ?? '';

      // else if(TYPE =="AlreadyREgister"){
      //   Name=
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    // if (TYPE == "register") {
    //   Name = "HOME";
    // } else if (TYPE == "BillPay") {
    //   Name = "PAY NOW";
    // } else if (TYPE == "Billpaypast") {}

    if (TYPE == "Registercard") {
      CreditCARDACCOUNT == true;
    } else {
      CreditCARDACCOUNT == false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Fatch Bill",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            if (TYPE == "Registercard") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowCreditCard()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreditCard()));
            }
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF0057C2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
                width: 55,
                height: 45,
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white),
                child: Image.asset("assets/images/Blogo.jpg")),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              //width: size.width,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                   


                    _buildDetailRow('CONSUMER NAME', CustomeName),
                    // _buildDetailRow('MOBILE NUMBER', '701413305),
                    _buildDetailRow('BILL DUE DATE', DueDate),
                    _buildDetailRow('BILL DATE', BillDate),
                    //  _buildDetailRow('MINIMUM AMOUNT DUE', BillAmount),
                    // _buildDetailRow('CURRENT OUTSTANDING AMOUNT', '₹4394.69'),
                    // SizedBox(height: 8),
                    // Divider(),
                    _buildDetailRow('AMOUNT', "\u{20B9}" + BillAmount),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              // if (Name == "HOME") {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => CreditCard()));
              // } else if (Name == "PAY NOW") {
              //   OnSubmitButton();
              // }

             

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
                    "PAY NOW",
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
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

 

  Future<void> OnSubmitButton() async {
    try {
     
     

    SharedPreferences prefs = await SharedPreferences.getInstance();

       String empKid = prefs.getString('EmpKid') ?? ''; 
       String useridd = prefs.getString('userID') ?? ''; 
       String empBranchcode = prefs.getString('userID') ?? '';

      Loader.show(context,
          progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/PostpaidBillpay";

      String jsonString = jsonEncode({
        "customerMobile": CustomermobileNumber,
        "amount": BillAmount,
        "billerId": BILLERID,
        "billAmount": BillAmount,
        "custConvFee": "",
        "ip": "",
        "customeraccountnumber": "",
        "Remark": "",
        "Custid": empKid,
        "userid": useridd,
        "accNo": accountnumber,  // replace with payment txn id 
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
        "billNumber": "",
        "customerName": CustomeName,
        "billPeriod": "",
        "Paramvalue": creditcardnumber,
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
            String RespDueDate = billData["RespDueDate"].toString();
            String RespBillDate = billData["RespBillDate"].toString();
            String RespAmount = billData["RespAmount"].toString();
            String responseCode = billData["responseCode"].toString();
            String txnRespType = billData["txnRespType"].toString().trim();
            String responseReason = billData["responseReason"].toString();
            String requestId = billData["requestId"].toString();
            String RespBillNumber = billData["RespBillNumber"].toString();
            String txnRefId = billData["txnRefId"].toString();
            String approvalRefNumber = billData["approvalRefNumber"].toString();
            String RespBillPeriod = billData["RespBillPeriod"].toString();
            String CustConvFee = billData["CustConvFee"].toString();

            DateFormat originalFormat = DateFormat('yyyy-MM-dd');
            DateFormat targetFormat = DateFormat('dd-MM-yyyy');

            DateTime originalDate = originalFormat.parse(RespDueDate);
            String ElectricitDueDate = targetFormat.format(originalDate);

            DateTime originalDatee = originalFormat.parse(RespBillDate);
            String ElectricityBilldate = targetFormat.format(originalDatee);

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillAmount", RespAmount);
            prefs.setString("CustomeName", RespCustomerName);
            prefs.setString("DueDate", ElectricitDueDate);
            prefs.setString("BillDate", ElectricityBilldate);
            prefs.setString("BillNumnber", RespBillNumber);
            prefs.setString("RequestID", requestId);
            prefs.setString("txnRespType", txnRespType);
            prefs.setString("responseReason", responseReason);
            prefs.setString("approvalRefNumber", approvalRefNumber);

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SuccessfullyCredit()));
          }
          // else if(Result=="Faisl")
          else {
            Loader.hide();
            if (responseData["message"] == null || responseData["Data"] == "") {
              var decryptedResult = responseData["Data"] as List<dynamic>;
              var decryptedResultt = decryptedResult[0] as Map<String, dynamic>;
//"{"message":"Technical Issue Please Try After Some time.","Result":"Fail"}"

              String decryptedResulttt =
                  decryptedResultt["errorMessage"] as String;

              Message = decryptedResulttt;
              DialogboxAlert(Message);
              return;
            } else {
              var decryptedResult = responseData["message"];
              Message = decryptedResult;
              DialogboxAlert(Message);
            }
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
}


