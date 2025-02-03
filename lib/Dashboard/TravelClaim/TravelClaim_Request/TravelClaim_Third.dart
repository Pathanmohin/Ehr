// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Second.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Summary.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Entry.dart';
import 'package:ehr/Model/HotelMode.dart';
import 'package:ehr/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TravelClaimThird extends StatefulWidget {
  final List<Map<String, dynamic>> JourneyList;
  final List<Map<String, dynamic>> BoardgingList;

  // Constructor to receive the journeyList
  TravelClaimThird({required this.JourneyList, required this.BoardgingList});
  @override
  _TravelClaimThird createState() => _TravelClaimThird();
}

class LocalData {
  String TaxAmount;
  int Kid;
  String LocalFrom;
  String LocalTo;
  String TrvMode;
  String LocalExp;
  String LocalTotal;

  LocalData({
    required this.TaxAmount,
    required this.Kid,
    required this.LocalFrom,
    required this.LocalTo,
    required this.TrvMode,
    required this.LocalExp,
    required this.LocalTotal,
  });

  // Convert each JourneyData to JSON
  Map<String, dynamic> toJson() {
    return {
      'TaxAmount': TaxAmount,
      'Kid': Kid,
      'LocalFrom': LocalFrom,
      'LocalTo': LocalTo,
      'TrvMode': TrvMode,
      'LocalExp': LocalExp,
      'LocalTotal': LocalTotal,
    };
  }
}

class UploadFile {
  String Extension;
  String Name;
  String content;
  String Description;

  UploadFile({
    required this.Extension,
    required this.Name,
    required this.content,
    required this.Description,
  });

  // Convert each JourneyData to JSON
  Map<String, dynamic> toJson() {
    return {
      'Extension': Extension,
      'Name': Name,
      'content': content,
      'Description': Description,
    };
  }
}

class OtherData {
  String TaxAmount;
  int Kid;
  String OthFrom;
  String OthTo;
  String OthExp;
  String OthTotal;

  OtherData({
    required this.TaxAmount,
    required this.Kid,
    required this.OthFrom,
    required this.OthTo,
    required this.OthExp,
    required this.OthTotal,
  });

  // Convert each JourneyData to JSON
  Map<String, dynamic> toJson() {
    return {
      'TaxAmount': TaxAmount,
      'Kid': Kid,
      'OthFrom': OthFrom,
      'OthTo': OthTo,
      'OthExp': OthExp,
      'OthTotal': OthTotal,
    };
  }
}

class _TravelClaimThird extends State<TravelClaimThird> {
  List<Map<String, dynamic>> UploadFilee = [];
  DateTime? _selectedDate;
  DateTime startDate = DateTime(2024, 11, 1); // Example start date
  DateTime endDate = DateTime(2024, 11, 15);
  final TextEditingController estimateController = TextEditingController();
  final TextEditingController boardingController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalEstimatedController =
      TextEditingController();

  TextEditingController _LocalexpenseRemarks = TextEditingController();
  TextEditingController _localamount = TextEditingController();

  TextEditingController _OtherexpenseRemarks = TextEditingController();
  TextEditingController _Otheramount = TextEditingController();
  TextEditingController entryController = TextEditingController();
  TextEditingController labelController = TextEditingController();

  TextEditingController _GSTNUMBERLocal = TextEditingController();
  TextEditingController _VendornameLocal = TextEditingController();
  TextEditingController _BillNoLocal = TextEditingController();
  TextEditingController _ItemDetilsLocal = TextEditingController();
  TextEditingController _SACCodeLocal = TextEditingController();
  TextEditingController _QuanityLocal = TextEditingController();
  TextEditingController _RateLocal = TextEditingController();
  TextEditingController _IGSTLocal = TextEditingController();
  TextEditingController _CGSTLocal = TextEditingController();
  TextEditingController _TotaltaxAmountLocal = TextEditingController();
  TextEditingController _TotalRawAmountLocal = TextEditingController();
  TextEditingController TotalTaxAmountLocal = TextEditingController();
  TextEditingController _CESSLocal = TextEditingController();
  TextEditingController _SGSTLocal = TextEditingController();

  TextEditingController _GSTNUMBEROther = TextEditingController();
  TextEditingController _VendornameOther = TextEditingController();
  TextEditingController _BillNoOther = TextEditingController();
  TextEditingController _ItemDetilsOther = TextEditingController();
  TextEditingController _SACCodeOther = TextEditingController();
  TextEditingController _QuanityOther = TextEditingController();
  TextEditingController _RateOther = TextEditingController();
  TextEditingController _IGSTOther = TextEditingController();
  TextEditingController _CGSTOther = TextEditingController();
  TextEditingController _TotaltaxAmountOther = TextEditingController();
  TextEditingController _TotalRawAmountOther = TextEditingController();
  TextEditingController TotalTaxAmountOther = TextEditingController();
  TextEditingController _CESSOther = TextEditingController();
  TextEditingController _SGSTOther = TextEditingController();

  TextEditingController UploadPDF = TextEditingController();
  TravelType? selectedTravelType;
  //List<TravelMode> travelmodes = [];
  List<TravelType> traveltypes = [];
  List<TravelPurpose> travelpurpose = [];
  List<TravelCountry> travelcountry = [];
  List<TravelState> travelstate = [];
  List<TravelCity> travelcity = [];
  List<TravelCityClass> travelcityclass = [];
  //TravelMode? ThirdtravelMode;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TravelPurpose? selectedPurposeVisit;
  String? purposeDetails;
  String? selectedProjectType;
  String? Localconveyance;
  String? OtherExpenses;
  String? Travelmode;
  late DateTime _startDate;
  late DateTime _endDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TravelState? selectedStartState;
  TravelCountry? selectedStartCountry;
  TravelCity? selectedStartCity;
  TravelCityClass? selectedStartCityClass;
  TravelCountry? selectedEndCountry;
  TravelState? selectedEndState;
  TravelCity? selectedEndCity;
  TravelCityClass? selectedEndCityClass;
  String? selectedTravelWith;
  String? selectedEmpAccompany;
  String? selectedEmailTo;
  String? selectedGuestHouse;
  String? boardingdetail;

  String? LocalTravelMode;

