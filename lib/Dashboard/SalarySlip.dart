import 'dart:convert';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Salaryslip extends StatefulWidget {
  @override
  _SalaryslipState createState() => _SalaryslipState();
}

class SalaryEss {
  final String name;

  SalaryEss({required this.name});

  factory SalaryEss.fromJson(Map<String, dynamic> json) {
    return SalaryEss(
      name: json['Name'],
    );
  }
}

class _SalaryslipState extends State<Salaryslip> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedStatus;
  String? month;
  String? status;

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
  List<String> selectStatusItems = [];

  @override
  void initState() {
    super.initState();
    generateYearList();
    generateMonthList();
    fetchSalarySlipEss();
  }

  void generateYearList() {
    int currentYear = DateTime.now().year;
    years = List.generate(5, (index) => (currentYear - index).toString());

    int currentMonth = DateTime.now().month;
    months = allMonths.sublist(0, currentMonth);
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
      if (selectedMonth == "January") {
        month = "1";
      }
      if (selectedMonth == "February") {
        month = "2";
      }
      if (selectedMonth == "March") {
        month = "3";
      }
      if (selectedMonth == "April") {
        month = "4";
      }
      if (selectedMonth == "May") {
        month = "5";
      }
      if (selectedMonth == "June") {
        month = "6";
      }
      if (selectedMonth == "July") {
        month = "7";
      }
      if (selectedMonth == "August") {
        month = "8";
      }
      if (selectedMonth == "September") {
        month = "9";
      }
      if (selectedMonth == "October") {
        month = "10";
      }
      if (selectedMonth == "November") {
        month = "11";
      }
      if (selectedMonth == "December") {
        month = "12";
      }
    });
  }

  void onStatusChanged(String? newValue) {
    setState(() {
      selectedStatus = newValue;
      if (selectedStatus == "Approved") {
        status = "A";
      }
      if (selectedStatus == "Paid") {
        status = "P";
      }
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
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  "Salary Slip",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "TimesNewRoman",
                      fontSize: 18),
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
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Select Year",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                color: Color(0xFF0057C2),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
                            dropdownColor: Colors.white,
                              value: selectedYear,
                              hint: const Text(
                                'Select Year',
                                style: TextStyle(
                                  fontFamily: "TimesNewRoman",
                                  color: Color(0xFF898989),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              onChanged: onYearChanged,
                              items: years.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Builder(builder: (context) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            textScaler:
                                                const TextScaler.linear(1.1)),
                                        child: Text(value));
                                  }),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                    buildDivider(),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Month",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                color: Color(0xFF0057C2),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                            dropdownColor: Colors.white,
                              value: selectedMonth,
                              hint: const Text(
                                'Select Month',
                                style: TextStyle(
                                  fontFamily: "TimesNewRoman",
                                  color: Color(0xFF898989),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              onChanged: onMonthChanged,
                              items: months.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Builder(builder: (context) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            textScaler:
                                                const TextScaler.linear(1.1)),
                                        child: Text(value));
                                  }),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                    buildDivider(),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Status",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                color: Color(0xFF0057C2),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                            dropdownColor: Colors.white,
                              value: selectedStatus,
                              hint: const Text(
                                'Select Status',
                                style: TextStyle(
                                  fontFamily: "TimesNewRoman",
                                  color: Color(0xFF898989),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              onChanged: onStatusChanged,
                              items: selectStatusItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Builder(builder: (context) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            textScaler:
                                                const TextScaler.linear(1.1)),
                                        child: Text(value));
                                  }),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        fetchSalarySlip();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                  fontFamily: "TimesNewRoman",
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Colors.black,
      thickness: 1,
    );
  }

  Future<void> fetchSalarySlipEss() async {
    try {
     // ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=SalarySlipEss';

      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<SalaryEss> trends =
            data.map((json) => SalaryEss.fromJson(json)).toList();

        setState(() {
          selectStatusItems = trends.map((trend) => trend.name).toList();
        });
      } else {
        throw Exception('Unable to connect to the server');
      }
    } catch (e) {
      throw Exception('Unable to connect to the server');
    }
  }

  Future<void> fetchSalarySlip() async {
    try {
      if (selectedYear == -1 || selectedYear == null) {
       await showAlert('Please Select Year');
        return;
      } else if (selectedMonth == -1 || selectedMonth == null) {
      await  showAlert('Please Select Month');
        return;
      } else if (selectedStatus == -1 || selectedStatus == null) {
      await  showAlert('Please Select Status');
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';

      String appName = AppCongifP.applicationName;

      if (appName == "OMC") {
        status = "T";
      }

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=SalarySlip&month=$month&year=$selectedYear&Empkid=$empKid&status=$status";

      Uri pdfUrl = Uri.parse(restUrl);
      var uri = Uri.parse(restUrl);
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var content = response.body;
        if (content == "Salary Slip Not Available") {
        await  showAlert('Salary Slip Not Available for this month');
          return;
        } else {
          launchUrl(
            pdfUrl,
            mode: LaunchMode.externalApplication,
          );
         await showAlert('Salary Slip Downloaded Successfully');
          //  selectedStatus = null;
        }
      }

      // launchUrl(pdfUrl,mode: LaunchMode.externalApplication,);
      //  showAlert('Salary Slip Downloaded Successfully');
      // selectedStatus = null;

      // var uri = Uri.parse(restUrl);
      // var response = await http.get(uri);
//       if (response.statusCode == 200) {
//         var content = response.body;
//         if (content == "Salary Slip Not Available") {
//           showAlert('Salary Slip Not Available for this month');
//           return;
//         } else {
//           var pdfUrl = Uri.parse(restUrl);
//           try {
//   if (await canLaunch(pdfUrl.toString())) {
//     await launch(pdfUrl.toString());
//     showAlert('Salary Slip Downloaded Successfully');
//     selectedStatus = null;
//   } else {
//     showAlert('Could not launch URL');
//   }
// } catch (e) {
//   showAlert('Error launching URL: $e');
// }

//         }
//       } else {
//         showAlert('Unable to connect to the server');
//       }
    } catch (e) {
    await  showAlert('Unable to connect to the server');
      debugPrint('ERROR: $e');
    }
  }

   showAlert(String message) async{
  await  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Alert'),
              content: Text(message),
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
        });
      },
    );
  }
}
