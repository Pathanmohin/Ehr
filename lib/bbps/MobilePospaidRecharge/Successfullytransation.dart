import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuccessfullyPostpaid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _mobileSuccessfullypostapid();
}

class _mobileSuccessfullypostapid extends State<SuccessfullyPostpaid> {
  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Recharge()),
    // );

    // Prevent the default back button behavior
    return false;
  }

  String RespCustomerName = '';
  String RespDueDate = "";
  String RespBillDate = "";
  String RespAmount = "";
  String responseCode = "";
  String txnRespType = "";
  String responseReason = "";
  String RespBillNumber = "";
  String approvalRefNumber = "";
  String RespBillPeriod = "";
  String CustConvFee = "";
  String txnRefId = "";
  String Requestid = "";

  @override
  void initState() {
    super.initState();
    dataFound();
    // updateNumberInWords();
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      RespCustomerName = prefs.getString("RespCustomerName") ?? '';
      RespDueDate = prefs.getString("RespDueDate") ?? '';
      RespBillDate = prefs.getString("RespBillDate") ?? '';
      RespAmount = prefs.getString("RespAmount") ?? '';
      responseCode = prefs.getString("responseCode") ?? '';
      txnRespType = prefs.getString("txnRespType") ?? '';
      responseReason = prefs.getString("responseReason") ?? '';
      RespBillNumber = prefs.getString("RespBillNumber") ?? '';
      txnRefId = prefs.getString("txnRefId") ?? '';
      approvalRefNumber = prefs.getString("approvalRefNumber") ?? '';
      RespBillPeriod = prefs.getString("RespBillPeriod") ?? '';
      CustConvFee = prefs.getString("CustConvFee") ?? '';
      Requestid = prefs.getString("RequestID") ?? '';
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
        child: Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    "Summary",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  backgroundColor: const Color(0xFF0057C2),
                  automaticallyImplyLeading: false,
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
                        const Center(
                          child: Text(
                            "Successfully Transaction",
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  "Customer Name:",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF0057C2)),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  RespCustomerName,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
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
                                  RespDueDate,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
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
                                  RespBillDate,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Amount:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  RespAmount,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Code:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  responseCode,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Transcation Type:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  txnRespType,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Status:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  responseReason,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Request Id:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  Requestid,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Bill Number:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  RespBillNumber,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("txn Refference Id:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  txnRefId,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Approval Ref Number:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  approvalRefNumber,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Bill Period:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  RespBillPeriod,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text("Customer Convenience Fee:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0057C2))),
                              ),
                              Flexible(
                                child: Text(
                                  CustConvFee,
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
                                top: 50.0,
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Add some spacing between the icon and the text

                                    Text(
                                      "Home",
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
        }));
  }
}
