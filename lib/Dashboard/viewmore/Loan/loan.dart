// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:ehr/Dashboard/viewmore/Loan/Model/applicationceatemodel.dart';
// import 'package:ehr/Dashboard/viewmore/Loan/Model/empdetailsmodel.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ApplyLoan extends StatefulWidget {
//   const ApplyLoan({super.key});

//   @override
//   State<ApplyLoan> createState() => _ApplyLoanStepperState();
// }

// class _ApplyLoanStepperState extends State<ApplyLoan> {
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();
//   final _aadhaarNumberController = TextEditingController();
//   final _panNumberController = TextEditingController();
//   // final Controller controller = Controller(); // Your controller instance

//   File? _aadhaarFront;
//   File? _aadhaarBack;
//   File? _panDocument;
//   bool _isChecking = false;

//   int setCountValue = 0;
//   List<Employee> employeeData = [];

//   Future<void> pickFile(String type) async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.any);

//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         if (type == 'aadhaarFront') {
//           _aadhaarFront = File(result.files.single.path!);

//           //checkDocument(_aadhaarFront);
//         } else if (type == 'aadhaarBack') {
//           _aadhaarBack = File(result.files.single.path!);
//         } else if (type == 'pan') {
//           _panDocument = File(result.files.single.path!);
//         }
//       });
//     }
//   }

//   //  Future<void> checkDocument(File? aadhaarFront) async {
//   //   if (aadhaarFront == null) {
//   //     _showAlert("No file selected", "Please select a document to check.");
//   //     return;
//   //   }

//   //   setState(() {
//   //     _isChecking = true;
//   //   });

//   //   try {
//   //     final inputImage = InputImage.fromFilePath(aadhaarFront.path!);
//   //     final textRecognizer = GoogleMlKit.vision.textRecognizer();
//   //     final recognizedText = await textRecognizer.processImage(inputImage);

//   //     final aadhaarRegex = RegExp(r'\d{4} \d{4} \d{4}');
//   //     final keywords = ['aadhaar', 'aadhar', 'unique identification authority'];

//   //     bool hasAadhaarNumber = aadhaarRegex.hasMatch(recognizedText.text);
//   //     bool hasKeywords = keywords.any((word) =>
//   //         recognizedText.text.toLowerCase().contains(word.toLowerCase()));

//   //     if (hasAadhaarNumber && hasKeywords) {
//   //       _showAlert("Valid Document", "This document appears to be an Aadhaar card.");
//   //     } else {
//   //       _showAlert("Invalid Document", "This document is NOT an Aadhaar card.");
//   //     }
//   //     await textRecognizer.close();
//   //   } catch (e) {
//   //     _showAlert("Error", "Failed to process the document: $e");
//   //   } finally {
//   //     setState(() {
//   //       _isChecking = false;
//   //     });
//   //   }
//   // }

//   void _showAlert(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> submit() async {
//     if (_formKey.currentState!.validate()) {
//       setCountValue = 0;



//       // // Handle form submission (e.g., send to server)
//       // print('Aadhaar Number: ${_aadhaarNumberController.text}');
//       // print('PAN Number: ${_panNumberController.text}');
//       // print('Aadhaar Front: ${_aadhaarFront!.path}');
//       // print('Aadhaar Back: ${_aadhaarBack!.path}');
//       // print('PAN Document: ${_panDocument!.path}');


//     } else {

//       setCountValue = 1;


//       if (_aadhaarFront == null ||
//           _aadhaarBack == null ||
//           _panDocument == null) {
//         //  await ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(content: Text('Please upload all required documents!')),
//         //   );

//         return;
//       }
//     }



//   }

//   //  Step 0 -------------------------------------------

//   String empName = '';
//   bool editName = false;
//   String empMiddleName = '';
//   String empLastName = '';
//   String empDob = '';
//   String empAge = '';

//   //  Step 1 -------------------------------------------

//   String empPanCard = '';
//   bool editPan = true;
//   String empAdharCard = '';
//   bool editAadhaar = true;

// // Step 2 -------------------------------------------

//   String? selectedPurpose;

