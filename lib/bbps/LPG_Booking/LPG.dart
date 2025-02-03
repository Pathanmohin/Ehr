import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/LPG_Booking/LPG_FetchBill.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LPG extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LPGBooking();
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

class _LPGBooking extends State<LPG> {
  void initState() {
    GetLPGBillers();
    super.initState();
  }

  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtMobileNumber = TextEditingController();

  bool BalanceVisible = false;
  bool BillerNmae = false;
  String Billerkid = "";
  String BILLERID = "";
  String BILLERNAME = "";
  String AMOUNTENTER = "";
  String AccountBalance = "";
  String accountnumber = "";
  String RequestID = "";
  String BillAMOUNT = "";
  String bileriddd = "";
  String billerNamee = "";
  // bool BalanceVisible = false;
  // bool BillerNmae = false;
  String consumerName = "";

  String Customename = "";
  var ronak;
  List<LPGInfo> LPGInfoList = [];

  void ToAccount(String item) {
    // Handle the selection change
    GetLPGBillerName();
    BillerNmae = true;
  }

  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BBPS()),
    );

    // Prevent the default back button behavior
    return false;
  }

  String Message = "";
  String Alert = "";
  String Name = "";
  String AccountholderName = "";

  String amount = "";
  String fromvalue = "";
 

  var FromAccountNumber;
  var getBillerss;
  String getBillers = "";
  var GasBillerName;
  var FastTagProvider;

 // final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  final List<Rechargmobile> fromAccountList = <Rechargmobile>[];

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
                "LPG Booking",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BBPS()),
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
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true, // Enables the search box
                                      searchFieldProps: const TextFieldProps(
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
                          Visibility(
                            visible: BillerNmae,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                Name,
                                style: TextStyle(
                                    color: Color(0xFF0057C2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: BillerNmae,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: TextFormField(
                                  controller: txtAmount,
                                  inputFormatters: <TextInputFormatter>[
                                    UpperCaseTextInputFormatter(),
                                  ],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight
                                          .bold // Set the color for the input text
                                      ),
                                  decoration: InputDecoration(
                                    hintText: Name,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                               if (BILLERID == null || BILLERID == "") {
                                Message = "Please Select Biller";
                                DialogboxAlert(Message);
                                return;
                              } else if (txtAmount.text == null ||
                                  txtAmount.text == "") {
                                Message = "Please Enter " + Name;
                                DialogboxAlert(Message);
                                return;
                              }
                    
                              //     Navigator.push(
                              //      context,
                              //       MaterialPageRoute(
                              // builder: (contex) =>
                              //     LPG_Fatch()));
                    
                              OnLPGFatchBill();
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
                                    "Fetch Bill",
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
                     SizedBox(height: 200,),
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
      }),
    );
  }

  void onFromAccount(String item) {
    print('Selected value: $item');
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
              title: Text(
                'Alert',
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                MESSAGE,
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
              title: Text(
                'Alert',
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
  }

  Future<void> GetLPGBillers() async {
    try {
    ServerDetails serverDetails = ServerDetails();
   // String ip = serverDetails.getIPaddress();
    //String port = serverDetails.getPortBBPS();
    //String protocol = serverDetails.protocol();

      // Loader.show(context, progressIndicator: CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/AccountService/Getbilleroperator";

      String jsonString = jsonEncode({
        "billerCat": "LPG Gas",
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

  
  Future<void> GetLPGBillerName() async {
    try {


      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/billereducationvali";

      String jsonString = jsonEncode({
        "billerId": BILLERID,
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
          Loader.hide();
          Map<String, dynamic> responseData = jsonDecode(response.body);

          List<dynamic> paramNameList =
              jsonDecode(responseData["paramname"].toString());

          String? selectedParamName;
          for (var param in paramNameList) {
            if (param["paramName"] == "Registered Contact Number" ||
                param["paramName"] == "Mobile Number" ||
                param["paramName"] == "LPG_ID or Contact Number") {
              selectedParamName = param["paramName"];
              break; // Stop once the first match is found  LPG_ID or Contact Number
            }
          }
          setState(() {
            // txtAmount.text = a.toString();
            Name = selectedParamName ??
                'Neither Registered Contact Number nor Mobile Number found';
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

  Future<void> OnLPGFatchBill() async {
    try {
      
   
      Loader.show(context, progressIndicator: CircularProgressIndicator());

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/LPGfetchbill";

      String jsonString = jsonEncode({
        "Billerid": BILLERID,
        "Circle": "",
        "mobileno": txtAmount.text,
        "paramvalue": txtAmount.text,
        "billercat": "LPG Gas",
        "ParamName": Name,
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

            Map<String, dynamic> billData =
                responseData["Data"][0]; // Accessing the first object in 'Data'

            // Storing requestId and billDate
            RequestID = billData["requestId"];
            Customename = billData["billDate"];

            consumerName = Customename.toString();

            // billAmount is double, so store it as double and convert to string
            double billamountApi = billData["billAmount"];
            BillAMOUNT = billamountApi.toString(); // Convert double to string

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillerID", BILLERID.toString());
            prefs.setString("consumerno", txtAmount.text);
            // prefs.setString("AccountBalance", amount);
            // prefs.setString("AccountNUMber", FromAccountNumber);
            prefs.setString("Billername", billerNamee.toString());
            prefs.setString("BillAMOUNT", BillAMOUNT.toString());
            prefs.setString("RequestID", RequestID.toString());

            prefs.setString("consmasjabd", consumerName.toString());

            Navigator.push(
                context, MaterialPageRoute(builder: (contex) => LPG_Fatch()));
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

class LPGInfo {
  String infoName;
  String description;

  LPGInfo({required this.infoName, required this.description});

  factory LPGInfo.fromJson(Map<String, dynamic> json) {
    return LPGInfo(
      infoName: json['infoName'],
      description: json['description'],
    );
  }
}
