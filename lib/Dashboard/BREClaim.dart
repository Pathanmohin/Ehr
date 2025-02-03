import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreclaimPage extends StatefulWidget {
  @override
  _BreclaimPageState createState() => _BreclaimPageState();
}

class ClaimType {
  final int claimTypeID;
  final String claimTypeName;

  ClaimType({
    required this.claimTypeID,
    required this.claimTypeName,
  });

  factory ClaimType.fromJson(Map<String, dynamic> json) {
    return ClaimType(
      claimTypeID: json['ClaimTypeID'],
      claimTypeName: json['ClaimTypeName'],
    );
  }
}

class ClaimData {
  final int empId;
  final int claimId;
  final String claimName;
  final double amount;
  final String autoApprove;
  final String claimCode;
  final int stat;
  final String claimParaId;
  final double remainBal;
  final String restrictEligible;
  final double claimBalance;
  final double fuelConsption;
  final double remaingFuel;
  final double eligibleAmt;
  final double sumClaimAmt;
  final String advanceTaken;
  final int empId1;
  final int debit;
  final int credit;
  final String uploadDocMan;
  final double percentage;
  final String luggageReq;
  final int claimId1;
  final String appReq;
  final String declare2;
  final double totalAmt;
  final String declareMsg;
  final String declareMsgL;
  final String declare1;
  final int claimDetailsKid;

  ClaimData({
    required this.empId,
    required this.claimId,
    required this.claimName,
    required this.amount,
    required this.autoApprove,
    required this.claimCode,
    required this.stat,
    required this.claimParaId,
    required this.remainBal,
    required this.restrictEligible,
    required this.claimBalance,
    required this.fuelConsption,
    required this.remaingFuel,
    required this.eligibleAmt,
    required this.sumClaimAmt,
    required this.advanceTaken,
    required this.empId1,
    required this.debit,
    required this.credit,
    required this.uploadDocMan,
    required this.percentage,
    required this.luggageReq,
    required this.claimId1,
    required this.appReq,
    required this.declare2,
    required this.totalAmt,
    required this.declareMsg,
    required this.declareMsgL,
    required this.declare1,
    required this.claimDetailsKid,
  });

  factory ClaimData.fromJson(Map<String, dynamic> json) {
    return ClaimData(
      empId: json['EmpId'],
      claimId: json['claimid'],
      claimName: json['ClaimName'],
      amount: json['Amount'],
      autoApprove: json['AutoApprove'],
      claimCode: json['ClaimCode'],
      stat: json['stat'],
      claimParaId: json['ClaimParaId'],
      remainBal: json['RemainBal'],
      restrictEligible: json['RestictEligible'],
      claimBalance: json['ClaimBALANCE'],
      fuelConsption: json['FuelConsption'],
      remaingFuel: json['RemaingFuel'],
      eligibleAmt: json['EligibleAmt'],
      sumClaimAmt: json['SumClaimAmt'],
      advanceTaken: json['AdvanceTaken'],
      empId1: json['EmpId1'],
      debit: json['Debit'],
      credit: json['Credit'],
      uploadDocMan: json['UploadDocMan'],
      percentage: json['percentge'],
      luggageReq: json['LuggageReq'],
      claimId1: json['claimid1'],
      appReq: json['AppReq'],
      declare2: json['declare2'],
      totalAmt: json['TotalAmt'],
      declareMsg: json['declareMsg'],
      declareMsgL: json['declareMsgL'],
      declare1: json['declare1'],
      claimDetailsKid: json['ClaimDetails_kid'],
    );
  }
}