//   final Map<String, int> loanPurposes = {
//     'Debt consolidation': 37,
//     'Medical emergencies': 38,
//     'Education expenses': 39,
//     'Home renovation': 40,
//     'Travel expenses': 41,
//     'Wedding expenses': 42,
//     'Working capital requirements': 43,
//     'Business expansion': 44,
//     'Operational expenses': 45,
//     'Construction of a new home': 46,
//   };

//   Future<void> getData() async {
//     EasyLoading.show(status: 'loading...');

//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     String empKid = prefs.getString('EmpKid') ?? '';

//     String apiUrl =
//         "http://192.168.1.113/Mobile/ServiceData.aspx?callFor=Employeedata&empkid=15745";
//     EasyLoading.dismiss();
//     var response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);

//       if (jsonResponse.toString().isNotEmpty) {
//         final List<dynamic> data = json.decode(response.body);
//         // for(int i = 0; i < data.length; i++){
//         //   Employee emp = Employee.fromJson(data[i]);

//         // }
//         employeeData = data.map((e) => Employee.fromJson(e)).toList();

//         // Access all the employee fields:
//         var emp = employeeData[0]; // Get the first employee's data

//         empName = emp.firstName; // First Name
//         empLastName = emp.lastName; // Last Name
//         empMiddleName = emp.middleName; // Middle Name
//         empDob = emp.empJoinDob; // Date of Birth
//         //String empEmpNo = emp.empJoinEmpNo;            // Employee Number
//         //empDob = emp.empJoinDob;                // Date of Birth
//         empAge = emp.age.toString(); // Age

//         String empMail = emp.mail; // Email
//         String empMobile = emp.mobile; // Mobile Number
//         String empParentSpouseName = emp.parentSpouseName; // Parent/Spouse Name
//         String empFatherName = emp.fatherName; // Father's Name
//         String empMotherName = emp.motherName; // Mother's Name
//         String empSpouseName = emp.spouseName; // Husband/Wife Name
//         empPanCard = emp.panCard; // Pan Card
//         empAdharCard = emp.adharCard; // Aadhar Card
//         String empGender = emp.gender; // Gender
//         String empMaritalStatus = emp.maritalStatus; // Marital Status
//         String empReligion = emp.religion; // Religion
//         String empBloodGroup = emp.empJoinBldGrp; // Blood Group
//         String empDept = emp.deptEname; // Department
//         String empDesignation = emp.dsgEname; // Designation
//         String empManager = emp.manager; // Manager Name
//         String empDoj = emp.doj; // Date of Joining
//         String empPostingOffice = emp.postingOffice; // Posting Office
//         String empBankAccount = emp.bankAccount; // Bank Account Number
//         String empIfsc = emp.ifsc; // IFSC Code
//         String empCategory = emp.categoryName; // Category Name
//         String empGrade = emp.grade; // Grade
//         String empCadre = emp.cadre; // Cadre

//         // if(empName.isNotEmpty){
//         //   editName = true;
//         // }else{
//         //   editName = false;
//         // }
//         EasyLoading.dismiss();

//         setState(() {
// // ---------------------------------Step 0
//           empNameController.text = empName;
//           emplastNameController.text = empLastName;
//           empMiddleNameController.text = empMiddleName;
//           empDobController.text = empDob;
//           if (empAge.isEmpty) {
//             DateTime dateTime = DateFormat('dd/MM/yyyy').parse(empDob);

//             // Format the DateTime object into the desired format
//             String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
//             empAgeController.text = formattedDate;
//           } else {
//             empAgeController.text = empAge;
//           }

//           // ------------------------------ Step 1
//           if (empPanCard.isEmpty) {
//             editPan = false;
//           } else {
//             _panNumberController.text = empPanCard;
//           }

//           // ------------------------------ Step 2
//         });
//       } else {
//         _showAlert('Alert', 'Employee Data Not Found');
//       }
//     } else {
//       //print('Request failed with status: ${response.statusCode}.');
//       _showAlert(
//           'Alert', 'Request failed with status: ${response.statusCode}.');

//       EasyLoading.dismiss();
//     }
//   }

