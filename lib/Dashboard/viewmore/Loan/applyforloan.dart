import 'dart:convert';

import 'package:ehr/Dashboard/viewmore/Loan/Model/empdetailsmodel.dart';
import 'package:ehr/Dashboard/viewmore/Loan/kycdetails.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandatasave/loandatasave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Applyforloan extends StatefulWidget {
  const Applyforloan({super.key});

  @override
  State<Applyforloan> createState() => _ApplyforloanState();
}

class _ApplyforloanState extends State<Applyforloan> {

// Saluation
  int salutation = 0;
  String salutationValue = '';
  List<String> salutationitems = ['Mr', 'Ms', 'Mrs'];

   TextEditingController empNameController = TextEditingController();
  TextEditingController empMiddleNameController = TextEditingController();
  TextEditingController emplastNameController = TextEditingController();
  TextEditingController empDobController = TextEditingController();
  TextEditingController empAgeController = TextEditingController();
  TextEditingController empPhoneNumber = TextEditingController();
  TextEditingController empEmailID = TextEditingController();
  TextEditingController empFatherName = TextEditingController();
  TextEditingController empMotherName = TextEditingController();

  
    List<Employee> employeeData = [];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Apply Loan",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "TimesNewRoman",
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              const SizedBox(width: 5.0,),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                  children: [
                 
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Center(child: Text('1',style: TextStyle(color: Colors.white ))),
                      )
                    ),
                    const SizedBox(width: 5.0,),
                 
                    const Text('Application Details',
                    style: TextStyle(
                             color: Colors.black,
                             fontFamily: "TimesNewRoman",
                             fontSize: 18,
                           ),),

                  ],
                 ),
               ),

               const SizedBox(height: 10,),
          
               const Text(
                    "Salutation*",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    items: salutationitems.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      getSalutation(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // Dropdown background color
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFieldField(
                    label: 'First Name*',
                    controller: empNameController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Middle Name',
                    controller: empMiddleNameController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Last Name*',
                    controller: emplastNameController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Date of Birth*',
                    controller: empDobController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    controller: empAgeController,
                    readOnly: true,
                  ),

                const SizedBox(height: 16),
                  TextFieldFieldPhone(
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    controller: empPhoneNumber,
                    readOnly: false,
                  ),

                                    const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Email ID',
                    keyboardType: TextInputType.emailAddress,
                    controller: empEmailID,
                    readOnly: false,
                  ),

                                    const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Father’s /Husband’s Name',
                    keyboardType: TextInputType.name,
                    controller: empFatherName,
                    readOnly: true,
                  ),

                 const SizedBox(height: 16),
                  TextFieldField(
                    label: 'Mother’s Name',
                    keyboardType: TextInputType.name,
                    controller: empMotherName,
                    readOnly: true,
                  ),



                  const SizedBox(height: 10.0,),

                  InkWell(
                    onTap: () {

                      bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

            if (salutation == 0) {
              _showAlert('Alert', 'Please select Salutation');
              return;
            } else if (empNameController.text.isEmpty) {
              _showAlert('Alert', 'Please enter First Name');
              return;
            } else if (emplastNameController.text.isEmpty) {
              _showAlert('Alert', 'Please enter Last Name');
              return;
            }else if(empPhoneNumber.text.length < 10){
                         _showAlert('Alert', 'Please Enter Valid Phone Number');
              return;   
            }else if(!isValidEmail(empEmailID.text )){
                         _showAlert('Alert', 'Please Enter Valid Email Address');
              return;  
            }
            else{

                      Loandatasave.empMobile = empPhoneNumber.text ;
                      Loandatasave.empMail = empEmailID.text;
          
                  
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Kycdetails()));
            }


                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: const Center(child: Text('Continue',style: TextStyle(
                               color: Colors.white,
                               fontFamily: "TimesNewRoman",
                               fontSize: 18,
                            ))),
                    ),
                  )
          
            ],
          ),
        ),
      ),
    );
  }

    void getSalutation(String? value) {
    if (value == 'Mr') {
      salutation = 34;
      salutationValue = 'Mr';
      Loandatasave.salutation = 34;
      Loandatasave.salutationValue = 'Mr';
    } else if (value == 'Ms') {
      salutation = 35;
      salutationValue = 'Ms';
            Loandatasave.salutation = 35;
      Loandatasave.salutationValue = 'Ms';
    } else {
      salutation = 36;
      salutationValue = 'Mrs';
            Loandatasave.salutation = 36;
      Loandatasave.salutationValue = 'Mrs';
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    EasyLoading.show(status: 'loading...');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String empKid = prefs.getString('EmpKid') ?? '';

    String apiUrl =
        "http://192.168.1.113/Mobile/ServiceData.aspx?callFor=Employeedata&empkid=15745";
    EasyLoading.dismiss();
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse.toString().isNotEmpty) {
        final List<dynamic> data = json.decode(response.body);
        // for(int i = 0; i < data.length; i++){
        //   Employee emp = Employee.fromJson(data[i]);

        // }
        
        employeeData = data.map((e) => Employee.fromJson(e)).toList();

        // Access all the employee fields:
        var emp = employeeData[0]; // Get the first employee's data

        Loandatasave.empName = emp.firstName; // First Name
        Loandatasave.empLastName = emp.lastName; // Last Name
        Loandatasave.empMiddleName = emp.middleName; // Middle Name
        Loandatasave.empDob = emp.empJoinDob; // Date of Birth
        //String empEmpNo = emp.empJoinEmpNo;            // Employee Number
        //empDob = emp.empJoinDob;                // Date of Birth
        Loandatasave.empAge = emp.age.toString(); // Age

        Loandatasave.empMail = emp.mail; // Email
        Loandatasave.empMobile = emp.mobile; // Mobile Number
        Loandatasave.empParentSpouseName = emp.parentSpouseName; // Parent/Spouse Name
        Loandatasave.empFatherName = emp.fatherName; // Father's Name
        Loandatasave.empMotherName = emp.motherName; // Mother's Name
        Loandatasave.empSpouseName = emp.spouseName; // Husband/Wife Name



        Loandatasave.empPanCard = emp.panCard; // Pan Card
         Loandatasave.empAdharCard = emp.adharCard; // Aadhar Card
        String empGender = emp.gender; // Gender
        String empMaritalStatus = emp.maritalStatus; // Marital Status
        String empReligion = emp.religion; // Religion
        String empBloodGroup = emp.empJoinBldGrp; // Blood Group
        String empDept = emp.deptEname; // Department
        String empDesignation = emp.dsgEname; // Designation
        String empManager = emp.manager; // Manager Name
        String empDoj = emp.doj; // Date of Joining
        String empPostingOffice = emp.postingOffice; // Posting Office
        String empBankAccount = emp.bankAccount; // Bank Account Number
        String empIfsc = emp.ifsc; // IFSC Code
        String empCategory = emp.categoryName; // Category Name
        String empGrade = emp.grade; // Grade
        String empCadre = emp.cadre; // Cadre

        // if(empName.isNotEmpty){
        //   editName = true;
        // }else{
        //   editName = false;
        // }
        EasyLoading.dismiss();

        setState(() {
// ---------------------------------Step 0
          empNameController.text = Loandatasave.empName;
          emplastNameController.text = Loandatasave.empLastName;
          empMiddleNameController.text = Loandatasave.empMiddleName;
          empDobController.text = Loandatasave.empDob;
          if (Loandatasave.empAge.isEmpty) {
            DateTime dateTime = DateFormat('dd/MM/yyyy').parse(Loandatasave.empDob);

            // Format the DateTime object into the desired format
            String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
            empAgeController.text = formattedDate;
          } else {
            empAgeController.text = Loandatasave.empAge;
          }

          empPhoneNumber.text = Loandatasave.empMobile;
          empEmailID.text = Loandatasave.empMail.toLowerCase();
          empMotherName.text = Loandatasave.empMotherName;
          empFatherName.text = Loandatasave.empParentSpouseName;

        //   // ------------------------------ Step 1
        //   if (empPanCard.isEmpty) {
        //     editPan = false;
        //   } else {
        //     _panNumberController.text = empPanCard;
        //   }

        //   // ------------------------------ Step 2

        });
      } else {
        _showAlert('Alert', 'Employee Data Not Found');
      }
    } else {
      //print('Request failed with status: ${response.statusCode}.');
      _showAlert(
          'Alert', 'Request failed with status: ${response.statusCode}.');

      EasyLoading.dismiss();
    }
  }


}


class TextFieldFieldPhone extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool readOnly;

  const TextFieldFieldPhone(
      {super.key,
      required this.label,
      this.keyboardType = TextInputType.text,
      required this.controller,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
  

class TextFieldField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool readOnly;

  const TextFieldField(
      {super.key,
      required this.label,
      this.keyboardType = TextInputType.text,
      required this.controller,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}