  bool? travelTicket = false;
  bool? hotel = false;
  bool? cabTaxi = false;
  bool local = false;
  bool Expenses = false;
  double? estimatedFare;
  double? estimatedBoardingLodging;
  double? otherExpense;
  double? totalEstimatedCost;
  double? advanceAmount;
  String? advanceDetails;
  String? currentWork;
  String? documentDescription;
  String? uploadedDocumentName;
  String? uploadedExcelName;
  var ThirdtravelMode;
  String LabelTextFieldTravelMode = "";

  DateTime? LocalConvencyStartDate;
  DateTime? LocalConvencyEndDate;
  DateTime? LocalConvencyTaxDate;
  DateTime? OtherStartDate;
  DateTime? OtherEndDate;
  DateTime? OthertaxDate;
  String _dateRange = "";
  String? _LocalConvencyEndDate;
  String? __TaxLocaldate;
  String? _TaxOtherDate;

  bool localconvency = false;
  bool otherexpence = false;
  String? _LocalConvencyStartDate;
  String? _OtherEndDate;
  String? _OtherStartDate;
  String? _LocaltaxDate;
  String? _OtherTaxAmount;
  String? _Localtaxclaimant;
  String? _OtherTaxClaimant;
  String? LocalClaim;
  String? Othercliam;

  final List<travelmodes> fromAccountList = <travelmodes>[];
  final _gstRegExp =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

  List<Map<String, dynamic>> LocalList = [];
  List<Map<String, dynamic>> OtherList = [];

  @override
  void initState() {
    super.initState();
    dataFound();
    _TravelMode();

    _ItemDetilsLocal.text = "0";
    _SACCodeLocal.text = "0";
    _QuanityLocal.text = "0";
    _RateLocal.text = "0";
    _SGSTLocal.text = "0";
    _CGSTLocal.text = "0";
    _CESSLocal.text = "0";
    _IGSTLocal.text = "0";
    _BillNoLocal.text = "0";
    _TotaltaxAmountLocal.text = "0";
    _VendornameLocal.text = "null";
    _GSTNUMBERLocal.text = "0";
    _ItemDetilsOther.text = "0";
    _SACCodeOther.text = "0";
    _QuanityOther.text = "0";
    _RateOther.text = "0";
    _SGSTOther.text = "0";
    _CGSTOther.text = "0";
    _CESSOther.text = "0";
    _TotaltaxAmountOther.text = "0";
    _VendornameOther.text = "null";
    _GSTNUMBEROther.text = "0";
    _IGSTOther.text = "0";
    _BillNoOther.text = "0";
  }

  void LocaladdData() {
    if (LocalConvencyStartDate.toString() == "null") {
      Alert_DialogBox.showAlert(
          context, "Please Select Requst Duration Form Date");
      return;
    } else if (LocalConvencyEndDate.toString() == "null") {
      Alert_DialogBox.showAlert(
          context, "Please Select Requst Duration Form Date");
      return;
    } else if (LocalTravelMode == null || LocalTravelMode == "") {
      Alert_DialogBox.showAlert(context, "Please Select Travel Mode");
      return;
    } else if (_LocalexpenseRemarks.text == null ||
        _LocalexpenseRemarks.text == "") {
      Alert_DialogBox.showAlert(context, "Please Enter Local Expense Remarks");
      return;
    } else if (_localamount.text == null || _localamount.text == "") {
      Alert_DialogBox.showAlert(
          context, "Please Enter Local Amount Without Tax");
      return;
    } else if (_Localtaxclaimant == null) {
      LocalClaim = "Self";
    } else {
      LocalClaim = LocalClaim.toString();
    }

    String? formattedDatee;
    if (_LocaltaxDate.toString() == "null") {
      DateTime now = DateTime.now();

      // Format the date if needed
      formattedDatee = DateFormat('dd/MM/yyyy').format(now);
    }
    if (_GSTNUMBEROther.text != "0") {
      if (!_gstRegExp.hasMatch(_GSTNUMBEROther.text.trim())) {
        Alert_DialogBox.showAlert(context,
            "Invalid GST number format. Please enter a valid GST number");
        return;
      }
      // String ddd = _GSTNUMBERJourney.text.toString();
    }

    // Format the date if needed

    String TaxDataa = _Localtaxclaimant.toString() +
        "~" +
        _GSTNUMBERLocal.text.toString() +
        "~" +
        _VendornameLocal.text.toString() +
        "~" +
        _BillNoLocal.text.toString() +
        "~" +
        formattedDatee.toString() +
        "~" +
        _ItemDetilsLocal.text.toString() +
        "~" +
        _SACCodeLocal.text.toString() +
        "~" +
        _QuanityLocal.text.toString() +
        "~" +
        _RateLocal.text.toString() +
        "~" +
        _IGSTLocal.text.toString() +
        "~" +
        _SGSTLocal.text.toString() +
        "~" +
        _CGSTLocal.text.toString() +
        "~" +
        _CESSLocal.text.toString() +
        "~" +
        _TotaltaxAmountLocal.text.toString() +
        "~" +
        _TotalRawAmountLocal.text.toString();
    LocalData newJourney = LocalData(
      TaxAmount: TaxDataa,
      Kid: 0, // Assuming this is always 0, modify as necessary
      LocalFrom: _LocalConvencyStartDate.toString(),
      LocalTo: _LocalConvencyEndDate.toString(), //done
      TrvMode: LocalTravelMode.toString(), //done
      LocalExp: _LocalexpenseRemarks.text.toString(), //done
      LocalTotal: _localamount.text.toString(), //done

      //done
    );

    // Add JourneyData wrapped in Table1 to the journey list
    setState(() {
      LocalList.add({
        'Table1': newJourney.toJson(),
      });

      // Clear text fields after adding the data
      _LocalexpenseRemarks.clear();
      _localamount.clear();
      localconvency = false;
    });
  }