//   TextEditingController empNameController = TextEditingController();
//   TextEditingController empMiddleNameController = TextEditingController();
//   TextEditingController emplastNameController = TextEditingController();
//   TextEditingController empDobController = TextEditingController();
//   TextEditingController empAgeController = TextEditingController();
//   TextEditingController empMobileController = TextEditingController();
//   TextEditingController empEmailController = TextEditingController();
//   TextEditingController empFatherNameController = TextEditingController();
//   TextEditingController empMotherNameController = TextEditingController();
//   TextEditingController empGenderController = TextEditingController();
//   TextEditingController empQualificationController = TextEditingController();
//   TextEditingController empMaritalStatusController = TextEditingController();
//   TextEditingController empCasteController = TextEditingController();
//   TextEditingController empReligionController = TextEditingController();
//   TextEditingController empProfessionController = TextEditingController();
//   TextEditingController empAddressLine1Controller = TextEditingController();
//   TextEditingController empAddressLine2Controller = TextEditingController();
//   TextEditingController empPincodeController = TextEditingController();
//   TextEditingController empStateController = TextEditingController();
//   TextEditingController empDistrictController = TextEditingController();
//   TextEditingController empCityController = TextEditingController();
//   TextEditingController empMandalController = TextEditingController();
//   TextEditingController empCountryController = TextEditingController();
//   TextEditingController empAddressTypeController = TextEditingController();
//   TextEditingController empAddressSubTypeController = TextEditingController();
//   TextEditingController empLongitudeController = TextEditingController();
//   TextEditingController empLatitudeController = TextEditingController();
//   TextEditingController empSubmittedOnController = TextEditingController();
//   TextEditingController empLoanAmountController = TextEditingController();
//   TextEditingController empTenureController = TextEditingController();
//   TextEditingController empEmiAmountController = TextEditingController();
//   TextEditingController empLoanPurposeController = TextEditingController();
//   TextEditingController empSubmittedOnDateController = TextEditingController();
//   TextEditingController empTehsilController = TextEditingController();
//   TextEditingController submitDate = TextEditingController();

// // Saluation
//   int salutation = 0;
//   String salutationValue = '';
//   List<String> salutationitems = ['Mr', 'Ms', 'Mrs'];



//   // Selected value
//   int? selectedValue;

//   // Address -------------------

//   int? addressTypeValue; // Store the selected integer value
//   final List<Map<String, dynamic>> addressTypes = [
//     {'label': 'Owned', 'value': 0},
//     {'label': 'Parental', 'value': 1},
//     {'label': 'Rental', 'value': 2},
//   ];



// // Loan Details

// int loanPurpose = 0;
// String loanPurposeValue = '';


//   @override
//   void initState() {
//     super.initState();
//     getData();

//     DateTime now = DateTime.now();

//     // Format the date as "dd MMMM yyyy" (e.g., "27 January 2025")
//     String subMittedOnDate = DateFormat('dd MMMM yyyy').format(now);

//     submitDate.text = subMittedOnDate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Apply Loan",
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: "TimesNewRoman",
//             fontSize: 18,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Stepper(
//         currentStep: _currentStep,
//         onStepContinue: () {



//           if (_currentStep == 0) {

//             if (salutation == 0) {
//               _showAlert('Alert', 'Please select Salutation');
//               return;
//             } else if (empNameController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter First Name');
//               return;
//             } else if (emplastNameController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Last Name');
//               return;
//             }else{
//               setState(() {
//                 _currentStep = 1;
//               });
//               return;
//             } 
//           } 
          
//          if (_currentStep == 1) {

//             submit();

//             if(setCountValue == 0){
//              setState(() {
//                 _currentStep++;
//               });

//               return;
//             }

//             // if (empAdharCard.isNotEmpty) {
//             //   String adNumber = empAdharCard;
//             //   String lastFourDigits = adNumber.substring(adNumber.length - 4);

//             //   String EnterFourDigits = _aadhaarNumberController.text
//             //       .substring(_aadhaarNumberController.text.length - 4);

//             //   if (lastFourDigits != EnterFourDigits) {
//             //     _showAlert('Alert', 'Please Enter Valid Aadhaar Number');
//             //     return;
//             //   } else {
//             //     submit();
//             //   }
//             // }

//             // if(empAdharCard.isEmpty){
               
//             //   submit();
            
