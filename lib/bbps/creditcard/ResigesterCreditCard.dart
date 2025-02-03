import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/creditcard/CreditCard.dart';
import 'package:ehr/bbps/creditcard/FetchBillCreditCard.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/credmodel.dart';
import 'package:ehr/bbps/model/information.dart';

import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NewCreditCard extends StatefulWidget {
  const NewCreditCard({super.key});
  @override
  State<StatefulWidget> createState() => _NewCreditCard();
}

class MenuItem {
  final int id;
  final String label;
  final IconData icon;

  MenuItem(this.id, this.label, this.icon);
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

class CardItem {
  final String title;
  final String accountNumber;
  final String balance;
  final String logo;

  CardItem({
    required this.title,
    required this.accountNumber,
    required this.balance,
    required this.logo,
  });
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', ''); // Remove all spaces
    String formattedText = '';

    for (int i = 0; i < newText.length; i++) {
      if (i % 4 == 0 && i != 0) {
        formattedText += ' '; // Add a space after every 4 digits
      }
      formattedText += newText[i];
    }

    // Return the formatted value
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _NewCreditCard extends State<NewCreditCard> {
  void initState() {
    GetBiller();
    super.initState();
  }

  TextEditingController MobileNumberCreditcardd = TextEditingController();

  TextEditingController CardNumberr = TextEditingController();
  TextEditingController NAME = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');

  List<CardItem> cardItems = [
    CardItem(
      title: "ICICI Bank",
      accountNumber: "XXXX XXXX 1004",
      balance: "₹1,765.61",
      logo: "assets/icici_logo.png", // Add your asset path
    ),
    CardItem(
      title: "HDFC Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),
    CardItem(
      title: "HDFC Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),
    CardItem(
      title: "HDFC Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),
    CardItem(
      title: "HDFC Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),
    CardItem(
      title: "HDFC Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),
    CardItem(
      title: "rbl Bank",
      accountNumber: "XXXX XXXX 2004",
      balance: "₹3,245.80",
      logo: "assets/hdfc_logo.png", // Add your asset path
    ),

    // Add more card items as needed
  ];

  void ToAccount(String item) {
    // Handle the selection change
    // GetBillerName();
    // Provider = true;
    GetBillerName();
  }

  var FromAccountNumber;
  var FastTagProvider;
  String Message = "";
  String FIRST = '';
  var SECOND = '';
  var THIRD = '';
  bool Field = false;
  String BILLERID = "";
  String amount = "";
  String BILLERNAME = "";
  bool BalanceVisible = false;

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

  //final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  final List<Rechargmobileee> fromAccountList = <Rechargmobileee>[];

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

    double width = MediaQuery.of(context).size.width - 16.0;
    final TextEditingController menuController = TextEditingController();
    MenuItem? selectedMenu;
    String Instrucation = "Enter an amount between" +
        " " +
        "\u{20B9}" "1.00" +
        " " +
        "to" +
        " " +
        "\u{20B9}" +
        "99,99,999.00";

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
                " Register Credit Card",
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Text(
                              " Credit Card",
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
                              child: DropdownSearch<Rechargmobileee>(
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: 'Select Credit Card',
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
                                itemAsString: (Rechargmobileee obj) =>
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
                                        'Select Credit card',
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
                                  BILLERNAME = newValue!.biller_name.toString();

                                  ToAccount(BILLERID);
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5.0, left: 10.0),
                              child: Text(
                                "Credit Card Number",
                                style: TextStyle(
                                    color: Color(0xFF0057C2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
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
                                  controller: CardNumberr,
                                  decoration: const InputDecoration(
                                    hintText: "XXXX XXXX XXXX XXXX",
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        19), // 16 digits + 3 spaces
                                    FilteringTextInputFormatter.digitsOnly,
                                    CardNumberFormatter(),
                                  ],
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                SECOND,
                                style: const TextStyle(
                                    color: Color(0xFF0057C2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
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
                                  controller: MobileNumberCreditcardd,
                                  decoration: InputDecoration(
                                    hintText: SECOND,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5.0, left: 10.0),
                              child: Text(
                                "Full Name ",
                                style: TextStyle(
                                    color: Color(0xFF0057C2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
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
                                  controller: NAME,
                                  decoration: const InputDecoration(
                                    hintText: "Name On Card",
                                  ),
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (BILLERID == null || BILLERID == "") {
                                Message = "Please Select Credit Card";
                                DialogboxAlert(Message);
                                return;
                              } else if (CardNumberr.text == null ||
                                  CardNumberr.text == "") {
                                Message = "Please Enter" + THIRD;
                                DialogboxAlert(Message);
                                return;
                              } else if (CardNumberr.text.trim().length < 16) {
                                Message = "Please Enter 16 digits Card Number";
                                DialogboxAlert(Message);
                                return;
                              } else if (MobileNumberCreditcardd.text == null ||
                                  MobileNumberCreditcardd.text == "") {
                                Message = "Please Enter" + " " + SECOND;
                                DialogboxAlert(Message);

                                return;
                              } else if (MobileNumberCreditcardd.text.length >
                                      10 ||
                                  MobileNumberCreditcardd.text.trim().length <
                                      10) {
                                Message =
                                    "Please Enter 10 digits mobile number";
                                DialogboxAlert(Message);
                                return;
                              } else if (NAME.text == "" || NAME.text == null) {
                                Message = "Please Enter Full Name";
                                DialogboxAlert(Message);
                                return;
                              }

                              // OnFatchBill();

                              RegisterCreditCard();
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
                'Success',
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CreditCard()));
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

  Future<void> GetBiller() async {
    try {
  

    // Loader.show(context, progressIndicator: const CircularProgressIndicator());

      // API endpoint URL

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/AccountService/Getbilleroperator";

      String jsonString = jsonEncode({
        "billerCat": "Credit Card",
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
              Rechargmobileee vObject = new Rechargmobileee();

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
          Loader.hide();
          Message = "Issue with Internet, Please try after few minutes";
          DialogboxAlert(Message);
          return;
        }
      } catch (error) {
        Loader.hide();

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

  Future<void> GetBillerName() async {
    try {
  

     // Loader.show(context, progressIndicator: const CircularProgressIndicator());

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
          Map<String, dynamic> responseData = jsonDecode(response.body);

          var a = responseData["paramname"].toString();

          List<dynamic> paramList = jsonDecode(responseData['paramname']);
          THIRD = paramList[0]['paramName'];
          SECOND = paramList[1]['paramName'];

          

          setState(() {
            Loader.hide();
            Field = true;
          });
        } else {
          Loader.hide();
          // Message = "Server Failed....!";
          // DialogboxAlert(Message);
          return;
        }
      } catch (error) {
        Loader.hide();
        // Message = "Server Failed....!";
        // DialogboxAlert(Message);
        return;
      }
    } catch (e) {
      Loader.hide();
      // Message = "Unable to Connect to the Server";
      // DialogboxAlert(Message);
      return;
    }
  }

  Future<void> OnFatchBill() async {
    try {
    

      Loader.show(context, progressIndicator: const CircularProgressIndicator());

// Password Ency.
      String md5Hash = Crypt().generateMd5("Bank@123");

      String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/creditcardfetchbill";

      String jsonString = jsonEncode({
        "Billerid": BILLERID,
        "Circle": "",
        "mobileno": MobileNumberCreditcardd.text,
        "cardno": CardNumberr.text,
        "billercat": "Credit Card",
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

            List<dynamic> dataList = jsonDecode(Minimumamountdue);
            String minimumAmountDue = dataList.firstWhere((element) =>
                element['infoName'] == 'Minimum Amount Due')['description'];
            String currentOutstandingAmount = dataList.firstWhere((element) =>
                element['infoName'] ==
                'Current Outstanding Amount')['description'];

            final prefs = await SharedPreferences.getInstance();

            prefs.setString("BillAmount", billAmount);
            prefs.setString("CustomeName", customerName);
            prefs.setString("DueDate", DueDatee);
            prefs.setString("BillDate", billDatee);

            prefs.setString("BillNumnber", billNumber);
            prefs.setString("RequestID", requestId);
            prefs.setString("BillerID", BILLERID);
            try {
              prefs.setString(
                  "MobilenumberCustomet", MobileNumberCreditcardd.text);
            } catch (error) {}
            prefs.setString("Balance", amount);
            // prefs.setString("AccountNumber", FromAccountNumber);
            prefs.setString("Type", "register");

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

 

  Future<void> RegisterCreditCard() async {
    try {
      ServerDetails serverDetails = ServerDetails();
 
      Loader.show(context, progressIndicator: const CircularProgressIndicator());

// Password Ency.
      String md5Hash = Crypt().generateMd5("Bank@123");

      String apiUrl =
          "${AppCongifP.apiurllinkBBPS}/rest/AccountService/CreditcardRegister";

      String jsonString = jsonEncode({
        "CardNumber": CardNumberr.text,
        "MobileNumber": MobileNumberCreditcardd.text,
        "userid": AppInfoLogin.Userid,
        "name": NAME.text,
        "bankName": BILLERNAME,
        "billerid": BILLERID
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

          if (responseData["Result"] == "Success") {
            Loader.hide();
            var decryptedResult = responseData["Message"];
            DialogboxAlertt(decryptedResult);
          } else {
            Loader.hide();

            var decryptedResult = responseData["Message"];

            DialogboxAlert(decryptedResult);
            return;
            // var decryptedResultt = decryptedResult[0] as Map<String, dynamic>;

            // String decryptedResulttt =
            //     decryptedResultt["errorMessage"] as String;

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
