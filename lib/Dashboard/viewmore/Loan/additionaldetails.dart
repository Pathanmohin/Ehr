import 'dart:convert';
import 'dart:io';

import 'package:ehr/Dashboard/viewmore/Loan/Model/applicationceatemodel.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandatasave/loandatasave.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class Additionaldetails extends StatefulWidget {
  const Additionaldetails({super.key});

  @override
  State<Additionaldetails> createState() => _AdditionaldetailsState();
}

class _AdditionaldetailsState extends State<Additionaldetails> {
  TextEditingController _professionController = TextEditingController();
  int salaried = 63;

String genderlable = '';
 int genderValue = 0;
String qualificationlable = '';
 int qualificationValue = 0;
String maritallable = '';
 int maritalValue = 0;
 String castelable = '';
 int casteValue = 0;

 String religionLable = '';
 int religionValue = 0;


  Qualification? qualification;

  List<Qualification> quList = <Qualification>[
    Qualification(label: 'MATRIC', value: 16),
    Qualification(label: 'GRADUATION', value: 17),
    Qualification(label: 'OTHER', value: 18),
    Qualification(label: 'MASTER DEGREE', value: 19),
    Qualification(label: 'PROFESSIONAL DIPLOMA', value: 20),
    Qualification(label: 'PROFESSIONAL DEGREE', value: 21),
  ];

  Gender? gender;