//             // }
//           } 
          
          
//           if (_currentStep == 2) {

//             if (empLoanAmountController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Loan Amount');
//               return;
//             } else if ( double.parse(empLoanAmountController.text) > 50000) {
//               _showAlert('Alert', 'Loan Amount should be less than 50000');
//               return;
//             } else if (empTenureController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Tenure');
//               return;
//             }else if(empEmiAmountController.text.isEmpty){
//               _showAlert('Alert', 'Please enter Comfortable EMI Amount');
//               return;
//             }
//             else if(loanPurposeValue.isEmpty){
//               _showAlert('Alert', 'Please select Loan Purpose');
//               return;
//             }

//                setState(() {
//                 _currentStep++;
//               });

//               return;
//           }
          
          
//            if(_currentStep == 3){

//             if (empAddressLine1Controller.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Address Line 1');
//               return;
//             } else if (empPincodeController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Pincode');
//               return;
//             } else if (empStateController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter State');
//               return;
//             } else if (empDistrictController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter District');
//               return;
//             } else if (empCountryController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Country');
//               return;
//             } else if (empTehsilController.text.isEmpty) {
//               _showAlert('Alert', 'Please enter Tehsil');
//               return;
//             } 


//               setState(() {
//                 _currentStep++;
//               });

//               return;

//            }

        
//         },



