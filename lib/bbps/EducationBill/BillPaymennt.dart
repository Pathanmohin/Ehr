import 'dart:convert';

import 'package:ehr/app.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/dashboardmodel.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;


class educationbillpayment extends StatefulWidget {
  const educationbillpayment({super.key});

  @override
  State<StatefulWidget> createState() => _educationbillpayment();
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _educationbillpayment extends State<educationbillpayment> {
  void initState() {
    super.initState();
  }

  List<EducationBill> fastTagInfoList = [];

  TextEditingController StudentID = TextEditingController();
  TextEditingController DOB = TextEditingController();
  TextEditingController ParenetMobilenumber = TextEditingController();
  bool BalanceVisible = false;
  bool Provider = false;
  bool TEXTFIELD = false;
  String Billerkid = "";
  String FIRST = '';
  String SECOND = '';
  String THIRD = '';

  List<EducationBill> fastTagInfooo = [];

  List<EducationBill> fastTagInfo = [];
  final List<TextEditingController> _controllers = [];
//   final txtAmount = TextEditingController();

  @override
  void onToAccount(String value) {
    OngetBalance(value);
    BalanceVisible = true;
  }

  void ToAccount(String item) {
    // Handle the selection change
    GetBillerName();
    Provider = true;
  }

  void _getTextFieldData() {
    List<String> enteredData = [];
    for (var i = 0; i < _controllers.length; i++) {
      enteredData.add(_controllers[i].text);
    }
    print(enteredData);
  }

  Future<bool> _onBackPressed() async {
    await Future.delayed(const Duration(milliseconds: 1));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BBPS()),
    );