class _BreclaimPageState extends State<BreclaimPage> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedStatus;
  String? month;
  String? claimID;
  String totalAmount = "";
  String? monthh;
  String? formattedDate = "";
  String Remark = "";
  var itemData = "";

  final TextEditingController remarkController = TextEditingController();

  List<String> years = [];
  List<String> months = [];
  List<String> allMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> selectStatusItems = []; // Add your status items here
  List<ClaimData> trends1 = [];
  List<String> trends2 = [];

  bool isChecked = false;

  bool isClaimDataVisible = false;
  bool isTotalAmountVisible = false;
  bool isRemarksVisible = false;
  bool isDeclarationVisible = false;

  @override
  void initState() {
    super.initState();
    generateYearList();
    generateMonthList();
    claimTypee();
  }

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  void generateYearList() {
    int currentYear = DateTime.now().year;
    years = List.generate(2, (index) => (currentYear - index).toString());

    int currentMonth = DateTime.now().month;
    months = allMonths.sublist(0, currentMonth);

    DateTime currentDate = DateTime.now();

    // Format the date as a string
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
  }

  void generateMonthList() {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;

    if (selectedYear == currentYear.toString()) {
      months = allMonths.sublist(0, currentMonth);
    } else {
      months = allMonths;
    }

    // Ensure the selected month is reset or updated appropriately
    selectedMonth = null;
  }

  void onYearChanged(String? newValue) {
    setState(() {
      selectedYear = newValue;
      generateMonthList();
    });
  }

  void onMonthChanged(String? newValue) {
    setState(() {
      selectedMonth = newValue;
      month = (allMonths.indexOf(newValue!) + 1).toString();
      if (month == "1") {
        monthh = "January";
      }
      if (month == "2") {
        monthh = "February";
      }
      if (month == "3") {
        monthh = "March";
      }
      if (month == "4") {
        monthh = "April";
      }
      if (month == "5") {
        monthh = "May";
      }
      if (month == "6") {
        monthh = "June";
      }
      if (month == "7") {
        monthh = "July";
      }
      if (month == "8") {
        monthh = "Auguest";
      }
      if (month == "9") {
        monthh = "September";
      }
      if (month == "10") {
        monthh = "October";
      }
      if (month == "11") {
        monthh = "November";
      }
      if (month == "2") {
        monthh = "December";
      }
    });
  }

  void onStatusChanged(String? newValue) {
    setState(() {
      selectedStatus = newValue;
      claimID = selectedStatus!.split('-')[0]; // Extract claim ID
    });
  }

  void onSubmit() {
    setState(() {
      // Perform your submission logic here
      // Example: Toggle visibility of sections
      isClaimDataVisible = !isClaimDataVisible;
      isTotalAmountVisible = !isTotalAmountVisible;
      isRemarksVisible = !isRemarksVisible;
      isDeclarationVisible = !isDeclarationVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        return false;
      },
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.1)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "BRE Claim",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildDropdownSection(
                      label: "Claim Type*",
                      value: selectedStatus,
                      items: selectStatusItems,
                      onChanged: onStatusChanged,
                    ),
                    buildDropdownSection(
                      label: "Select Year",
                      value: selectedYear,
                      items: years,
                      onChanged: onYearChanged,
                    ),
                    buildDropdownSection(
                      label: "Select Month",
                      value: selectedMonth,
                      items: months,
                      onChanged: onMonthChanged,
                    ),
                    buildButton("Show", showClicked),
                    Visibility(
                      visible: isClaimDataVisible,
                      child: buildClaimDataSection(),
                    ),
                    Visibility(
                      visible: isTotalAmountVisible,
                      child: buildTotalAmountSection(totalAmount),
                    ),
                    Visibility(
                      visible: isRemarksVisible,
                      child: buildRemarksSection(),
                    ),
                    Visibility(
                      visible: isDeclarationVisible,
                      child: buildDeclarationSection(),
                    ),
                    buildButton("Submit", onSubmitted),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildDropdownSection({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "TimesNewRoman",
            color: Color(0xFF547EC8),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
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
              value: value,
              hint: const Text(
                'Select',
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF898989),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Builder(builder: (context) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.1)),
                        child: Text(value));
                  }),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "TimesNewRoman",
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildClaimDataSection() {
    return Frame(
      borderColor: Colors.black,
      margin: const EdgeInsets.all(2),
      height: 250,
      child: ListView.builder(
        itemCount: trends1.length, // Use the length of your trends1 list
        itemBuilder: (context, index) {
          return buildClaimDataItem(
              trends1[index].claimName, trends1[index].amount.toString());
        },
      ),
    );
  }

  Widget buildClaimDataItem(String claimName, String amount) {
    return Frame(
      borderColor: const Color(0xFFBD830A),
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Checkbox(
            value: true,
            onChanged: (bool? value) {
              // Handle checkbox change
            },
            activeColor: const Color(0xFF951A1C),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildClaimDataDetail("Particular:", claimName),
                buildClaimDataDetail("Amount:", amount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClaimDataDetail(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "TimesNewRoman",
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "TimesNewRoman",
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildTotalAmountSection(String totalAmount) {
    return Row(
      children: [
        const Text(
          "Total Amount:",
          style: TextStyle(
            fontFamily: "TimesNewRoman",
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "${totalAmount}", // Replace with your actual total amount
          style: const TextStyle(
            fontFamily: "TimesNewRoman",
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildRemarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Remark",
          style: TextStyle(
            fontFamily: "TimesNewRoman",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF547EC8),
          ),
        ),
        TextField(
          controller: remarkController,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: "Enter Remark",
            hintStyle: TextStyle(
              fontFamily: "TimesNewRoman",
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDeclarationSection() {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
          activeColor: const Color(0xFF951A1C),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Declaration:",
                style: TextStyle(
                  fontFamily: "TimesNewRoman",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF547EC8),
                ),
              ),
              Text(
                "I have incurred not less than Rs." +
                    "$totalAmount" +
                    " Only for the month of " +
                    "$monthh" +
                    "," +
                    "$selectedYear" +
                    " for the interest of the corporation work.",
                style: const TextStyle(
                  fontFamily: "TimesNewRoman",
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> claimTypee() async {
    try {
      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=BRECLaimType';
      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          List<dynamic> trends = jsonResponse;

          List<ClaimType> trendss =
              trends.map((json) => ClaimType.fromJson(json)).toList();
          ClaimType trend = ClaimType.fromJson(trends[0]);

          // Use a local variable to update the state
          List<String> updatedStatusItems = [
            '${trend.claimTypeID}-${trend.claimTypeName}'
          ];

          // Update the state outside the async context
          setState(() {
            selectStatusItems = updatedStatusItems;
          });
        }
      } else {
        // Handle server error
        print('Failed to load claim types: ${response.statusCode}');
      }
    } catch (ex) {
      // Handle exceptions
      print('Exception occurred while loading claim types: $ex');
    }
  }

  Future<void> showClicked() async {
    if (selectedStatus == null || selectedStatus == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please select ClaimType'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    } else if (selectedYear == -1 || selectedYear == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please select Year'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    } else if (selectedMonth == -1 || selectedMonth == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please select Month'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    await EasyLoading.show(status: 'Loading BRE Data...');
    if (selectedMonth != null && selectedYear != null) {
      int currentYear = DateTime.now().year;
      int currentMonth = DateTime.now().month;
      int selectedYearInt = int.parse(selectedYear!);
      int selectedMonthInt = int.parse(month!);

      if (selectedYearInt > currentYear ||
          (selectedYearInt == currentYear &&
              selectedMonthInt >= currentMonth)) {
        await EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Alert'),
            content: const Text(
                'Future month and Current Month request not allowed'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedMonth = months[currentMonth - 1];
                  });
                },
              ),
            ],
          ),
        );
        return;
      }
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String Kid = prefs.getString('EmpKid')!;
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=BRECLaimReqData&EmpId=$Kid&ClaimBehaveId=$claimID&Year=$selectedYear&Month=$month';
      var response = await http.get(Uri.parse(restUrl));

      if (response.body == '[]') {
        await EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Alert'),
            content: Text(
                'You have already applied for the Month of $monthh, $selectedYear claim'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        setState(() {
          isClaimDataVisible = false;
          isTotalAmountVisible = false;
          isRemarksVisible = false;
          isDeclarationVisible = false;
        });
        return;
      } else {
        setState(() {
          isClaimDataVisible = true;
          isTotalAmountVisible = true;
          isRemarksVisible = true;
          isDeclarationVisible = true;
        });
        await EasyLoading.dismiss();
        var tr = jsonDecode(response.body);
        List<ClaimData> trends =
            (tr as List).map((i) => ClaimData.fromJson(i)).toList();
        totalAmount = trends[0].totalAmt.toString();
        setState(() {
          trends1 = trends;
        });
      }
    } catch (ex) {
      await EasyLoading.dismiss();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Unable to Connect to the Server'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> onSubmitted() async {
    if (!isChecked) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please confirm your Declaration!!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    if (remarkController.text == null || remarkController.text == "") {
      Remark = "Null";
    } else {
      Remark = remarkController.text;
    }
    await EasyLoading.show(status: 'Requesting BRE Claim...');
    for (int i = 0; i < trends1.length; i++) {
      // Calculate total amount
      double total = 0;
      total += double.parse(trends1[i].amount.toString());

      // Populate trends2 with desired data
      itemData =
          "{ClaimId:${trends1[i].claimId},ParaId:${trends1[i].claimParaId},ReqAmount:${trends1[i].amount},Stat:${trends1[i].stat},ClaimKid:${trends1[i].claimDetailsKid},ForwardTo:0,CLevel:1,ReqStatus:R,AutoApprove:${trends1[i].autoApprove},EmpId:${trends1[i].empId},ReqDate:$formattedDate,ReqYear:$selectedYear,ReqMonth:$month,Remark:$Remark}";

      // Add the itemData to trends2 list
      trends2.add(itemData);
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String Kid = prefs.getString('EmpKid')!;
      String userid = prefs.getString('userID')!;

      // Convert to JSON string
      String jsonString = jsonEncode(trends2);

      // Make HTTP request
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=BRECLaimReqSave&EmpId=$Kid&ClaimBehaveId=$claimID&Year=$selectedYear&Month=$month&Remarks=null&ReqData=$jsonString';
      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        String content = response.body;
        if (content == "Success") {
          await EasyLoading.dismiss();
          // Handle success
          // Example: Show an alert
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text("Claim Request Saved Successfully !"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Your other actions
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          // Other actions after success
        } else {
          await EasyLoading.dismiss();
          // Handle failure
          // Example: Show an alert
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text("Failed"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Your other actions
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          // Other actions after failure
        }
      } else {
        await EasyLoading.dismiss();
        // Handle network error
        // Example: Show an alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Alert"),
              content: Text("Network Error: ${response.statusCode}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Your other actions
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        // Other actions on network error
      }
    } catch (ex) {
      await EasyLoading.dismiss();
      // Handle exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('Unable to Connect to the Server'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}

class Frame extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsets margin;
  final double height;

  const Frame({
    required this.child,
    required this.borderColor,
    this.backgroundColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.height = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: height,
        child: child,
      ),
    );
  }
}