  void OtheraddData() {
    if (_OtherexpenseRemarks.text == null || _OtherexpenseRemarks.text == "") {
      Alert_DialogBox.showAlert(context, "Please Enter Other Expense Remarks");
      return;
    } else if (_Otheramount.text == null || _Otheramount.text == "") {
      Alert_DialogBox.showAlert(
          context, "Please Enter Other Amount Without Tax");
      return;
    }

    if (_OtherTaxClaimant == null) {
      Othercliam = "Self";
    } else {
      Othercliam = _OtherTaxClaimant.toString();
    }
    String? formattedDate;

    if (_TaxOtherDate.toString() == "null") {
      DateTime now = DateTime.now();

      // Format the date if needed
      formattedDate = DateFormat('dd/MM/yyyy').format(now);
    }
    if (_GSTNUMBEROther.text != "0") {
      if (!_gstRegExp.hasMatch(_GSTNUMBEROther.text.trim())) {
        Alert_DialogBox.showAlert(context,
            "Invalid GST number format. Please enter a valid GST number");
        return;
      }
      // String ddd = _GSTNUMBERJourney.text.toString();
    }

    String TaxData = Othercliam.toString() +
        "~" +
        _GSTNUMBEROther.text.toString() +
        "~" +
        _VendornameOther.text.toString() +
        "~" +
        _BillNoOther.text.toString() +
        "~" +
        formattedDate.toString() +
        "~" +
        _ItemDetilsOther.text.toString() +
        "~" +
        _SACCodeOther.text.toString() +
        "~" +
        _QuanityOther.text.toString() +
        "~" +
        _RateOther.text.toString() +
        "~" +
        _IGSTOther.text.toString() +
        "~" +
        _SGSTOther.text.toString() +
        "~" +
        _CGSTOther.text.toString() +
        "~" +
        _CESSOther.text.toString() +
        "~" +
        _TotaltaxAmountOther.text.toString() +
        "~" +
        _TotalRawAmountOther.text.toString();
    OtherData newJourney = OtherData(
      TaxAmount: TaxData,
      Kid: 0, // Assuming this is always 0, modify as necessary
      OthFrom: _OtherStartDate.toString(),
      OthTo: _OtherEndDate.toString(), //done
      OthExp: _OtherexpenseRemarks.text.toString(), //done
      OthTotal: _Otheramount.text.toString(), //done

      //done
    );

    // Add JourneyData wrapped in Table1 to the journey list
    setState(() {
      OtherList.add({
        'Table1': newJourney.toJson(),
      });

      // Clear text fields after adding the data
      _OtherexpenseRemarks.clear();
      _Otheramount.clear();
      otherexpence = false;
    });
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dateRange = prefs.getString("_dateRange") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Travel Claim Request",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TravelClaimSecond()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdownField<String>(
                  labelText: "Local Conveyance Required*",
                  items: ["Yes", "No"],
                  selectedItem: Localconveyance,
                  onChanged: (value) {
                    setState(() {
                      Localconveyance = value;
                      local = (Localconveyance == "Yes");
                      // if (Localconveyance == "No") {
                      //   local = false;
                      // } else if (Localconveyance == "Yes") {
                      //   local == true;
                      // }
                    });
                  },
                  displayText: (Vehicle) => Vehicle),
              Visibility(
                  visible: local, child: buildSectionLabel("Request Duration")),
              Visibility(visible: local, child: LocalDate("From Date")),
              Visibility(
                visible: local,
                child: const SizedBox(
                  height: 10,
                ),
              ),

              Visibility(
                visible: local,
                child: buildDropdownField<travelmodes>(
                  labelText: "Travel Mode",
                  items: fromAccountList,
                  selectedItem: ThirdtravelMode,
                  onChanged: (value) {
                    setState(() {
                      ThirdtravelMode = value;
                    });

                    LocalTravelMode = value!.kid.toString();
                  },
                  displayText: (ThirdtravelMode) => ThirdtravelMode.text
                      .toString(), // Display only the text field
                ),
              ),
              Visibility(
                visible: local,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: local,
                child: buildTextFieldalphbate(
                  "Expense Remarks",
                  (value) {
                    setState(() {
                      purposeDetails = value;
                    });
                  },
                  controller: _LocalexpenseRemarks,
                ),
              ),

              Visibility(
                visible: local,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: local,
                child: buildTextFieldnumeric("Amount Without Tax", (value) {
                  setState(() {
                    //
                    //   purposeDetails = value;
                  });
                }, controller: _localamount),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: local,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (LocalConvencyStartDate.toString() == "null") {
                          Alert_DialogBox.showAlert(context,
                              "Please Select Requst Duration Form Date");
                          return;
                        } else if (LocalConvencyEndDate.toString() == "null") {
                          Alert_DialogBox.showAlert(context,
                              "Please Select Requst Duration Form Date");
                          return;
                        } else if (LocalTravelMode == null ||
                            LocalTravelMode == "") {
                          Alert_DialogBox.showAlert(
                              context, "Please Select Travel Mode");
                          return;
                        } else if (_LocalexpenseRemarks.text == null ||
                            _LocalexpenseRemarks.text == "") {
                          Alert_DialogBox.showAlert(
                              context, "Please Enter Local Expense Remarks");
                          return;
                        } else if (_localamount.text == null ||
                            _localamount.text == "") {
                          Alert_DialogBox.showAlert(
                              context, "Please Enter Local Amount Without Tax");
                          return;
                        } else if (_Localtaxclaimant == null) {
                          LocalClaim = "Self";
                        } else {
                          LocalClaim = LocalClaim.toString();
                        }
                        setState(() {
                          localconvency = true;
                        });

                        _TotalRawAmountLocal.text = _localamount.text;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Customize color
                      ),
                      child: const Text(
                        'Tax', // Button label
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: localconvency,
                child: buildDropdownField<String>(
                    labelText: "Claimant",
                    items: ["Self", "Agent", "Office"],
                    selectedItem: boardingdetail,
                    onChanged: (value) {
                      setState(() {
                        _Localtaxclaimant = value;
                      });
                    },
                    displayText: (Vehicle) => Vehicle),
              ),
              Visibility(
                visible: localconvency,
                child: buildTextFieldddd("GST Number", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    keyboardType: TextInputType.text,
                    controller: _GSTNUMBERLocal),
              ),
              Visibility(
                visible: localconvency,
                child: TaxLocalDate("Bill Date", "Vendor Name",
                    controller: _VendornameLocal),
              ),
              Visibility(
                visible: localconvency,
                child: TaxFieldd(
                  entryName: "Bill No",
                  labelName: "Item Details",
                  entryController: _BillNoLocal,
                  labelController: _ItemDetilsLocal,
                ),
              ),
              Visibility(
                visible: localconvency,
                child: TaxFieldd(
                  entryName: "SAC Code",
                  labelName: "Quantity",
                  entryController: _SACCodeLocal,
                  labelController: _QuanityLocal,
                ),
              ),
              Visibility(
                visible: localconvency,
                child: TaxFieldd(
                  entryName: "Rate",
                  labelName: "IGST",
                  entryController: _RateLocal,
                  labelController: _IGSTLocal,
                ),
              ),
              Visibility(
                visible: localconvency,
                child: TaxFieldd(
                  entryName: "SGST",
                  labelName: "CGST",
                  entryController: _SGSTLocal,
                  labelController: _CGSTLocal,
                ),
              ),
              Visibility(
                visible: localconvency,
                child: TaxFieldd(
                  entryName: "CESS",
                  labelName: "Total Tax Amount",
                  entryController: _CESSLocal,
                  labelController: _TotaltaxAmountLocal,
                ),
              ),

