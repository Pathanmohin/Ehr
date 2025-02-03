import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/creditcard/FetchBillCreditCard.dart';
import 'package:ehr/bbps/creditcard/ResigesterCreditCard.dart';
import 'package:ehr/bbps/model/constant.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:ehr/md5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});
  @override
  State<StatefulWidget> createState() => _CreditCard();
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
  final String cardNumber;
  final String billerId;
  final String bankName;
  final String userId;
  final String mobile;

  CardItem({
    required this.cardNumber,
    required this.billerId,
    required this.bankName,
    required this.userId,
    required this.mobile,
  });
}

class _CreditCard extends State<CreditCard> {
  void initState() {
    super.initState();
    GetBiller();

    //GetBillerNamee();
  }

  TextEditingController MobileNumberCreditcard = TextEditingController();

  TextEditingController CardNumber = TextEditingController();
  List<CardItem> cardItems = [];

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
  bool BalanceVisible = false;

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

 // final List<SimpleObject> toAccountList = AppListData.FromAccounts;

  final List<Rechargmobile> fromAccountList = <Rechargmobile>[];
  Widget _buildCardList() {
    print("Number of cards: ${cardItems.length}");
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cardItems.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CardWidget(
                item: cardItems[index],
                onPressed: () {
                  // Save details on button click
                  setState(() {
                    String selectedCardTitle = cardItems[index].bankName;
                    String selectedCardAccountNumber =
                        cardItems[index].cardNumber;
                    String selectedCardBalance = cardItems[index].mobile;
                  });
                },
              ),
            ],
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
                "Credit Card",
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
                  child: Column(children: [
                    _buildCardList(),
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
                              child: DropdownSearch<Rechargmobile>(
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
                                  String BILLERNAME =
                                      newValue!.biller_name.toString();

                                  ToAccount(BILLERID);
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0, left: 10.0),
                              child: Text(
                                THIRD,
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
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: CardNumber,
                                  decoration: InputDecoration(
                                    hintText: THIRD,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Field,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                SECOND,
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
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: MobileNumberCreditcard,
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
                          // Padding(
                          //   padding: EdgeInsets.only(top: 5.0, left: 10.0),
                          //   child: Text(
                          //     FIRST,
                          //     style: TextStyle(
                          //         color: Color(0xFF0057C2),
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          // Visibility(
                          //   visible: Field,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(top: 1.0, left: 10.0),
                          //     child: Text(
                          //       Instrucation,
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 13,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          InkWell(
                            onTap: () async {
                               if (BILLERID == null || BILLERID == "") {
                                Message = "Please Select Credit Card";
                                DialogboxAlert(Message);
                                return;
                              } else if (CardNumber.text == null ||
                                  CardNumber.text == "") {
                                Message = "Please Enter" + THIRD;
                                DialogboxAlert(Message);
                                return;
                              } else if (CardNumber.text.length > 4 ||
                                  CardNumber.text.trim().length < 4) {
                                Message = "Please Enter 4 digits Card Number";
                                DialogboxAlert(Message);
                                return;
                              } else if (MobileNumberCreditcard.text == null ||
                                  MobileNumberCreditcard.text == "") {
                                Message = "Please Enter" + SECOND;
                                DialogboxAlert(Message);

                                return;
                              } else if (MobileNumberCreditcard.text.length >
                                      10 ||
                                  MobileNumberCreditcard.text.trim().length <
                                      10) {
                                Message =
                                    "Please Enter 10 digits mobile number";
                                DialogboxAlert(Message);
                                return;
                              }
                              OnFatchBill();
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
                                    "PROCEED",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _getButtonFontSize(context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewCreditCard()));
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
                                    "ADD Credit CARD",
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

  Future<void> GetBiller() async {
    try {
  

      
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
      
     // Loader.show(context, progressIndicator: CircularProgressIndicator());


 String apiUrl = "${AppCongifP.apiurllinkBBPS}/rest/BBPSService/creditcardfetchbill";

      String jsonString = jsonEncode({
        "Billerid": BILLERID,
        "Circle": "",
        "mobileno": MobileNumberCreditcard.text,
        "cardno": CardNumber.text,
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
            prefs.setString(
                "MobilenumberCustomet", MobileNumberCreditcard.text);
            prefs.setString("Balance", amount);
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

class CardWidget extends StatelessWidget {
  final CardItem item;
  final VoidCallback onPressed;

  const CardWidget({Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0057C2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Bank Icon

            // Bank Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.bankName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.cardNumber,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }
}