    return false;
  }

  String Message = "";
  String Alert = "";
  String Name = "";
  String AccountholderName = "";

  String amount = "";
  String fromvalue = "";

  var FromAccountNumber;
  var FastTagProvider;

  final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  final List<Rechargmobile> fromAccountList = <Rechargmobile>[];
  List<String> Ronaknyariya = [];

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
                  "Bill Payment",
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
                        child: Image.asset("assets/images/BBPS_Logo.png")),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                            "From Account",
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: FromAccountNumber,
                                hint: const Text(
                                  'From Account',
                                  style: TextStyle(
                                    color: Color(0xFF898989),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                items: toAccountList.map((SimpleObject obj) {
                                  return DropdownMenuItem<String>(
                                    value: obj.textValue,
                                    child: Text(
                                      "${obj.textValue}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    FromAccountNumber = newValue!;
                                  });
            
                                  onToAccount(newValue!);
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: BalanceVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Available Balance",
                                  style: TextStyle(
                                      color: Color(0xFF0057C2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Visibility(
                                  child: Text(
                                    "\u{20B9}" + '${amount}',
                                    style: const TextStyle(
                                        color: Color(0xFF0057C2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 10.0),
                          child: Text(
                            "Biller Name",
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: FastTagProvider,
                                hint: const Text(
                                  'Biller Name',
                                  style: TextStyle(
                                    color: Color(0xFF898989),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                items: fromAccountList.map((Rechargmobile obj) {
                                  return DropdownMenuItem<String>(
                                    value: obj.biller_id,
                                    child: Text(
                                      "${obj.biller_name}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    FastTagProvider = newValue!;
                                  });
            
                                  ToAccount(newValue!);
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: TEXTFIELD,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    FIRST.toString(),
                                    style: const TextStyle(
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
                                      keyboardType: TextInputType.number,
                                      controller: StudentID,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold // Set the color for the input text
                                          ),
                                      decoration: InputDecoration(
                                        hintText: FIRST.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    SECOND.toString(),
                                    style: const TextStyle(
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
                                      keyboardType: TextInputType.number,
                                      controller: ParenetMobilenumber,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold // Set the color for the input text
                                          ),
                                      decoration: InputDecoration(
                                        hintText: SECOND.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    THIRD.toString(),
                                    style: const TextStyle(
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
                                      keyboardType: TextInputType.number,
                                      controller: DOB,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold // Set the color for the input text
                                          ),
                                      decoration: InputDecoration(
                                        hintText: THIRD.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        InkWell(
                          onTap: () async {
                            _showAlertDialog();
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
                                  "PROCEEDD",
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
        }
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Alert Dialog Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('This is the content of the alert dialog.'),
                      const SizedBox(height: 16.0),
                      // Buttons removed
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
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
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: AlertDialog(
                title:  const Text(
                  'Alert',
                  style: TextStyle(fontSize: 16),
                ),
                content: Text(
                  MESSAGE,
                  style:  const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:  const Text(
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
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: AlertDialog(
                title:  const Text(
                  'Alert',
                  style: TextStyle(fontSize: 16),
                ),
                content: Text(
                  message,
                  style:  const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:  const Text(
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

  Future<void> GetBiller() async {
    try {
       Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/AccountService/Getbilleroperator";

      String jsonString = jsonEncode({
        "billerCat": "Education Fees",
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
          var Result = responseData["Result"].toString();
          var Dataall = responseData["data"];

          if (responseData["Result"].toString() == "Success") {
            List<dynamic> jsonResponse = jsonDecode(responseData["data"]);

            int all = 0;
            for (var config in jsonResponse) {
              Rechargmobile vObject = new Rechargmobile();

              vObject.biller_id = config["biller_id"];
              vObject.biller_name = config["biller_name"];

              fromAccountList.add(vObject);
            }
          } else {
            Message = responseData["Message"].toString();
            DialogboxAlert(Message);
            return;
          }
        } else {
          // Loader.hide();
          Message = "Issue with Internet, Please try after few minutes";
          DialogboxAlert(Message);
          return;
        }
      } catch (error) {
        //  Loader.hide();

        Message = "Unable to Connect to the Server";
        DialogboxAlert(Message);
        return;
      }
    } catch (e) {
      Message = "Unable to Connect to the Server";
      DialogboxAlert(Message);
      return;
    }
  }

  Future<void> OngetBalance(String item) async {
    try {
     

      Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/AccountService/GetAccountBalance";

      String jsonString = jsonEncode({
        "AccNo": item,
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
          var a = jsonDecode(responseData["Data"].toString());
          var b = responseData["Result"].toString();
          setState(() {
            amount = a.toString();
          });
        } else {
          Message = "Server Failed....!";
          DialogboxAlert(Message);
          return;
        }
      } catch (error) {
        Message = "Server Failed....!";
        DialogboxAlert(Message);
        return;
      }
    } catch (e) {
      Message = "Unable to Connect to the Server";
      DialogboxAlert(Message);
      return;
    }
  }

  Future<void> GetBillerName() async {
    try {
  

      Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/billereducationvali";

      String jsonString = jsonEncode({
        "billerId": "EDU005679HIP01",
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

          var a = responseData["paramname"].toString();

          List<dynamic> jsonObject = json.decode(a);

          List<EducationBill> tempList = [];

          for (var item in jsonObject) {
            var paramName = item["paramName"].toString();
            var value = item["ronaknyariya"]
                .toString(); // Assume value is the field containing the data

            switch (paramName) {
              case 'DOB of Student(DDMMYYYY)':
                THIRD = "DOB of Student(DDMMYYYY)";
                break;
              case 'Mobile Number of Parent':
                SECOND = "Mobile Number of Parent";
                break;
              case 'Student Unique ID':
                FIRST = "Student Unique ID";
                break;
            }
          }
          setState(() {
            Loader.hide();
            TEXTFIELD = true;
          });
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

  Future<void> OnFatchBill() async {
    try {
    
 
      Loader.show(context, progressIndicator: const CircularProgressIndicator());

// Password Ency.
      String md5Hash = Crypt().generateMd5("Bank@123");

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/fetchbill";

      String jsonString = jsonEncode({
        "Billerid": FastTagProvider,
        "Circle": "",
        "mobileno": "7014133057",
        "paramvalue": "",
        "billercat": "Fastag",
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
            var ronak = billData["info"];
            List<dynamic> jsonObject = json.decode(ronak);

            List<EducationBill> tempListt = [];

            for (var item in jsonObject) {
              EducationBill info = EducationBill.fromJson(item);
              tempListt.add(info);
            }

            setState(() {
              fastTagInfoList = tempListt; //pendingMessages
            });

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => FastTagFatchBill(fastTagInfoList)));
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

class EducationBill {
  String paramName;

  EducationBill({
    required this.paramName,
  });

  factory EducationBill.fromJson(Map<String, dynamic> json) {
    return EducationBill(
      paramName: json['paramName'],
    );
  }
}