              Visibility(
                visible: localconvency,
                child: buildTextField(
                  "Total Row Amount",
                  (value) {
                    setState(
                      () {
                        purposeDetails = value;
                      },
                    );
                  },
                  controller: _TotalRawAmountLocal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: local,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        onPressed:
                        LocaladdData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Customize color
                      ),
                      child: const Text(
                        'ADD', // Button label
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: local,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              buildDropdownField<String>(
                  labelText: "Other Expenses Require*",
                  items: ["Yes", "No"],
                  selectedItem: OtherExpenses,
                  onChanged: (value) {
                    setState(() {
                      OtherExpenses = value;

                      Expenses = (OtherExpenses == "Yes");
                    });
                  },
                  displayText: (Vehicle) => Vehicle),
              Visibility(
                visible: Expenses,
                child: const SizedBox(
                  height: 10,
                ),
              ),

              Visibility(
                visible: Expenses,
                child: buildSectionLabel("Request Duration"),
              ),
              Visibility(
                visible: Expenses,
                child: OtherExpensedate("From Date"),
              ),
              Visibility(
                visible: Expenses,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: Expenses,
                child: buildTextFieldalphbate(
                  "Expense Remarks",
                  (value) {
                    setState(() {
                      purposeDetails = value;
                    });
                  },
                  controller: _OtherexpenseRemarks,
                ),
              ),

              Visibility(
                visible: Expenses,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: Expenses,
                child: buildTextFieldnumeric("Amount Without Tax", (value) {
                  setState(() {
                    // purposeDetails = value;
                  });
                }, controller: _Otheramount),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: Expenses,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (OtherStartDate == "null") {
                          Alert_DialogBox.showAlert(
                              context, "Please Select Start Date");
                          return;
                        } else if (OtherEndDate == "null") {
                          Alert_DialogBox.showAlert(
                              context, "Please Select End Date");
                          return;
                        } else if (_OtherexpenseRemarks.text == null ||
                            _OtherexpenseRemarks.text == "") {
                          Alert_DialogBox.showAlert(
                              context, "Please Enter Other Expense Remarks");
                          return;
                        } else if (_Otheramount.text == null ||
                            _Otheramount.text == "") {
                          Alert_DialogBox.showAlert(
                              context, "Please Enter Other Amount Without Tax");
                          return;
                        }

                        setState(() {
                          otherexpence = true;
                          _TotalRawAmountOther.text =
                              _Otheramount.text.toString();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Customize color
                      ),
                      child: const Text(
                        'Tax', // Button label
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: otherexpence,
                child: buildDropdownField<String>(
                    labelText: "Claimant",
                    items: ["Self", "Agent", "Office"],
                    selectedItem: boardingdetail,
                    onChanged: (value) {
                      setState(() {
                        _OtherTaxClaimant = value;
                      });
                    },
                    displayText: (Vehicle) => Vehicle),
              ),
              Visibility(
                visible: otherexpence,
                child: buildTextFieldddd("GST Number", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    keyboardType: TextInputType.text,
                    controller: _GSTNUMBEROther),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxOtherExpensedate("Bill Date", "Vendor Name",
                    controller: _VendornameOther),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxFieldd(
                  entryName: "Bill No",
                  labelName: "Item Details",
                  entryController: _BillNoOther,
                  labelController: _ItemDetilsOther,
                ),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxFieldd(
                  entryName: "SAC Code",
                  labelName: "Quantity",
                  entryController: _SACCodeOther,
                  labelController: _QuanityOther,
                ),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxFieldd(
                  entryName: "Rate",
                  labelName: "IGST",
                  entryController: _RateOther,
                  labelController: _IGSTOther,
                ),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxFieldd(
                  entryName: "SGST",
                  labelName: "CGST",
                  entryController: _SGSTOther,
                  labelController: _CGSTOther,
                ),
              ),
              Visibility(
                visible: otherexpence,
                child: TaxFieldd(
                  entryName: "CESS",
                  labelName: "Total Tax Amount",
                  entryController: _CESSOther,
                  labelController: _TotaltaxAmountOther,
                ),
              ),

              Visibility(
                visible: otherexpence,
                child: buildTextField(
                  "Total Row Amount",
                  (value) {
                    setState(
                      () {
                        purposeDetails = value;
                      },
                    );
                  },
                  controller: _TotalRawAmountOther,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Visibility(
                visible: Expenses,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        onPressed:
                        OtheraddData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Customize color
                      ),
                      child: const Text(
                        'ADD', // Button label
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: Expenses,
                child: const SizedBox(
                  height: 10,
                ),
              ),

              buildDocumentUploadSection("Attached Document",
                  "Document Description", "Upload", "Doc_upload_button"),
              // buildDocumentUploadSection(
              //     "Excel Upload", "File Upload", "Choose File", "Uploadexcel"),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   height: 300,
              //   child: ListView.builder(
              //     itemCount: UploadFilee.length,
              //     itemBuilder: (context, index) {
              //       // Assuming 'fileName' is the key for the value you want to display
              //       String displayText =
              //           UploadFilee[index]['Extension'] ?? 'No File Name';
              //       return ListTile(
              //         title: Text(displayText),
              //       );
              //     },
              //   ),
              // ),

              //  SizedBox(
              //     height: 300,
              //     child: ListView.builder(
              //       itemCount: UploadFilee.length,
              //       itemBuilder: (context, index) {
              //         final itemm = UploadFilee[index];
              //         return Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             TaxDateBoardging("Departure Date", itemm.depDate,
              //                 "Departure Time", itemm.depTime),
              //             TaxDateBoardging("Departure Start Point",
              //                 itemm.depPlace, "Arrival Date", itemm.arrDate),
              //             TaxDateBoardging("Arrival Time", itemm.arrTime,
              //                 "Arrival End Point", itemm.arrPlace),
              //             TaxDateBoardging("Travel Mode", itemm.trvMode,
              //                 "Basic Fare", itemm.farePaid.toString()),
              //             TaxDateBoardging("Distance", itemm.distance.toString(),
              //                 "Purpose Visit", itemm.purVisit),
              //           ],
              //         );
              //       },
              //     ),
              //   ),
              InkWell(
                onTap: () async {
                  double totalFare = 0;
                  double Boardging = 0;
                  double Local = 0;
                  double Other = 0;
                  final prefs = await SharedPreferences.getInstance();

                  if (Localconveyance == null || Localconveyance == "") {
                    Alert_DialogBox.showAlert(
                        context, "Please Select Local Conveyance Required");
                    return;
                  }
                  if (Localconveyance == "Yes") {
                    if (LocalTravelMode == null || LocalTravelMode == "") {
                      Alert_DialogBox.showAlert(
                          context, "Please Select Travel Mode");
                      return;
                    } else if (_LocalexpenseRemarks.text == null ||
                        _LocalexpenseRemarks.text == "") {
                      Alert_DialogBox.showAlert(
                          context, "Please Enter Local Expense Remarks");
                      return;
                    } else if (_localamount.text == null ||
                        _localamount.text == "") {
                      Alert_DialogBox.showAlert(
                          context, "Please Enter Local Amount Without Tax");
                      return;
                    }
                  }
                  if (OtherExpenses == null || OtherExpenses == "") {
                    Alert_DialogBox.showAlert(
                        context, "Please Select Other Expenses Require");
                    return;
                  }
                  if (OtherExpenses == "Yes") {
                    if (_OtherexpenseRemarks.text == null ||
                        _OtherexpenseRemarks.text == "") {
                      Alert_DialogBox.showAlert(
                          context, "Please Enter Other Expense Remarks");
                      return;
                    } else if (_Otheramount.text == null ||
                        _Otheramount.text == "") {
                      Alert_DialogBox.showAlert(
                          context, "Please Enter Other Amount Without Tax");
                      return;
                    }
                  }
                  if (LocalList.isEmpty) {
                    LocaladdData();
                  }
                  if (OtherList.isEmpty) {
                    OtheraddData();
                  }

                  for (var item in widget.JourneyList) {
                    var table1 = item["Table1"];
                    if (table1 != null && table1["JourFare"] != null) {
                      // Convert the JourFare string to a number and add it to the totalFare
                      totalFare +=
                          double.tryParse(table1["JourFare"].toString()) ?? 0;
                    }
                  }
                  for (var item in widget.BoardgingList) {
                    var table1 = item["Table1"];
                    if (table1 != null && table1["BoardtotAmt"] != null) {
                      // Convert the JourFare string to a number and add it to the totalFare
                      Boardging +=
                          double.tryParse(table1["BoardtotAmt"].toString()) ??
                              0;
                    }
                  }
                  for (var item in LocalList) {
                    var table1 = item["Table1"];
                    if (table1 != null && table1["LocalTotal"] != null) {
                      // Convert the JourFare string to a number and add it to the totalFare
                      Local +=
                          double.tryParse(table1["LocalTotal"].toString()) ?? 0;
                    }
                  }
                  for (var item in OtherList) {
                    var table1 = item["Table1"];
                    if (table1 != null && table1["OthTotal"] != null) {
                      // Convert the JourFare string to a number and add it to the totalFare
                      Other +=
                          double.tryParse(table1["OthTotal"].toString()) ?? 0;
                    }
                  }

                  List<String> _LocalConvencyStartDate =
                      LocalConvencyStartDate.toString().split(" ");
                  List<String> _LocalConvencyEndDate =
                      LocalConvencyEndDate.toString().split(" ");
                  List<String> _OtherStartDate =
                      OtherStartDate.toString().split(" ");
                  List<String> _OtherEndDate =
                      OtherEndDate.toString().split(" ");
                  List<String> _LocalConvencyTaxDate =
                      LocalConvencyTaxDate.toString().split(" ");
                  List<String> _OthertaxDate =
                      OthertaxDate.toString().split(" ");

                  prefs.setString(
                      "_LocalexpenseRemarks", _LocalexpenseRemarks.text);
                  prefs.setString("_localamount", _localamount.text);
                  prefs.setString(
                      "_OtherexpenseRemarks", _OtherexpenseRemarks.text);
                  prefs.setString("_Otheramount", _Otheramount.text);
                  prefs.setString(
                      "LocalTravelMode", LocalTravelMode.toString());

                  prefs.setString(
                      "_LocalConvencyStartDate", _LocalConvencyStartDate[0]);
                  prefs.setString(
                      "_LocalConvencyEndDate", _LocalConvencyEndDate[0]);
                  prefs.setString("_OtherStartDate", _OtherStartDate[0]);
                  prefs.setString("_OtherEndDate", _OtherEndDate[0]);
                  prefs.setString(
                      "_LocalConvencyTaxDate", _LocalConvencyTaxDate[0]);
                  prefs.setString("_OthertaxDate", _OthertaxDate[0]);

                  prefs.setString("JourneyTotalTax", totalFare.toString());
                  prefs.setString("_BoardgingTotaltax", Boardging.toString());
                  prefs.setString("_LocalTotalTax", Local.toString());
                  prefs.setString("_OtherTotalTax", Other.toString());

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TravelClaimSummary(
                              otherlist: OtherList,
                              locallist: LocalList,
                              journeylist: widget.JourneyList,
                              boardginglist: widget.BoardgingList,
                              UploadDataFile: UploadFilee)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
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

              // ElevatedButton(
              //   onPressed: downloadFile,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //   ),
              //   child: Text('Download File'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void downloadFile() async {
    downloadFilee();
    //   // if (fileBytes == null) return;
    //   // final directory = await Directory('/Documents').create();
    //   // final file = File('${directory.path}/$fileName');
    //   // await file.writeAsBytes(fileBytes!);
    //   // print('File saved to ${file.path}');
    //   // You can also provide a dialog or some UI to notify the user the file is downloaded.

    //   //final directory = await getApplicationDocumentsDirectory();
    //   // final directory = Directory('/storage/emulated/0/Download');
    //   // final path = "${directory.path}/$fileName";

    //   // // Write the file bytes to the path
    //   // final file = File(path);
    //   // await file.writeAsBytes(fileBytes!);

    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(content: Text("File downloaded to: $path")),
    //   // );

    //   if (await Permission.manageExternalStorage.request().isGranted ||
    //       await Permission.storage.request().isGranted) {
    //     try {
    //       // Define the path to the Downloads folder
    //       final directory = Directory('/storage/emulated/0/Download');
    //       final path = "${directory.path}/$fileName";

    //       // Write the file to the Downloads folder
    //       final file = File(path);
    //       await file.writeAsBytes(fileBytes!);

    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text("File downloaded to: $path")),
    //       );
    //     } catch (e) {
    //       print("Error downloading file: $e");
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text("Failed to download file")),
    //       );
    //     }
    //   }
  }

  Future<bool> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<void> downloadFilee() async {
    if (fileBytes == null || fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected to download")),
      );
      return;
    }

    // Request permission to access external storage
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied to save file")),
      );
      return;
    }

    try {
      // Get the correct path to Downloads directory for Android 10 and above
      // final directory = await getExternalStorageDirectory();
      // if (directory == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Unable to get external storage directory")),
      //   );
      //   return;
      // }

      final directory = Directory('/storage/emulated/0/Download');
      final path = "${directory.path}/$fileName";
      //final path = "${directory.path}/$fileName";
      final file = File(path);

      // Write the bytes to the file
      await file.writeAsBytes(fileBytes!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to: $path")),
      );
    } catch (e) {
      print("Error downloading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to download file")),
      );
    }
  }