//         onStepCancel: () {
//           if (_currentStep > 0) {
//             setState(() {
//               _currentStep--;
//             });
//           }
//         },
//         onStepTapped: (step) {
//           // setState(() {
//           //   _currentStep = step;
//           // });
//         },
//         steps: [
//           // Applicant Details
//           Step(
//             title: const Text("Applicant Details"),
//             isActive: _currentStep >= 0,
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 const Text(
//                   "Salutation*",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 4),
//                 DropdownButtonFormField<String>(
//                   dropdownColor: Colors.white,
//                   items: salutationitems.map((item) {
//                     return DropdownMenuItem(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     getSalutation(value);
//                   },
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white, // Dropdown background color
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'First Name*',
//                   controller: empNameController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Middle Name',
//                   controller: empMiddleNameController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Last Name*',
//                   controller: emplastNameController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Date of Birth*',
//                   controller: empDobController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Age',
//                   keyboardType: TextInputType.number,
//                   controller: empAgeController,
//                   readOnly: true,
//                 ),
//               ],
//             ),
//           ),

//           Step(
//               title: const Text("KYC Details"),
//               isActive: _currentStep >= 1,
//               content: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10),
//                     // Aadhaar Number Field
//                     TextFormField(
//                       controller: _aadhaarNumberController,
//                       keyboardType: TextInputType.number,
//                       //readOnly: editAadhaar,
//                       maxLength: 12,
//                       decoration: const InputDecoration(
//                         labelText: 'Aadhaar Number',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter Aadhaar number';
//                         }
//                         if (value.length != 12 ||
//                             !RegExp(r'^\d+$').hasMatch(value)) {
//                           return 'Enter a valid 12-digit Aadhaar number';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // PAN Number Field
//                     TextFormField(
//                       controller: _panNumberController,
//                       keyboardType: TextInputType.text,
//                       readOnly: editAadhaar,
//                       maxLength: 10,
//                       decoration: const InputDecoration(
//                         labelText: 'PAN Number',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter PAN number';
//                         }
//                         if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
//                             .hasMatch(value)) {
//                           return 'Enter a valid PAN number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Upload Aadhaar Front
//                     ListTile(
//                       leading: const Icon(Icons.upload_file),
//                       title: Text(_aadhaarFront == null
//                           ? 'Upload Aadhaar Front'
//                           : _aadhaarFront!.path.split('/').last),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.file_upload),
//                         onPressed: () => pickFile('aadhaarFront'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Upload Aadhaar Back
//                     ListTile(
//                       leading: const Icon(Icons.upload_file),
//                       title: Text(_aadhaarBack == null
//                           ? 'Upload Aadhaar Back'
//                           : _aadhaarBack!.path.split('/').last),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.file_upload),
//                         onPressed: () => pickFile('aadhaarBack'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Upload PAN Document
//                     ListTile(
//                       leading: const Icon(Icons.upload_file),
//                       title: Text(_panDocument == null
//                           ? 'Upload PAN Document'
//                           : _panDocument!.path.split('/').last),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.file_upload),
//                         onPressed: () => pickFile('pan'),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               )),

//           // Loan Details
//           Step(
//             title: const Text("Loan Details"),
//             isActive: _currentStep >= 2,
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 TextFieldField(
//                   label: 'Loan Amount*',
//                   keyboardType: TextInputType.number,
//                   controller: empLoanAmountController,
//                   readOnly: false,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Tenure (In Months)*',
//                   keyboardType: TextInputType.number,
//                   controller: empTenureController,
//                   readOnly: false,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Comfortable EMI Amount',
//                   keyboardType: TextInputType.number,
//                   controller: empEmiAmountController,
//                   readOnly: false,
//                 ),
//                 const SizedBox(height: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Loan Purpose*",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                    DropdownButtonFormField<String>(
//               value: selectedPurpose,
//               dropdownColor: Colors.white,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white, // Dropdown background color
//               ),
//               hint: Text("Select Loan Purpose"),
//               isExpanded: true,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedPurpose = newValue;

//                   if(selectedPurpose == 'Debt consolidation'){
//                     loanPurpose = 37;
//                     loanPurposeValue = 'Debt consolidation';
//                   }else if(selectedPurpose == 'Medical emergencies'){
//                     loanPurpose = 38;
//                     loanPurposeValue = 'Medical emergencies';
//                   }else if(selectedPurpose == 'Education expenses'){
//                     loanPurpose = 39;
//                     loanPurposeValue = 'Education expenses';
//                   }else if(selectedPurpose == 'Home renovation'){
//                     loanPurpose = 40;
//                     loanPurposeValue = 'Home renovation';
//                   }else if(selectedPurpose == 'Travel expenses'){
//                     loanPurpose = 41;
//                     loanPurposeValue = 'Travel expenses';
//                   }else if(selectedPurpose == 'Wedding expenses'){
//                     loanPurpose = 42;
//                     loanPurposeValue = 'Wedding expenses';
//                   }else if(selectedPurpose == 'Working capital requirements'){
//                     loanPurpose = 43;
//                     loanPurposeValue = 'Working capital requirements';
//                   }else if(selectedPurpose == 'Business expansion'){
//                     loanPurpose = 44;
//                     loanPurposeValue = 'Business expansion';
//                   }else if(selectedPurpose == 'Operational expenses'){
//                     loanPurpose = 45;
//                     loanPurposeValue = 'Operational expenses';
//                   }else if(selectedPurpose == 'Construction of a new home'){
//                     loanPurpose = 46;
//                     loanPurposeValue = 'Construction of a new home';
//                   }


//                   // int loanPurpose = 0;
//                   // String loanPurposeValue = '';
//                 });
//               },
//               items: loanPurposes.keys.map((String purpose) {
//                 return DropdownMenuItem<String>(
//                   value: purpose,
//                   child: Text(purpose),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             if (selectedPurpose != null)
//               Text('Selected Purpose: $selectedPurpose'),
//           ],
//         ),
                 

//                 const SizedBox(height: 16),
//                 TextFieldFieldDate(
//                   label: 'Submitted On*',
//                   controller: submitDate,
//                 ),
//               ],
//             ),
//           ),

//           // Address Details
//           Step(
//             title: const Text("Address Details"),
//             isActive: _currentStep >= 3,
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 DropdownButtonFormField<int>(
//                   value: selectedValue,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white, // Dropdown background color
//                   ),
//                   hint: const Text('Select Address Type'),
//                   onChanged: (int? newValue) {
//                     setState(() {
//                       selectedValue = newValue;
//                     });
//                   },
//                   items: addressTypes.map((type) {
//                     return DropdownMenuItem<int>(
//                       value: type['value'],  // Use the integer value
//                       child: Text(type['label']), // Display the label
//                     );
//                   }).toList(),
//                 ),
                
                
//                                     const SizedBox(width: 16),
//                                     const Expanded(
//                                       child: DropdownField(
//                                         label: 'Address Subtype*',
//                                         items: ['Owned', 'Rented'],
//                                       ),
//                                     ),
//                 const SizedBox(height: 16),
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: TextFieldField(label: 'Longitude', controller: empLongitudeController, readOnly: true,),
//                 //     ),
//                 //     const SizedBox(width: 16),
//                 //     Expanded(
//                 //       child: TextFieldField(label: 'Latitude', controller:empLatitudeController, readOnly: true ,),
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Address Line 1*',
//                   controller: empAddressLine1Controller,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Address Line 2',
//                   controller: empAddressLine2Controller,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFieldField(
//                         label: 'Pincode*',
//                         controller: empPincodeController,
//                         readOnly: true,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     const Expanded(
//                       child: DropdownField(
//                         label: 'State*',
//                         items: ['State 1', 'State 2'],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Row(
//                   children: [
//                     Expanded(
//                       child: DropdownField(
//                           label: 'District*',
//                           items: ['District 1', 'District 2']),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: DropdownField(
//                         label: 'City/Village',
//                         items: ['City 1', 'Village 1'],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFieldField(
//                         label: 'Mandal/Tehsil',
//                         controller: empTehsilController,
//                         readOnly: true,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: TextFieldField(
//                         label: 'Country*',
//                         controller: empCountryController,
//                         readOnly: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Additional Details
//           Step(
//             title: const Text("Additional Details"),
//             isActive: _currentStep == 4,
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const DropdownField(
//                     label: 'Gender', items: ['Male', 'Female', 'Other']),
//                 const SizedBox(height: 16),
//                 const DropdownField(
//                     label: 'Qualification',
//                     items: ['Graduate', 'Post Graduate']),
//                 const SizedBox(height: 16),
//                 const DropdownField(
//                     label: 'Marital Status',
//                     items: ['Single', 'Married', 'Divorced']),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Caste',
//                   controller: empCasteController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Religion',
//                   controller: empReligionController,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFieldField(
//                   label: 'Profession',
//                   controller: empProfessionController,
//                   readOnly: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // ---------------------------------------getSalutation

//   void getSalutation(String? value) {
//     if (value == 'Mr') {
//       salutation = 34;
//       salutationValue = 'Mr';
//     } else if (value == 'Ms') {
//       salutation = 35;
//       salutationValue = 'Ms';
//     } else {
//       salutation = 36;
//       salutationValue = 'Mrs';
//     }
//   }
// }

// class DropdownFieldAdd extends StatelessWidget {
//   final String label;
//   final List<Map<String, dynamic>> items;

//   const DropdownFieldAdd({super.key, required this.label, required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         DropdownButtonFormField<Map<String, dynamic>>(
//           items: items.map((item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Text(item['label']),
//             );
//           }).toList(),
//           onChanged: (value) {},
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             filled: true,
//             fillColor: Colors.white, // Dropdown background color
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Helper Widgets
// class DropdownField extends StatelessWidget {
//   final String label;
//   final List<String> items;

//   const DropdownField({super.key, required this.label, required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         DropdownButtonFormField<String>(
//           items: items.map((item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Text(item),
//             );
//           }).toList(),
//           onChanged: (value) {},
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             filled: true,
//             fillColor: Colors.white, // Dropdown background color
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TextFieldField extends StatelessWidget {
//   final String label;
//   final TextInputType keyboardType;
//   final TextEditingController controller;
//   final bool readOnly;

//   const TextFieldField(
//       {super.key,
//       required this.label,
//       this.keyboardType = TextInputType.text,
//       required this.controller,
//       required this.readOnly});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           readOnly: readOnly,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TextFieldFieldDate extends StatelessWidget {
//   final String label;
//   final TextInputType keyboardType;
//   final TextEditingController controller;

//   const TextFieldFieldDate(
//       {super.key,
//       required this.label,
//       this.keyboardType = TextInputType.text,
//       required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           readOnly: true,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             suffixIcon: Icon(Icons.calendar_today),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class DatePickerField extends StatelessWidget {
//   final String label;

//   DatePickerField({super.key, required this.label});

//   final TextEditingController _submittedDate = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 4),
//         TextField(
//           controller: TextEditingController()..text = DateTime.now().toString(),
//           readOnly: true, // Prevent editing directly
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             suffixIcon: Icon(Icons.calendar_today),
//           ),
//           onTap: () async {
//             // Show the date picker when the field is tapped
//             DateTime? selectedDate = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );

//             if (selectedDate != null) {
//               _submittedDate.text =
//                   DateFormat('dd/MM/yyyy').format(selectedDate);
//             }
//           },
//         )
//       ],
//     );
//   }

//   Future<void> newApplicationForm() async {
//     const String url =
//         'https://bharuwa.nscspl.in/fineract-provider/api/v1/loans/newApplicationForm';
//     const Map<String, String> headers = {
//       'Authorization': 'Basic Y2hvdWRoYXJ5OmNob3VkaGFyeUAxMjM=',
//       'Content-Type': 'application/json;charset=UTF-8',
//       'Fineract-Platform-TenantId': 'default',
//     };

//     // Create the KYC data list
//     final kycDataList = [
//       KycData(
//         verificationTypeId: 3,
//         kycTypeId: 0,
//         legalFormTypeId: 1,
//         validationStatusId: 0,
//         entity: "client",
//         locale: "en",
//         documentTypeId: 1,
//         isFrontSide: true,
//         isBackSide: true,
//         isDocumentDrivingLicence: false,
//         isOcr: false,
//         documentKey: "993721612622",
//       ),
//       KycData(
//         verificationTypeId: 3,
//         kycTypeId: 1,
//         legalFormTypeId: 1,
//         validationStatusId: 0,
//         entity: "client",
//         locale: "en",
//         documentTypeId: 2,
//         isFrontSide: true,
//         isBackSide: false,
//         isDocumentDrivingLicence: false,
//         isOcr: false,
//         documentKey: "ABCDE1234D",
//       ),
//     ];
//     ClientData clientData = ClientData(
//       submittedOnDate: "15 January 2025",
//       officeId: 1,
//       legalFormId: 1,
//       dateOfBirth: "12 December 1998",
//       mobileNo: "9999888707",
//       dateFormat: "dd MMMM yyyy",
//       active: true,
//       familyMembers: [],
//       locale: "en",
//       salutation: 22,
//       firstName: "Rahul",
//       lastName: "choudhary",
//       middleName: "SINGH",
//       age: 26,
//       emailAddress: "rahul.choudhary@gmail.xyz",
//       fatherName: "SURENDRA",
//       motherName: "SAROJ",
//       genderId: 36,
//       qualification: 45,
//       maritalStatusId: 50,
//       cast: 51,
//       religion: 55,
//       profession: 64,
//       activationDate: "15 January 2025",
//       address: [
//         Address(
//           locale: "en",
//           dateFormat: "dd MMM yyyy",
//           country: "India",
//           addressTypeId: 0,
//           addressSubTypeId: 0,
//           addressLine1: "gali No. 12",
//           addressLine2: "mansarovar",
//           postalCode: "302020",
//           district: "Jaipur",
//           state: "Rajasthan",
//           city: "Mansarovar",
//           tehsil: "mansarovar",
//         ),
//       ],
//     );
//     LoanData loanData = LoanData(
//       productId: 1,
//       repaymentEvery: 1,
//       repaymentFrequencyType: 2,
//       interestRatePerPeriod: 18,
//       amortizationType: 1,
//       interestCalculationPeriodType: 1,
//       interestType: 0,
//       isEqualAmortization: false,
//       transactionProcessingStrategyId: 1,
//       submittedOnDate: "15 January 2025",
//       allowPartialPeriodInterestCalcualtion: true,
//       charges: [
//         Charge(
//             chargeId: 1,
//             name: "Processing Fee",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 2,
//                 code: "chargeCalculationType.percent.of.amount",
//                 value: "% Amount"),
//             percentage: 2.36,
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 2.36,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 2.36,
//             amountOrPercentage: 2.36,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
//         Charge(
//             chargeId: 3,
//             name: "Cersai Charge",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 500,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 500,
//             amountOrPercentage: 500,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 5,
//                 code: "chargeSlabType.principalAmount",
//                 value: "Principal Amount")),
//         Charge(
//             chargeId: 7,
//             name: "Field Visit Charge",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 885,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 885,
//             amountOrPercentage: 885,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
//         Charge(
//             chargeId: 16,
//             name: "Stamp Duty On loan And Property Documents",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 500,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 500,
//             amountOrPercentage: 500,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
//         Charge(
//             chargeId: 17,
//             name: "Non-Encumbrance Certificate / Search Report",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 500,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 500,
//             amountOrPercentage: 500,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
//         Charge(
//             chargeId: 18,
//             name: "Valuation/Technical Fee",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 500,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 500,
//             amountOrPercentage: 500,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
//         Charge(
//             chargeId: 21,
//             name: "Insurance charges",
//             chargeTimeType: ChargeTimeType(
//                 id: 1,
//                 code: "chargeTimeType.disbursement",
//                 value: "Disbursement"),
//             chargeCalculationType: ChargeCalculationType(
//                 id: 1, code: "chargeCalculationType.flat", value: "Flat"),
//             currency: Currency(
//                 code: "INR",
//                 name: "Indian Rupee",
//                 decimalPlaces: 2,
//                 displaySymbol: "₹",
//                 nameCode: "currency.INR",
//                 displayLabel: "Indian Rupee (₹)"),
//             amount: 500,
//             amountPaid: 0,
//             amountWaived: 0,
//             amountWrittenOff: 0,
//             amountOutstanding: 500,
//             amountOrPercentage: 500,
//             penalty: false,
//             chargePaymentMode: ChargePaymentMode(
//                 id: 0, code: "chargepaymentmode.regular", value: "Regular"),
//             paid: false,
//             waived: false,
//             chargePayable: false,
//             taxInclusive: true,
//             isSlabBased: false,
//             slabChargeType: SlabChargeType(
//                 id: 0, code: "chargeSlabType.invalid", value: "Invalid"))
//       ],
//       checklistTemplate: [],
//       loanPurposeOptions: [
//         LoanPurposeOption(
//             id: 26,
//             name: "FOUR  WHEELER",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 24,
//             name: "BUSINESS LOAN",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 34,
//             name: "TWO WHEELER",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 32,
//             name: "REPAY DEBTS",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 30,
//             name: "PAY COST OF VEHICLE",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 27,
//             name: "HEAVY COMMERCIAL VEHICLE",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 25,
//             name: "CONSUMER",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 23,
//             name: "AGRICULTURE",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 35,
//             name: "USED CAR LOANS",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 33,
//             name: "THREE WHEELER",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 31,
//             name: "PURCHASE ANOTHER PROPERTY",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 29,
//             name: "PAY COST OF COLLATERAL",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 28,
//             name: "MARRIAGE",
//             position: 0,
//             description: "",
//             active: true,
//             mandatory: false),
//         LoanPurposeOption(
//             id: 286,
//             name: "others",
//             position: 1,
//             description: "",
//             active: true,
//             mandatory: false)
//       ],
//       principalThresholdForLastInstallmentofLoan: 0,
//       AddPartialPeriodInterest: "N/A",
//       loanTermFrequencyType: 2,
//       disbursementData: [
//         DisbursementData(
//             expectedDisbursementDate: "15 January 2025", principal: "200000")
//       ],
//       locale: "en",
//       dateFormat: "dd MMMM yyyy",
//       loanType: "individual",
//       isLoanApplication: true,
//       isBrokenPeriodInterestUpfront: false,
//       interestUpfront: false,
//       useSop: true,
//       internalSalesId: 12,
//       channelType: "selfSourced",
//       principal: "200000",
//       numberOfRepayments: "24",
//       isSelfSourced: true,
//       maxOutstandingLoanBalance: "200000",
//       loanTermFrequency: "24",
//     );
//     // Create the LoanApplication object
//     final loanApplication = LoanApplication(
//       kycData: kycDataList,
//       clientData: clientData.toJson(),
//       loanData: loanData.toJson(),
//       identifiers: [],
//       entity: "client",
//       entityType: "client",
//     );

//     // Convert LoanApplication to JSON
//     final body = loanApplication.toJson();

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         if (data.toString().isNotEmpty) {
//         } else if (data.toString().isEmpty) {
//           print('Response Data: $data');
//         }
//       } else {
//         print('Error: ${response.statusCode}, ${response.body}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }
// }
