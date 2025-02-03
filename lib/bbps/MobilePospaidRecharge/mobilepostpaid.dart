import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/MobilePospaidRecharge/FatchBill.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PostPaid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RechargemobilePostPaid();
}

class _RechargemobilePostPaid extends State<PostPaid> {
  void initState() {
    // TODO: implement initState
    getbillers();
    super.initState();
  }

  @override
 

  void ToAccount(String item) {
    // Handle the selection change

    print('Selected value: $item');
  }

  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(const Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BBPS()),
    );

    // Prevent the default back button behavior
    return false;
  }

  String Message = "";
  String Alert = "";
  String AccountholderName = "";
  String BILLERNAME="";

  String amount = "";
  String fromvalue = "";
  String Name = "Mobile number";
  String BILLERID ="";

  var toSelectedValue;
  var fromSelectedValue;
  var FastTagProvider;

 // final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  final List<Rechargmobile> fromAccountList = <Rechargmobile>[];
  List<String> Ronaknyariya = [];

  final txtName = TextEditingController();
  final txtBeneficiry = TextEditingController();
  final txtOTP = TextEditingController();

  final txtAmount = TextEditingController();

  final txtRemark = TextEditingController();
  final txtMobileNumber = TextEditingController();
  bool balance = false;
  String Billerkid = "";

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
                title:  const Text(
                  "Mobile PostPaid",
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
                        decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(100.0),
                            color: Colors.white),
                        child: Image.asset("assets/images/Blogo.jpg")),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Column(
                    children: [
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
                           
                            
                           Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: DropdownSearch<Rechargmobile>(
                                    dropdownDecoratorProps: const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        hintText: 'Select Biller Name',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal:
                                                10), // Ensure proper padding
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    items:
                                        fromAccountList, // List of Rechargmobile objects
                                    itemAsString: (Rechargmobile obj) =>
                                        obj.biller_name ?? 'Unknown Provider',
                                    selectedItem: FastTagProvider,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true, // Enables the search box
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search provider', // Placeholder text in search box
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal:
                                                  10), // Adjust height in search box
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    8)), // Constant border radius
                                          ),
                                        ),
                                      ),
                                    ),
                                    dropdownBuilder: (context, selectedItem) {
                                      return Text(
                                        selectedItem?.biller_name ??
                                            'Select Biller Name',
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // Customize the selected value text color
                                          fontSize: 15,
                                        ),
                                      );
                                    },
                                    onChanged: (newValue) {
                                      setState(() {
                                        FastTagProvider = newValue!;
                                      });
                      
                                      BILLERID = newValue!.biller_id.toString();
                                       BILLERNAME =
                                          newValue!.biller_name.toString();
                      
                                      ToAccount(BILLERID);
                                    },
                                  ),
                                ),
                              ),
                            const Visibility(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      color: Color(0xFF0057C2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Visibility(
                              child: Padding(
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
                                    keyboardType: TextInputType.number,
                                    controller: txtMobileNumber,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number",
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                      onFieldSubmitted: (value) {},
                                  ),
                                ),                                             
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                 if (BILLERID == null ||
                                    BILLERID == "") {
                                  Message = "Please Select Biller";
                                  DialogboxAlert(Message);
                                  return;
                                } else if (txtMobileNumber.text.length > 10 ||
                                    txtMobileNumber.text.trim().length < 10) {
                                  Message = "Please Enter 10 digits mobile number";
                                  DialogboxAlert(Message);
                                  return;
                                }
                               
                                FetchBill();
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
                                      "FETCH BILL",
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
                      const SizedBox(height: 300,),
                     Image.asset(
        'assets/images/BharatLogo.jpg', // Replace with your image path
        width: 200,
        
        fit: BoxFit.contain,
      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void onFromAccount(String item) {
    print('Selected value: $item');
  }

  void Dialgbox(String MESSAGE) {
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
          }
        );
      },
    );
  }

// API Code............................................................

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

  Future<void> getbillers() async {
    try {
       
      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/AccountService/Getbilleroperator";

      String jsonString = jsonEncode({
        "billerCat": "Mobile Postpaid",
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
          // Loader.hide();
          Map<String, dynamic> responseData = jsonDecode(response.body);

          var b = responseData["Result"].toString();
          var js = responseData["data"];
          List<dynamic> jsonResponse = jsonDecode(responseData["data"]);

          int all = 0;
          for (var config in jsonResponse) {
            //var test[] = new SimpleObject();

            Rechargmobile vObject = new Rechargmobile();

            vObject.biller_id = config["biller_id"];
            vObject.biller_name = config["biller_name"];

            //accounts.insert(all, vObject);
            fromAccountList.add(vObject);

            // all = all + 1;
          }
        } else {
          // Loader.hide();

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
                      content: const Text(
                        "Server Failed....!",
                        style: TextStyle(fontSize: 16),
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
      } catch (error) {
        //  Loader.hide();

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
                    content: const Text(
                      "Server Failed....!",
                      style: TextStyle(fontSize: 16),
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
    } catch (e) {
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
                  content: const Text(
                    "Unable to Connect to the Server",
                    style: TextStyle(fontSize: 16),
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

  Future<void> FetchBill() async {
    try {
      Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/fetchbill";

      String jsonString = jsonEncode({
        "Billerid": BILLERID,
        "Circle": "",
        "mobileno": txtMobileNumber.text,
        "paramvalue": txtMobileNumber.text,
        "billercat": "Mobile Postpaid",
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
          // var a = jsonDecode(responseData["Data"].toString());
          var b = responseData["Result"].toString();
          if (responseData["Result"] == "Sucess") {
            Loader.hide();
            Map<String, dynamic> billData = responseData["Data"][0];

            String billAmount = billData["billAmount"].toString();
            String requestId = billData["requestId"].toString();
            String DueDatee = billData["dueDate"].toString();
            String billDatee = billData["billDate"].toString();
            String billNumber = billData["billNumber"].toString();
            String customerName = billData["customerName"].toString().trim();
            String responseCode = billData["responseCode"].toString();
            String billPeriod = billData["billPeriod"].toString();

            DateFormat originalFormat = DateFormat('dd-MM-yyyy');
            DateFormat targetFormat = DateFormat('yyyy-MM-dd');

            DateTime originalDate = originalFormat.parse(DueDatee);
            String DueDate = targetFormat.format(originalDate);

            DateTime originalDatee = originalFormat.parse(billDatee);
            String billDate = targetFormat.format(originalDatee);

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillAmount", billAmount);
            prefs.setString("CustomerMobileNumber", txtAmount.text);
            prefs.setString("CustomeName", customerName);
            prefs.setString("DueDate", DueDate);
            prefs.setString("BillDate", billDate);
            prefs.setString("BillerID", BILLERID);

            prefs.setString("BillNumnber", billNumber);
            prefs.setString("RequestID", requestId);
            prefs.setString("BillPeriod", billPeriod);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FatchBill()));
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

}
