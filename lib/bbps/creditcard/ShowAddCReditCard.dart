import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/creditcard/CeditSvaeData.dart';
import 'package:ehr/bbps/creditcard/CreditCard.dart';
import 'package:ehr/bbps/creditcard/FetchBillCreditCard.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/modeilcredit.dart';
import 'package:ehr/bbps/model/recharge.dart';

import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCreditCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowCreditCard();
}

class _ShowCreditCard extends State<ShowCreditCard> {

   String BillAmount = '';
  String DueDate = "";
  String CustomeName = "";
  String BillDate = "";
  String Remarks = "";
  String BillNumnber = "";
  String RequestID = "";
  String BillPeriod = "";
  String BILLERID = "";
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
  @override
  void initState() {
    super.initState();
    cardItems = CreditCARD.CARDNUMBER;
    dataFound();
  }

  List<CREDITSVAEDATA> cardItems = [];

  Future<bool> _onBackPressed() async {
    await Future.delayed(const Duration(milliseconds: 1));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BBPS()),
    );
    return false;
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

 // final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  String bankname = "";
  String creditcardnumber = "";
  String cutomername = "";
  String billerid = "";
  String cutomermobilenumber = "";
  String Message = "";
  var SECOND = '';
  var THIRD = '';

  final List<Rechargmobile> fromAccountList = <Rechargmobile>[];

 Widget _buildCardList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cardItems.length,
        itemBuilder: (context, index) {
          return CardWidget(
            item: cardItems[index],
            onPressed: () {
              setState(() {
                bankname = cardItems[index].BANKNAME.toString();
                creditcardnumber = cardItems[index].CREDITCARDNUMBER.toString();
                cutomername = cardItems[index].CustomerName.toString();
                billerid = cardItems[index].BillerID.toString();
                cutomermobilenumber =
                    cardItems[index].CutomerMobileNumber.toString();
              });

              OnFatchBill();
            },
          );
        },
      ),
    );
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
                "Credit Card",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
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
              backgroundColor: const Color(0xFF0057C2),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                      width: 55,
                      height: 45,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Image.asset("assets/images/Blogo.jpg")),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Column(children: [
                    Container(
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
                          _buildCardList(),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CreditCard()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0057C2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "PAY BILL",
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
                  ])),
            ),
          ),
        );
      }),
    );
  }

  void onFromAccount(String item) {
    print('Selected value: $item');
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

  Future<void> OnFatchBill() async {
    try {

      //Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // Password Ency.

      String CREDITCARDNUMBERR = creditcardnumber;

      String cleanedString = CREDITCARDNUMBERR.replaceAll(' ', '');

      // Get the last 4 digits
      String lastFourDigits = cleanedString.substring(cleanedString.length - 4);

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/creditcardfetchbill";

      String jsonString = jsonEncode({
        "Billerid": billerid,
        "Circle": "",
        "mobileno": cutomermobilenumber,
        "cardno": lastFourDigits,
        "billercat": "Credit Card",
        "ParamValue":"$THIRD,$SECOND",
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
          //var data = jsonDecode(response.body);
          // Map<String, dynamic> jsonData = jsonDecode(response.body);
          //  var a = responseData["Data"].toString());

          if (responseData["Result"] == "Sucess") {
            Loader.hide();
            var decryptedResult = responseData["Data"];
            Map<String, dynamic> billData = responseData["Data"][0];

            String billAmount = billData["billAmount"].toString();
            String requestId = billData["requestId"].toString();
            String DueDatee = billData["dueDate"].toString();
            String billDatee = billData["billDate"].toString();
            String billNumber = billData["billNumber"].toString();
            String customerName = billData["customerName"].toString().trim();
            String Minimumamountdue = responseData["info"].toString();
            // String RequestID = responseData["requestId"].toString();

            // List<dynamic> dataList = jsonDecode(Minimumamountdue);

            // for(int i =0 ;i< dataList.length;i++){

            // }

            
            // String minimumAmountDue = dataList.firstWhere((element) =>
            //     element['infoName'] == 'Minimum Amount Due')['description'];


            // String currentOutstandingAmount = dataList.firstWhere(
            //   (element) => element['infoName'] ==
            //     'Current Outstanding Amount')['description'];
            
                

            // String responseCode = billData["responseCode"].toString();
            // String billPeriod = billData["billPeriod"].toString();

            // DateFormat originalFormat = DateFormat('dd-MM-yyyy');
            // DateFormat targetFormat = DateFormat('yyyy-MM-dd');

            // DateTime originalDate = originalFormat.parse(DueDatee);
            // String DueDate = targetFormat.format(originalDate);

            // DateTime originalDatee = originalFormat.parse(billDatee);
            // String billDate = targetFormat.format(originalDatee);

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillAmount", billAmount);
            prefs.setString("CustomeName", customerName);
            prefs.setString("DueDate", DueDatee);
            prefs.setString("BillDate", billDatee);

            prefs.setString("BillNumnber", billNumber);
            prefs.setString("RequestID", requestId);
            prefs.setString("BillerID", BILLERID);
           // prefs.setString( "MobilenumberCustomet", MobileNumberCreditcard.text);
           // prefs.setString("Balance", amount);
           // prefs.setString("AccountNumber", FromAccountNumber);
            prefs.setString("Type", "BillPay");

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreditcardFatchBill()),
            );

          } else {
            Loader.hide();

            var decryptedResult = responseData["Data"] as List<dynamic>;
            var decryptedResultt = decryptedResult[0] as Map<String, dynamic>;

            String decryptedResulttt =
                decryptedResultt["errorMessage"] as String;

            Message = decryptedResulttt;
            DialogboxAlert(Message);
            return;
            // }
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
}

class CardWidget extends StatelessWidget {
  final CREDITSVAEDATA item;
  final VoidCallback onPressed;

  const CardWidget({Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0057C2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Bank Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.BANKNAME.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.CREDITCARDNUMBER.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