  List<Gender> genderlist = <Gender>[
    Gender(label: 'Male', value: 47),
    Gender(label: 'Female', value: 48),
  ];


MaritalStatus? maritalStatus;

List<MaritalStatus> maritalList = <MaritalStatus>[
  MaritalStatus(label: 'Married', value: 49),
  MaritalStatus(label: 'Unmarried', value: 50),
  MaritalStatus(label: 'Divorcee', value: 51),
  MaritalStatus(label: 'Widow/Widower', value: 52),
];

Caste? caste;
List<Caste> casteList = <Caste>[
Caste(label: 'General', value: 53),
Caste(label: 'OBC', value: 54),
Caste(label: 'SC', value: 55),
Caste(label: 'ST', value: 56),
Caste(label: 'Other', value: 57),
];

Religion? religion;

List<Religion> religionList = <Religion>[
Religion(label: 'Hindu', value: 58),
Religion(label: 'Muslim', value: 59),
Religion(label: 'Sikh', value: 60),
Religion(label: 'Christian', value: 61),
Religion(label: 'Other', value: 62),

];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _professionController.text = "Salaried";

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Text('5',
                                      style: TextStyle(color: Colors.white))),
                            )),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          'Additional Details',
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

                          const Text(
                  'Gender*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Gender>(
                      dropdownColor: Colors.white,
                      value: gender,
                      hint: const Text(
                        'Select Gender',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: genderlist.map((Gender obj) {
                        return DropdownMenuItem<Gender>(
                          value: obj,
                          child: Builder(builder: (context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                obj.label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                         gender  = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                      ongenderType(newValue!);
                      },
                    ),
                  ),
                ),      

                  const SizedBox(
                    height: 10,
                  ),


                          const Text(
                  'Qualification*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Qualification>(
                      dropdownColor: Colors.white,
                      value: qualification,
                      hint: const Text(
                        'Select Qualification',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: quList.map((Qualification obj) {
                        return DropdownMenuItem<Qualification>(
                          value: obj,
                          child: Builder(builder: (context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                obj.label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                         qualification  = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onQualificationType(newValue!);
                      },
                    ),
                  ),
                ),        

                          const SizedBox(
                    height: 10,
                  ),

                          const Text(
                  'Marital Status*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<MaritalStatus>(
                      dropdownColor: Colors.white,
                      value: maritalStatus,
                      hint: const Text(
                        'Select Marital Status',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: maritalList.map((MaritalStatus obj) {
                        return DropdownMenuItem<MaritalStatus>(
                          value: obj,
                          child: Builder(builder: (context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                obj.label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                         maritalStatus  = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onMaritalType(newValue!);
                      },
                    ),
                  ),

  
                ),     

                  const SizedBox(
                    height: 10,
                  ),
                            const Text(
                  'Caste*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Caste>(
                      dropdownColor: Colors.white,
                      value: caste,
                      hint: const Text(
                        'Select Caste',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: casteList.map((Caste obj) {
                        return DropdownMenuItem<Caste>(
                          value: obj,
                          child: Builder(builder: (context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                obj.label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                         caste  = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onCasteType(newValue!);
                      },
                    ),
                  ),
                ),      

     const SizedBox(
                    height: 10,
                  ),

                  
                  const SizedBox(
                    height: 10,
                  ),
                            const Text(
                  'Religion*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Religion>(
                      dropdownColor: Colors.white,
                      value: religion,
                      hint: const Text(
                        'Select Religion',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: religionList.map((Religion obj) {
                        return DropdownMenuItem<Religion>(
                          value: obj,
                          child: Builder(builder: (context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.1)),
                              child: Text(
                                obj.label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                         religion  = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onRelogionType(newValue!);
                      },
                    ),
                  ),
                ),    



                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                  'Profession',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _professionController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
            
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      subMittedetails();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: const Center(
                          child: Text('Submit Application',
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
        )
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
  
  String convertDate(String date) {
  // Parse the input date (DD/MM/YYYY format)
  DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  DateTime parsedDate = inputFormat.parse(date);

  // Format the date as 'dd MMMM yyyy' (e.g., '10 October 2000')
  DateFormat outputFormat = DateFormat('dd MMMM yyyy');
  return outputFormat.format(parsedDate);
}

  Future<void> subMittedetails() async{

 String clentDOB = convertDate(Loandatasave.empDob);

   if(genderlable == ''){
    _showAlert('Alert', 'Please Select Gender');
    return;
   }else if(qualificationlable == ''){
      _showAlert('Alert', 'Please Select Qualification');
    return;     
   }else if(maritallable == ''){
      _showAlert('Alert', 'Please Select Marital Status');
    return;       
   }else if(castelable == ''){
       _showAlert('Alert', 'Please Select Caste');
    return;    
   }else if(religionLable == ''){
       _showAlert('Alert', 'Please Select Religion');
    return;    
   }

    const String apiurl =
        'https://bharuwa.nscspl.in/fineract-provider/api/v1/loans/newApplicationForm';


final url = Uri.parse('$apiurl');

    // Bypass SSL certificate validation
    HttpClient createHttpClient() {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bypass SSL validation
      return client;
    }

    final ioClient = IOClient(createHttpClient());

    // Create the KYC data list
    final kycDataList = [
      KycData(
        verificationTypeId: 3,
        kycTypeId: 0,
        legalFormTypeId: 1,
        validationStatusId: 0,
        entity: "client",
        locale: "en",
        documentTypeId: 1,
        isFrontSide: true,
        isBackSide: true,
        isDocumentDrivingLicence: false,
        // isOcr: false,
        documentKey: Loandatasave.empFullAdharCard,
      ),
      KycData(
        verificationTypeId: 3,
        kycTypeId: 1,
        legalFormTypeId: 1,
        validationStatusId: 0,
        entity: "client",
        locale: "en",
        documentTypeId: 2,
        isFrontSide: true,
        isBackSide: false,
        isDocumentDrivingLicence: false,
        //isOcr: false,
        documentKey: Loandatasave.empPanCard,
      ),
    ];
    ClientData clientData = ClientData(
      submittedOnDate: Loandatasave.submittedDate,
      officeId: 1,
      legalFormId: 1,
      dateOfBirth: clentDOB,
      mobileNo: Loandatasave.empMobile,
      dateFormat: "dd MMMM yyyy",
      active: true,
      familyMembers: [],
      locale: "en",
      salutation: 966, // Edit After ------------------------------------
      firstName: Loandatasave.empName,
      lastName: Loandatasave.empLastName,
      middleName: Loandatasave.empMiddleName,
      age: int.parse(Loandatasave.empAge),
      emailAddress: Loandatasave.empMail,
      fatherName: Loandatasave.empFatherName,
      motherName: Loandatasave.empMotherName,
      genderId:  452,  //genderValue, -----------------------------
      qualification: 784, //qualificationValue,   ---------------------------
      maritalStatusId: 438, //maritalValue,  ---------------------------------
      cast: 785, //casteValue, ------------------------------------------------
      religion: 968,//religionValue, -------------------------------------------
      profession: 434,//salaried,
      activationDate: Loandatasave.submittedDate,
      address: [
        Address(
          locale: "en",
          dateFormat: "dd MMM yyyy",
          country: Loandatasave.country,
          addressTypeId: Loandatasave.addresstypeValue, // edit After change 
          addressSubTypeId: Loandatasave.addSubtypeValue,
          addressLine1: Loandatasave.add1,
          addressLine2: Loandatasave.add2,
          postalCode: Loandatasave.postcode,
          district: Loandatasave.city,
          state: Loandatasave.state,
          city: Loandatasave.city,
          tehsil: Loandatasave.tehsil,
        ),
      ],
    );

    LoanData loanData = LoanData(
      productId: 2,
      repaymentEvery: 1,
      repaymentFrequencyType: 2,
      interestRatePerPeriod: 22,// change
      amortizationType: 1,
      interestCalculationPeriodType: 1,
      interestType: 0,
      isEqualAmortization: false,
      transactionProcessingStrategyId: 1,
      allowPartialPeriodInterestCalcualtion: true,
      charges: [
        Charge(
            chargeId: 1,
            name: "Processing Fee",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 2,
                code: "chargeCalculationType.percent.of.amount",
                value: "% Amount"),
            percentage: 2.36,
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 2.36,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 2.36,
            amountOrPercentage: 2.36,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
        Charge(
            chargeId: 3,
            name: "Cersai Charge",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 500,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 500,
            amountOrPercentage: 500,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 5,
                code: "chargeSlabType.principalAmount",
                value: "Principal Amount")),
        Charge(
            chargeId: 7,
            name: "Field Visit Charge",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 885,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 885,
            amountOrPercentage: 885,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
        Charge(
            chargeId: 16,
            name: "Stamp Duty On loan And Property Documents",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 500,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 500,
            amountOrPercentage: 500,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
        Charge(
            chargeId: 17,
            name: "Non-Encumbrance Certificate / Search Report",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 500,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 500,
            amountOrPercentage: 500,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
        Charge(
            chargeId: 18,
            name: "Valuation/Technical Fee",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 500,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 500,
            amountOrPercentage: 500,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid")),
        Charge(
            chargeId: 21,
            name: "Insurance charges",
            chargeTimeType: ChargeTimeType(
                id: 1,
                code: "chargeTimeType.disbursement",
                value: "Disbursement"),
            chargeCalculationType: ChargeCalculationType(
                id: 1, code: "chargeCalculationType.flat", value: "Flat"),
            currency: Currency(
                code: "INR",
                name: "Indian Rupee",
                decimalPlaces: 2,
                displaySymbol: "₹",
                nameCode: "currency.INR",
                displayLabel: "Indian Rupee (₹)"),
            amount: 500,
            amountPaid: 0,
            amountWaived: 0,
            amountWrittenOff: 0,
            amountOutstanding: 500,
            amountOrPercentage: 500,
            penalty: false,
            chargePaymentMode: ChargePaymentMode(
                id: 0, code: "chargepaymentmode.regular", value: "Regular"),
            paid: false,
            waived: false,
            chargePayable: false,
            taxInclusive: true,
            isSlabBased: false,
            slabChargeType: SlabChargeType(
                id: 0, code: "chargeSlabType.invalid", value: "Invalid"))
      ],
      checklistTemplate: [],
      loanPurposeOptions: [
        LoanPurposeOption(
            id: 26,
            name: "FOUR  WHEELER",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 24,
            name: "BUSINESS LOAN",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 34,
            name: "TWO WHEELER",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 32,
            name: "REPAY DEBTS",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 30,
            name: "PAY COST OF VEHICLE",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 27,
            name: "HEAVY COMMERCIAL VEHICLE",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 25,
            name: "CONSUMER",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 23,
            name: "AGRICULTURE",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 35,
            name: "USED CAR LOANS",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 33,
            name: "THREE WHEELER",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 31,
            name: "PURCHASE ANOTHER PROPERTY",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 29,
            name: "PAY COST OF COLLATERAL",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 28,
            name: "MARRIAGE",
            position: 0,
            description: "",
            active: true,
            mandatory: false),
        LoanPurposeOption(
            id: 286,
            name: "others",
            position: 1,
            description: "",
            active: true,
            mandatory: false)
      ],
      principalThresholdForLastInstallmentofLoan: 0,
      AddPartialPeriodInterest: "N/A",
      loanTermFrequencyType: 2,
      disbursementData: [
        DisbursementData(
            expectedDisbursementDate:Loandatasave.submittedDate , principal: Loandatasave.loanAmount)
      ],
      locale: "en",
      dateFormat: "dd MMMM yyyy",
      loanType: "individual",
      isLoanApplication: true,
      isBrokenPeriodInterestUpfront: false,
      interestUpfront: false,
      useSop: true,
      internalSalesId: 265, /// Edit // Source ID 
      channelType: 'dealer',//"selfSourced",
      source : 347, // -----------------------------------edit
      subSource : 6, // ----------------------------------edit for dealer
      principal: Loandatasave.loanAmount,
      numberOfRepayments: "21", ///------------------------------------- 
      comfortableEmi : int.parse(Loandatasave.emi),
      loanPurposeId : 427, // Loan Pupose id
      externalId : "23",//Unique id
      isSelfSourced: false, // true
      maxOutstandingLoanBalance: "50000",
      loanTermFrequency: "21", // ------------------------------------edit
      submittedOnDate: Loandatasave.submittedDate, // Submit Date

    );
    // Create the LoanApplication object
    final loanApplication = LoanApplication(
      kycData: kycDataList,
      clientData: clientData.toJson(),
      loanData: loanData.toJson(),
      identifiers: [],
      entity: "client",
      entityType: "client",
    );

    // Convert LoanApplication to JSON
    final body = loanApplication.toJson();

    final headers = {

      'Authorization': 'Basic dGVzdDoxMjM0NTY=', // Replace with correct Base64 credentials
       'Content-Type': 'application/json;charset=UTF-8',
      'Fineract-Platform-TenantId': 'default',

    };


    try {
      final response = await ioClient.post(url, headers: headers,body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data.toString().isNotEmpty) {

        int officeId = data["officeId"];
        int clientId = data['clientId'];
        int loanId = data['loanId']; 
        int resourceId = data['resourceId'];

         fetchKYCDetails(clientId);

        } else if (data.toString().isEmpty) {
          print('Response Data: $data');
         _showAlert('Alert','$data');
      return;

        }
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
              _showAlert('Alert','${response.statusCode}, ${response.body}');
      return;
      }
    } catch (e) {
      print('Exception: $e');
      _showAlert('Alert', e.toString());
      return;
    }
  }
  
  void ongenderType(Gender gender) {
 genderlable = gender.label;
  genderValue =gender.value;
  }
  
  void onQualificationType(Qualification qualification) {
     qualificationlable = qualification.label;
     qualificationValue = qualification.value;

  }
  
  void onMaritalType(MaritalStatus maritalStatus) {
    maritallable = maritalStatus.label;
    maritalValue = maritalStatus.value;

  }
  
  void onCasteType(Caste caste) {
  castelable = caste.label;
  casteValue = caste.value;
 
  }
  
  void onRelogionType(Religion religion) {
     religionLable = religion.label;
    religionValue = religion.value;
  }

  Future<void> fetchKYCDetails(int clientId) async {
  final String baseUrl = 'https://demo.kugelblitz.xyz:8443/fineract-provider/api/v1';

final url = Uri.parse('$baseUrl/kyc/kycIdentifiers/client/$clientId');

    // Bypass SSL certificate validation
    HttpClient createHttpClient() {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bypass SSL validation
      return client;
    }

    final ioClient = IOClient(createHttpClient());

    final headers = {
      'Authorization': 'Basic dGVzdDoxMjM0NTY=', // Replace with correct Base64 credentials
       'Content-Type': 'application/json;charset=UTF-8',
      'Fineract-Platform-TenantId': 'default',
    };

    try {
      final response = await ioClient.get(url, headers: headers);

      if (response.statusCode == 200) {
       
       var data = jsonDecode(response.body);

       var data1 = data[0];
       String kycId = data1['kycId'].toString();
       String clientId = data1['documentTypeId'].toString();
       String kycIdentifiersAadhar = data1['documentName'].toString();


       var data2 = data[1];
       String kycIdPan = data2['kycId'].toString();
       String clientIdPan = data2['documentTypeId'].toString();
       String kycIdentifiersPan = data2['documentName'].toString();


         HttpService.fetchApis(kycId,kycIdPan);
         
      //  String kycIdentifiers = data[0]['kycIdentifiers'];
      //  String kycId = data[0]['kycId'];

      //  String kycIdentifierPAN = data[1]['kycIdentifier'];
      //  String kycIdPAN = data[1]['kycId'];

        print(data);


      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        _showAlert("Alert", "${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error occurred: $e');
      _showAlert('Alert', '$e');
    }
  }


}

class HttpService {
  // Bypass SSL verification
  static HttpClient createHttpClient() {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bypass SSL validation
      return client;
    }

  // Perform parallel API calls
  static Future<void> fetchApis(String kycId, String kycIdPan) async {
    // Define the API URLs
    final api1 = Uri.parse('https://demo.kugelblitz.xyz:8443/fineract-provider/api/v1/client_identifiers/$kycId/documents');
    final api2 = Uri.parse('https://demo.kugelblitz.xyz:8443/fineract-provider/api/v1/client_identifiers_back/$kycId/documents');
    final api3 = Uri.parse('https://demo.kugelblitz.xyz:8443/fineract-provider/api/v1/client_identifiers/$kycIdPan/documents');

    // Custom client with bypassed SSL
  final ioClient = IOClient(createHttpClient());

    try {
      // Call APIs in parallel
      final responses = await Future.wait([
        ioClient.get(api1),
        ioClient.get(api2),
        ioClient.get(api3),
      ]);

      // Process the responses
      for (var response in responses) {
        if (response.statusCode == 200) {
          print('API ${response.request!.url} succeeded with data: ${response.body}');
        } else {
          print('API ${response.request!.url} failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      ioClient.close(); // Close the HTTP client
    }
  }
}


