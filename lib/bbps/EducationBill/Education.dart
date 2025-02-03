
import 'package:ehr/bbps/Boardband/FetschbillBoardband.dart';
import 'package:ehr/bbps/EducationBill/BillPaymennt.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/model/dashboardmodel.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<StatefulWidget> createState() => _Education();
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

class _Education extends State<Education> {
  void initState() {
    super.initState();
  }

  List<FastTagInfo> fastTagInfoList = [];
//   final txtAmount = TextEditingController();

  @override
  void onToAccount(String value) {}

  void ToAccount(String item) {
    // Handle the selection change
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
                  "Education",
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
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                "Select State of your Institution ",
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
                                      'Select State',
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
                                        child: Builder(
                                          builder: (context) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
                                              child: Text(
                                                "${obj.textValue}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
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
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                "Select City of your Institution",
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
                                      'Select City',
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
                                        child: Builder(
                                          builder: (context) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
                                              child: Text(
                                                "${obj.biller_name}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
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
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                "Select Pincode of your Institution",
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
                                      'Select Pincode',
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
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const educationbillpayment()));
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
                          ],
                        ),
                      ),
                       const SizedBox(height: 200,),
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
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
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
}