  void calculateTotalEstimatedCost() {
    setState(() {
      totalEstimatedCost = (estimatedFare ?? 0) +
          (estimatedBoardingLodging ?? 0) +
          (otherExpense ?? 0);
      totalEstimatedController.text =
          totalEstimatedCost!.toStringAsFixed(2); // Update the controller
    });
  }

  Widget TaxOtherExpensedate(
    String Name,
    String Title, {
    required TextEditingController controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8),
              ),
            ),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    OthertaxDate = pickedDate;
                  });
                  List<String> splitDate = OthertaxDate.toString().split(" ");

                  _TaxOtherDate = splitDate[0];
                }
              },
              child: Container(
                width: 150,
                // Matching width for date picker container
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  OthertaxDate != null
                      ? DateFormat('yyyy-MM-dd').format(OthertaxDate!)
                      : 'Select Date',
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8),
              ),
            ),
            Container(
              width: 150,
              height: 45, // Matching width for TextFormField container
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Vendor Name",
                  border: InputBorder.none, // Remove the inner border
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget TaxLocalDate(
    String Name,
    String Title, {
    required TextEditingController controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8),
              ),
            ),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    LocalConvencyTaxDate = pickedDate;
                  });
                  List<String> splitDate =
                      LocalConvencyTaxDate.toString().split(" ");

                  __TaxLocaldate = splitDate[0];
                }
              },
              child: Container(
                width: 150,
                // Matching width for date picker container
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  LocalConvencyTaxDate != null
                      ? DateFormat('dd-MM-yyyy').format(LocalConvencyTaxDate!)
                      : 'Select Date',
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "TimesNewRoman",
                color: Color(0xFF547EC8),
              ),
            ),
            Container(
              width: 150,
              height: 45, // Matching width for TextFormField container
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Vendor Name",
                  border: InputBorder.none, // Remove the inner border
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDropdownField<T>({
    required String labelText,
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onChanged,
    required String Function(T)
        displayText, // Function to display text for each item
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        DropdownButton<T>(
          isExpanded: true,
          value: selectedItem,
          hint: const Text("Select",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "TimesNewRoman",
                  color: Colors.black)),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayText(item),
                  style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "TimesNewRoman",
                      color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildTextFieldnumeric(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = true,
    String? initialValue,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
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
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldalphbate(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = true,
    String? initialValue,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
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
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: controller,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
            // onChanged: onChanged,
            // controller: TextEditingController(text: initialValue),
          ),
        ),
      ],
    );
  }

  Widget buildNumericField(
    String labelText,
    TextEditingController controller,
    Function(String) onChanged, {
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        TextField(
          controller: controller,
          enabled: isEnabled,
          decoration: const InputDecoration(
            hintText: "",
            hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black),
          maxLength: 100,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          // controller: TextEditingController(text: initialValue),
        ),
      ],
    );
  }

  Widget LocalDate(String Name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Name,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            InkWell(
              onTap: () async {
                String dateRange = _dateRange.toString();

                List<String> splitByTo = dateRange.split(" To ");

                List<String> fromDateParts = splitByTo[0].split("/");
                List<String> toDateParts = splitByTo[1].split("/");

                String year = fromDateParts[2].toString();
                String month = fromDateParts[1].toString();
                String day = fromDateParts[0].toString();

                String ADD = year + "-" + month + "-" + day.toString();
                String yearr = toDateParts[2].toString();

                String monthh = toDateParts[1].toString();
                String dayy = toDateParts[0].toString();

                String AAAAA = yearr + "-" + monthh + "-" + dayy.toString();

                _startDate = DateTime.parse(ADD); // Format: yyyy-MM-dd
                _endDate = DateTime.parse(AAAAA);

                DateTime initialDate = _focusedDay.isBefore(_startDate)
                    ? _startDate
                    : (_focusedDay.isAfter(_endDate) ? _endDate : _focusedDay);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: _startDate,
                  lastDate: _endDate,
                );
                if (pickedDate != null) {
                  setState(() {
                    LocalConvencyStartDate = pickedDate;
                  });

                  // String Dat = DepartureDate.toString();

                  List<String> splitDte =
                      LocalConvencyStartDate.toString().split(" ");

                  _LocalConvencyStartDate = splitDte[0];
                }
              },
              child: Container(
                width: 150,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  LocalConvencyStartDate != null
                      ? DateFormat('yyyy-MM-dd').format(LocalConvencyStartDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "TimesNewRoman",
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "To Date",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            InkWell(
              onTap: () async {
                String dateRange = _dateRange.toString();

                List<String> splitByTo = dateRange.split(" To ");

                List<String> fromDateParts = splitByTo[0].split("/");
                List<String> toDateParts = splitByTo[1].split("/");

                String year = fromDateParts[2].toString();
                String month = fromDateParts[1].toString();
                String day = fromDateParts[0].toString();

                String ADD = year + "-" + month + "-" + day.toString();
                String yearr = toDateParts[2].toString();

                String monthh = toDateParts[1].toString();
                String dayy = toDateParts[0].toString();

                String AAAAA = yearr + "-" + monthh + "-" + dayy.toString();

                _startDate = DateTime.parse(ADD); // Format: yyyy-MM-dd
                _endDate = DateTime.parse(AAAAA);

                DateTime initialDate = _focusedDay.isBefore(_startDate)
                    ? _startDate
                    : (_focusedDay.isAfter(_endDate) ? _endDate : _focusedDay);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: _startDate,
                  lastDate: _endDate,
                );
                if (pickedDate != null) {
                  setState(() {
                    LocalConvencyEndDate = pickedDate;
                  });

                  List<String> splitDte =
                      LocalConvencyEndDate.toString().split(" ");

                  _LocalConvencyEndDate = splitDte[0];
                }
              },
              child: Container(
                width: 150,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  LocalConvencyEndDate != null
                      ? DateFormat('yyyy-MM-dd').format(LocalConvencyEndDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "TimesNewRoman"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget OtherExpensedate(String Name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Name,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            InkWell(
              onTap: () async {
                String dateRange = _dateRange.toString();

                List<String> splitByTo = dateRange.split(" To ");

                List<String> fromDateParts = splitByTo[0].split("/");
                List<String> toDateParts = splitByTo[1].split("/");

                String year = fromDateParts[2].toString();
                String month = fromDateParts[1].toString();
                String day = fromDateParts[0].toString();

                String ADD = year + "-" + month + "-" + day.toString();
                String yearr = toDateParts[2].toString();

                String monthh = toDateParts[1].toString();
                String dayy = toDateParts[0].toString();

                String AAAAA = yearr + "-" + monthh + "-" + dayy.toString();

                _startDate = DateTime.parse(ADD); // Format: yyyy-MM-dd
                _endDate = DateTime.parse(AAAAA);

                DateTime initialDate = _focusedDay.isBefore(_startDate)
                    ? _startDate
                    : (_focusedDay.isAfter(_endDate) ? _endDate : _focusedDay);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: _startDate,
                  lastDate: _endDate,
                );
                if (pickedDate != null) {
                  setState(() {
                    OtherStartDate = pickedDate;
                  });

                  List<String> splitDte = OtherStartDate.toString().split(" ");

                  _OtherStartDate = splitDte[0];
                }
              },
              child: Container(
                width: 150,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  OtherStartDate != null
                      ? DateFormat('yyyy-MM-dd').format(OtherStartDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "TimesNewRoman",
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "To Date",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            InkWell(
              onTap: () async {
                String dateRange = _dateRange.toString();

                List<String> splitByTo = dateRange.split(" To ");

                List<String> fromDateParts = splitByTo[0].split("/");
                List<String> toDateParts = splitByTo[1].split("/");

                String year = fromDateParts[2].toString();
                String month = fromDateParts[1].toString();
                String day = fromDateParts[0].toString();

                String ADD = year + "-" + month + "-" + day.toString();
                String yearr = toDateParts[2].toString();

                String monthh = toDateParts[1].toString();
                String dayy = toDateParts[0].toString();

                String AAAAA = yearr + "-" + monthh + "-" + dayy.toString();

                _startDate = DateTime.parse(ADD); // Format: yyyy-MM-dd
                _endDate = DateTime.parse(AAAAA);

                DateTime initialDate = _focusedDay.isBefore(_startDate)
                    ? _startDate
                    : (_focusedDay.isAfter(_endDate) ? _endDate : _focusedDay);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: _startDate,
                  lastDate: _endDate,
                );
                if (pickedDate != null) {
                  setState(() {
                    OtherEndDate = pickedDate;
                  });
                  List<String> splitDte = OtherEndDate.toString().split(" ");

                  _OtherEndDate = splitDte[0];
                }
              },
              child: Container(
                width: 150,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  OtherEndDate != null
                      ? DateFormat('yyyy-MM-dd').format(OtherEndDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "TimesNewRoman"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCityAndClassFields(
      String cityLabel, String cityClassLabel, bool isStart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildDropdownField<TravelCity>(
            labelText: cityLabel,
            items: travelcity,
            selectedItem: isStart ? selectedStartCity : selectedEndCity,
            onChanged: (value) {
              setState(() {
                if (isStart) {
                  selectedStartCity = value;
                } else {
                  selectedEndCity = value;
                }
              });
            },
            displayText: (city) => city.text,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: buildDropdownField<TravelCityClass>(
              labelText: cityClassLabel,
              items: travelcityclass,
              selectedItem:
                  isStart ? selectedStartCityClass : selectedEndCityClass,
              onChanged: (value) {
                setState(() {
                  if (isStart) {
                    selectedStartCityClass = value;
                  } else {
                    selectedEndCityClass = value;
                  }
                });
              },
              displayText: (cityClass) => cityClass.text),
        ),
      ],
    );
  }

  Widget buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "TimesNewRoman",
            color: Color(0xFF547EC8)),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
    String? initialValue,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
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
          child: TextFormField(
            controller: controller,
            enabled: isEnabled,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldddd(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = true,
    String? initialValue,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
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
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
          ),
        ),
      ],
    );
  }

  Widget DescibtionEntry(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
    String? initialValue,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
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
          child: TextFormField(
            controller: controller,
            enabled: true,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCheckBoxFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Request for Ticket/Hotel/Taxi Booking",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text("Travel Ticket",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black)),
                value: travelTicket,
                onChanged: (bool? value) {
                  setState(() {
                    travelTicket = value;
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Hotel",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black)),
                value: hotel,
                onChanged: (bool? value) {
                  setState(() {
                    hotel = value;
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Cab/Taxi",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "TimesNewRoman",
                        color: Colors.black)),
                value: cabTaxi,
                onChanged: (bool? value) {
                  setState(() {
                    cabTaxi = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDocumentUploadSection(String label, String descriptionLabel,
      String buttonText, String buttonId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        DescibtionEntry(descriptionLabel, (value) {
          setState(() {
            if (buttonId == "Doc_upload_button") {
              documentDescription = value;
            } else if (buttonId == "Uploadexcel") {
              uploadedExcelName = value;
            }
          });
        }, controller: UploadPDF),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: pickFile,
          // () async {
          //   // Handle file upload action
          //   // uploadDocument();

          //   // final result = await FilePicker.platform.pickFiles();
          //   // if (result == null) return;
          //   // final file = result.files.first;

          //   // String name = '${file.name}';
          //   // String byte = '${file.bytes}';
          //   // String Size = '${file.size}';
          //   // String path = '${file.path}';

          //   // await saveFilePermant
          //   // openFile(file);
          // },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.blue, // Set your desired background color here
          ),
          child: Text(buttonText,
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "TimesNewRoman",
                  color: Colors.white)),
        ),
      ],
    );
  }

  // void openFile(PlatformFile file) {
  //   openFile.open(file.path);
  // }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null) {
        // User canceled the picker
        return;
      }

      final file = result.files.first;
      String? base64String;

      setState(() {
        fileName = file.name;
        filetype = file.extension;
        fileSize = (file.size / 1024).toStringAsFixed(2) + " KB"; // Size in KB
        fileBytes = file.bytes;
      });
      if (file.path != null) {
        final bytes = await File(file.path!).readAsBytes();
        setState(() {
          fileBytes = bytes;
        });
      }
      if (fileBytes != null) {
        base64String = base64Encode(fileBytes!);
      }

      addData(
          fileName.toString(), filetype.toString(), base64String.toString());
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick file")),
      );
    }
  }

  String? fileName;
  String? filePath;
  String? fileSize;
  String? filetype;
  Uint8List? fileBytes;

  Future<void> uploadDocument() async {
    String fileName = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        fileName = result.files.single.name; // Store the file name
      });

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      // try {
      //   Dio dio = Dio();
      //   var response = await dio.post('YOUR_UPLOAD_ENDPOINT', data: formData);
      //   print('Upload successful: ${response.data}');
      // } catch (e) {
      //   print('Upload failed: $e');
      // }
    }
  }

  void addData(String Name, String Type, String ByteArray) {
    String field1 = Name.toString();
    String field2 = Type.toString();
    String field3 = UploadPDF.text;

    // return {
    //   'Extension': TaxAmount,
    //   'Name': Kid,
    //   'content': content,
    //   'content': Describtiont,
    // };

    try {
      UploadFile newJourneyy = UploadFile(
        // taxAmount: "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~$field5,",

        Extension: field2,
        Name: field1, // Assuming this is always 0, modify as necessary
        content: ByteArray.toString(),
        Description: field3, //done
        //done
      );

      // Add JourneyData wrapped in Table1 to the journey list
      setState(() {
        UploadFilee.add({
          'Table1': newJourneyy.toJson(),
        });

        // Clear text fields after adding the data
      });
      UploadPDF.clear();
    } catch (e) {
      print('ERROR: $e');
    }
  }

  Future<void> _TravelMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_TravelMode';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        int all = 0;
        for (var config in jsonData) {
          travelmodes vObject = new travelmodes();

          vObject.kid = config["kid"];
          vObject.value = config["value"];
          vObject.text = config["text"];

          fromAccountList.add(vObject);
        }
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelType() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_travelType';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          traveltypes =
              jsonData.map((data) => TravelType.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelPurpose() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_travelPurposeVisit';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelpurpose =
              jsonData.map((data) => TravelPurpose.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelCountry() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_cnt';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelcountry =
              jsonData.map((data) => TravelCountry.fromJson(data)).toList();
        });
        _TravelState();
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_state';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelstate =
              jsonData.map((data) => TravelState.fromJson(data)).toList();
        });
        _TravelCity();
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelCity() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_city';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelcity =
              jsonData.map((data) => TravelCity.fromJson(data)).toList();
        });
        _TravelCityClass();
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  Future<void> _TravelCityClass() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_cityclass';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelcityclass =
              jsonData.map((data) => TravelCityClass.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {});
      _showAlertDialog("Alert", "Unable to Connect to the Server");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
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

class TravelMode {
  final int kid;
  final String value;
  final String text;

  TravelMode({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelMode.fromJson(Map<String, dynamic> json) {
    return TravelMode(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelType {
  final int kid;
  final String value;
  final String text;

  TravelType({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelType.fromJson(Map<String, dynamic> json) {
    return TravelType(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelPurpose {
  final int kid;
  final String value;
  final String text;

  TravelPurpose({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelPurpose.fromJson(Map<String, dynamic> json) {
    return TravelPurpose(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelCountry {
  final int kid;
  final String value;
  final String text;

  TravelCountry({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelCountry.fromJson(Map<String, dynamic> json) {
    return TravelCountry(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelState {
  final int kid;
  final String value;
  final String text;

  TravelState({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelState.fromJson(Map<String, dynamic> json) {
    return TravelState(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelCity {
  final int kid;
  final String value;
  final String text;

  TravelCity({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelCity.fromJson(Map<String, dynamic> json) {
    return TravelCity(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class TravelCityClass {
  final int kid;
  final String value;
  final String text;

  TravelCityClass({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelCityClass.fromJson(Map<String, dynamic> json) {
    return TravelCityClass(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}
