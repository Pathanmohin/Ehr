import 'dart:io';

import 'package:ehr/Dashboard/viewmore/Loan/applyforloan.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandatasave/loandatasave.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandetails.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Kycdetails extends StatefulWidget {
  const Kycdetails({super.key});

  @override
  State<Kycdetails> createState() => _KycdetailsState();
}

class _KycdetailsState extends State<Kycdetails> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  // final Controller controller = Controller(); // Your controller instance

  File? _aadhaarFront;
  File? _aadhaarBack;
  File? _panDocument;
  bool _isChecking = false;

  //  Step 1 -------------------------------------------

  String empPanCard = '';
  bool editPan = true;
  String empAdharCard = '';
  bool editAadhaar = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // ------------------------------ Step 1

          if (Loandatasave.empPanCard.isEmpty) {
            editPan = false;
          } else {
            _panNumberController.text = Loandatasave.empPanCard;
          }


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _panNumberController.dispose();
    _aadhaarNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
                      Navigator.pop(context);


        return false;
      },
      child: Scaffold(
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
          leading: IconButton(
            onPressed: () {
                            Navigator.pop(context);

            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  width: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Center(
                                child: Text('2',
                                    style: TextStyle(color: Colors.white))),
                          )),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Text(
                        'Kyc Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "TimesNewRoman",
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Aadhaar Number Field
                      TextFormField(
                        controller: _aadhaarNumberController,
                        keyboardType: TextInputType.number,
                        //readOnly: editAadhaar,
                        maxLength: 12,
                        decoration: const InputDecoration(
                          labelText: 'Aadhaar Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Aadhaar number';
                          }
                          if (value.length != 12 ||
                              !RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Enter a valid 12-digit Aadhaar number';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // PAN Number Field
                      TextFormField(
                        controller: _panNumberController,
                        keyboardType: TextInputType.text,
                        readOnly: editAadhaar,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'PAN Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PAN number';
                          }
                          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
                              .hasMatch(value)) {
                            return 'Enter a valid PAN number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Upload Aadhaar Front
                      ListTile(
                        leading: const Icon(Icons.upload_file),
                        title: Text(_aadhaarFront == null
                            ? 'Upload Aadhaar Front'
                            : _aadhaarFront!.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.file_upload),
                          onPressed: () => pickFile('aadhaarFront'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Upload Aadhaar Back
                      ListTile(
                        leading: const Icon(Icons.upload_file),
                        title: Text(_aadhaarBack == null
                            ? 'Upload Aadhaar Back'
                            : _aadhaarBack!.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.file_upload),
                          onPressed: () => pickFile('aadhaarBack'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Upload PAN Document
                      ListTile(
                        leading: const Icon(Icons.upload_file),
                        title: Text(_panDocument == null
                            ? 'Upload PAN Document'
                            : _panDocument!.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.file_upload),
                          onPressed: () => pickFile('pan'),
                        ),
                      ),
                      const SizedBox(height: 32),

                      InkWell(
                        onTap: () {
                       
                       submit();

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: const Center(
                              child: Text('Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "TimesNewRoman",
                                    fontSize: 18,
                                  ))),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (type == 'aadhaarFront') {
          
          _aadhaarFront = File(result.files.single.path!);

          //checkDocument(_aadhaarFront);
        } else if (type == 'aadhaarBack') {
          _aadhaarBack = File(result.files.single.path!);
        } else if (type == 'pan') {
          _panDocument = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> submit() async {

    if (_formKey.currentState!.validate()) {

      Loandatasave.empFullAdharCard = _aadhaarNumberController.text;

      // // Handle form submission (e.g., send to server)
      // print('Aadhaar Number: ${_aadhaarNumberController.text}');
      // print('PAN Number: ${_panNumberController.text}');
      // print('Aadhaar Front: ${_aadhaarFront!.path}');
      // print('Aadhaar Back: ${_aadhaarBack!.path}');
      // print('PAN Document: ${_panDocument!.path}');

      // print('aditya');

             Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Loandetails()),
        );

    } else {

      //  Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Loandetails()),
      //   );

      // if(Loandatasave.empAdharCard.isNotEmpty){

      //     String adNumber = Loandatasave.empAdharCard;

      //                       String lastFourDigits =
      //                           adNumber.substring(adNumber.length - 4);

      //                       String EnterFourDigits =
      //                           _aadhaarNumberController.text.substring(
      //                               _aadhaarNumberController.text.length - 4);

      //                       if (lastFourDigits != EnterFourDigits) {
      //                         _showAlert(
      //                             'Alert', 'Please Enter Valid Aadhaar Number');
      //                         return;
      //                       } 

      // }


      // if (_aadhaarFront == null ||
      //     _aadhaarBack == null ||
      //     _panDocument == null) {
      //   //  await ScaffoldMessenger.of(context).showSnackBar(
      //   //     SnackBar(content: Text('Please upload all required documents!')),
      //   //   );

      //   _showAlert('Alert', 'Please upload all required documents!');
      //     return;

      // }
    }
  }
}
