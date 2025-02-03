import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_DetailsShow.dart';
import 'package:ehr/Dashboard/TravelClaim/TravelClaim_Request/TravelClaim_Third.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Entry.dart';
import 'package:ehr/Model/HotelMode.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TravelClaimSecond extends StatefulWidget {
  @override
  _TravelClaimSecond createState() => _TravelClaimSecond();
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

class JourneyData {
  String TaxAmount;
  int Kid;
  String jourDepDate;
  String jourDepTime;
  String jourDepPlace;
  String jourArrDate;
  String jourArrTime;
  String jourArrPlace;
  String travelMode;
  String jourFare;
  String jourDist;
  String visitPur;
  String remarks;

  JourneyData({
    required this.TaxAmount,
    required this.Kid,
    required this.jourDepDate,
    required this.jourDepTime,
    required this.jourDepPlace,
    required this.jourArrDate,
    required this.jourArrTime,
    required this.jourArrPlace,
    required this.travelMode,
    required this.jourFare,
    required this.jourDist,
    required this.visitPur,
    required this.remarks,
  });

  // Convert each JourneyData to JSON
  Map<String, dynamic> toJson() {
    return {
      'TaxAmount': TaxAmount,
      'Kid': Kid,
      'JourDepDate': jourDepDate,
      'JourDepTime': jourDepTime,
      'JourDepPlace': jourDepPlace,
      'JourArrDate': jourArrDate,
      'JourArrTime': jourArrTime,
      'JourArrPlace': jourArrPlace,
      'TravelMode': travelMode,
      'JourFare': jourFare,
      'JourDist': jourDist,
      'VisitPur': visitPur,
      'Remarks': remarks,
    };
  }
}

class Boardging {
  String TaxAmount;
  int Kid;
  String BoardFromDate;
  String BoardToDate;
  String BoardHotelType;
  String BoardHotel;
  String BoardRate;
  String FoodBillAmount;
  String BoardtotAmt;

  Boardging({
    required this.TaxAmount,
    required this.Kid,
    required this.BoardFromDate,
    required this.BoardToDate,
    required this.BoardHotelType,
    required this.BoardHotel,
    required this.BoardRate,
    required this.FoodBillAmount,
    required this.BoardtotAmt,
  });

  // Convert each JourneyData to JSON
  Map<String, dynamic> toJson() {
    return {
      'TaxAmount': TaxAmount,
      'Kid': Kid,
      'BoardFromDate': BoardFromDate,
      'BoardToDate': BoardToDate,
      'BoardHotelType': BoardHotelType,
      'BoardHotel': BoardHotel,
      'BoardRate': BoardRate,
      'FoodBillAmount': FoodBillAmount,
      'BoardtotAmt': BoardtotAmt,
    };
  }
}

// Class to hold the Journey data, including a list of journeys

class BOARDGING {
  List<Map<String, dynamic>> BoardgingDataList;

  // Constructor to accept the journey data
  BOARDGING({required this.BoardgingDataList});

  // Convert Journey object to JSON
  Map<String, dynamic> toJson() {
    return {
      'BoardData':
          BoardgingDataList, // Journey data wrapped inside the 'Journey' key
    };
  }
}

class _TravelClaimSecond extends State<TravelClaimSecond> {
  DateTime? _selectedDate;
  DateTime startDate = DateTime(2024, 11, 1); // Example start date
  DateTime endDate = DateTime(2024, 11, 15);

  final TextEditingController totalEstimatedController =
      TextEditingController();
  final TextEditingController controller = TextEditingController();
  TextEditingController Time = TextEditingController();
  TextEditingController _lodgingcharged = TextEditingController();
  TextEditingController _foodbillamount = TextEditingController();
  TextEditingController _amountwithouttax = TextEditingController();
  TextEditingController _distance = TextEditingController();
  TextEditingController _uploadfile = TextEditingController();

  TextEditingController _DepartureStartpoint = TextEditingController();
  TextEditingController _DepartureEndpoint = TextEditingController();
  TextEditingController _BasicFair = TextEditingController();
  TextEditingController _PurposeRemark = TextEditingController();
  TextEditingController _NameHotel = TextEditingController();
  TextEditingController _DepartureTime = TextEditingController();
  TextEditingController _ArrivalTime = TextEditingController();
  TextEditingController entryController = TextEditingController();
  TextEditingController labelController = TextEditingController();

  TextEditingController _GSTNUMBERBoardging = TextEditingController();
  TextEditingController _VendornameBoardging = TextEditingController();
  TextEditingController _BillNoBoardging = TextEditingController();
  TextEditingController _ItemDetilsBoardging = TextEditingController();
  TextEditingController _SACCodeBoardging = TextEditingController();
  TextEditingController _QuanityBoardging = TextEditingController();
  TextEditingController _RateBoardging = TextEditingController();
  TextEditingController _IGSTBoardging = TextEditingController();
  TextEditingController _CGSTBoardging = TextEditingController();
  TextEditingController _TotaltaxAmountBoardging = TextEditingController();
  TextEditingController _TotalRawAmountBoardging = TextEditingController();
  TextEditingController TotalTaxAmountBoardging = TextEditingController();
  TextEditingController _CESSBoardging = TextEditingController();
  TextEditingController _SGSTBoardging = TextEditingController();

  TextEditingController _GSTNUMBERJourney = TextEditingController();
  TextEditingController _VendornameJourney = TextEditingController();
  TextEditingController _BillNoJourney = TextEditingController();
  TextEditingController _ItemDetilsJourney = TextEditingController();
  TextEditingController _SACCodeJourney = TextEditingController();
  TextEditingController _QuanityJourney = TextEditingController();
  TextEditingController _RateJourney = TextEditingController();
  TextEditingController _IGSTJourney = TextEditingController();
  TextEditingController _CGSTJourney = TextEditingController();
  TextEditingController _TotaltaxAmountJourney = TextEditingController();
  TextEditingController _TotalRawAmountJourney = TextEditingController();
  TextEditingController TotalTaxAmountJourney = TextEditingController();
  TextEditingController _CESSJourney = TextEditingController();
  TextEditingController _SGSTJourney = TextEditingController();
  final _gstRegExp =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

  TravelType? selectedTravelType;
  //List<TravelMode> travelmodes = [];
  List<TravelType> traveltypes = [];
  List<TravelPurpose> travelpurpose = [];
  List<TravelHotel> travelhotel = [];
  List<TravelState> travelstate = [];
  List<TravelCity> travelcity = [];
  List<TravelCityClass> travelcityclass = [];
  //TravelMode? SecondTravelMode;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  DateTime? DepartureDate;
  DateTime? ArrivalDate;
  DateTime? DepartureTaxFromDate;
  DateTime? boardgingFromDate;
  DateTime? boardgingtoDate;
  DateTime? boardgingTaxDate;

  TravelPurpose? selectedPurposeVisit;
  TravelHotel? SelectTravelHotel;
  String? purposeDetails;
  String? selectedProjectType;
  String? selectedCompanyVehicle;
  TravelCity? selectedStartCity;
  TravelCityClass? selectedStartCityClass;
  TravelState? selectedEndState;
  TravelCity? selectedEndCity;
  TravelCityClass? selectedEndCityClass;

  bool? travelTicket = false;
  bool? hotel = false;
  bool? cabTaxi = false;
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
  String? PurPoseKid;
  String? HotelTypeKid;

  String? journeydetaisl;
  String? boardingdetail;
  String? TaxJourney;
  String? _travelMode;
  String? _PurposeVisit;
  String? _TypeOFHotel;
  String LabelTextField = "";
  bool journey = false;
  bool boarding = false;
  String? _Claimant;

  bool taxLocal = false;
  bool taxBoarding = false;
  var SecondTravelMode;
  String? _selectedValue;
  String? _lodgingfrmdate;

  late DateTime _startDate;
  late DateTime _endDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  //List<JourneyData> journeyDataList = [];
  List<Boardging> Boardlist = [];
  List<Map<String, dynamic>> journeyList = [];
  List<Map<String, dynamic>> BoardginList = [];
  String? _lodgingToDate;
  String? _ArrivalDate;
  String? _departuredate;
  String? __TaxJorneydate;
  String? __TaxBoardgingDate;
  String? _Boardgingclaimant;
  String? Journey;
  String? Boardgingtax;
  double total = 0.0;
  double totall = 0.0;
  double TotalRowAmount = 0.0;
  //Journey journeyyy = Journey(journeyDataList: formattedJourneyList);

  final List<travelmodes> fromAccountList = <travelmodes>[];

  // void taxUpdateTotalJourney() {
  //   double IGSTJourney = double.tryParse(_IGSTJourney.text) ?? 0;
  //   double SGSTJourney = double.tryParse(_SGSTJourney.text) ?? 0;
  //   double CGSTJourney = double.tryParse(_CGSTJourney.text) ?? 0;
  //   double CESSJourney = double.tryParse(_CESSJourney.text) ?? 0;
  //   if (_TotalRawAmountJourney.text == "") {
  //     total = IGSTJourney + SGSTJourney + CGSTJourney + CESSJourney;
  //   } else {
  //     String ronaknyariya = _TotalRawAmountJourney.text.toString();
  //     double CESSJourneyy = double.tryParse(ronaknyariya) ?? 0;
  //     total =
  //         IGSTJourney + SGSTJourney + CGSTJourney + CESSJourney + CESSJourneyy;
  //   }

  //   setState(() {
  //     // _TotaltaxAmountJourney.text = total.toString();
  //     _TotalRawAmountJourney.text = total.toString();
  //   });
  // }

  // void RowUpdateTotalJourney() {
  //   double IGSTJourney = double.tryParse(_IGSTJourney.text) ?? 0;
  //   double SGSTJourney = double.tryParse(_SGSTJourney.text) ?? 0;
  //   // double CGSTJourney = double.tryParse(_CGSTJourney.text) ?? 0;
  //   // double CESSJourney = double.tryParse(_CESSJourney.text) ?? 0;
  //   totall = IGSTJourney + SGSTJourney ;

  //   setState(() {
  //     _TotaltaxAmountJourney.text = total.toString();
  //     // _TotalRawAmountJourney.text = total.toString();
  //   });
  // }

  // void RowUpdateTotalboardging() {
  //   double IGSTBoardging = double.tryParse(_IGSTBoardging.text) ?? 0;
  //   double SGSTBoardging = double.tryParse(_SGSTBoardging.text) ?? 0;
  //   double CGSTBoardging = double.tryParse(_CGSTBoardging.text) ?? 0;
  //   double CESSBoardging = double.tryParse(_CESSBoardging.text) ?? 0;
  //   double total =
  //       IGSTBoardging + SGSTBoardging + CGSTBoardging + CESSBoardging;
  //   setState(() {
  //     _TotaltaxAmountBoardging.text = total.toString();
  //     //_TotalRawAmountBoardging.text = total.toString();
  //   });
  // }

  // void taxUpdateboardging() {
  //   double IGSTBoardging = double.tryParse(_IGSTBoardging.text) ?? 0;
  //   double SGSTBoardging = double.tryParse(_SGSTBoardging.text) ?? 0;
  //   double CGSTBoardging = double.tryParse(_CGSTBoardging.text) ?? 0;
  //   double CESSBoardging = double.tryParse(_CESSBoardging.text) ?? 0;
  //   double total =
  //       IGSTBoardging + SGSTBoardging + CGSTBoardging + CESSBoardging;

  //   if (_TotalRawAmountBoardging.text == "") {
  //     total = IGSTBoardging + SGSTBoardging + CGSTBoardging + CESSBoardging;
  //   } else {
  //     String ronaknyariya = _TotalRawAmountBoardging.text.toString();
  //     double CESSJourneyy = double.tryParse(ronaknyariya) ?? 0;
  //     total = IGSTBoardging +
  //         SGSTBoardging +
  //         CGSTBoardging +
  //         CESSBoardging +
  //         CESSJourneyy;
  //   }
  //   setState(() {
  //     //_TotaltaxAmountBoardging.text = total.toString();
  //     _TotalRawAmountBoardging.text = total.toString();
  //   });
  // }
  double _totalTax = 0.0;
  double totatt = 0.0;

  void _calculateTotalTax() {
    // double Ronak = 0.0;
    // if (_TotalRawAmountJourney.text == _BasicFair.text) {
    //   Ronak = double.tryParse(_BasicFair.text) ?? 0.0;
    // } else {
    //   Ronak = double.tryParse(_TotalRawAmountJourney.text) ?? 0.0;
    //   ;
    // }

    final double igst = double.tryParse(_SGSTJourney.text) ?? 0.0;
    final double cgst = double.tryParse(_CGSTJourney.text) ?? 0.0;
    final double sgst = double.tryParse(_CESSJourney.text) ?? 0.0;
    final double cess = double.tryParse(_IGSTJourney.text) ?? 0.0;
    //final double Total = double.tryParse(_TotaltaxAmountJourney.text) ?? 0.0;

    setState(() {
      _totalTax = igst + cgst + sgst + cess;
      final Grandtotal = _totalTax + TotalRowAmount;
      _TotaltaxAmountJourney.text = _totalTax.toStringAsFixed(2);
      //totatt = _totalTax + Total;

      _TotalRawAmountJourney.text = Grandtotal.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    _TravelPurpose();
    _TravelHotelType();
    _TravelMode();

    dataFound();

    _lodgingcharged.addListener(updateTotal);
    _foodbillamount.addListener(updateTotal);
    //  _SGSTJourney.addListener(RowUpdateTotalJourney);
    //   _CGSTJourney.addListener(RowUpdateTotalJourney);

    // _IGSTJourney.addListener(taxUpdateTotalJourney);
    // _SGSTJourney.addListener(taxUpdateTotalJourney);
    // _CGSTJourney.addListener(taxUpdateTotalJourney);
    // _CESSJourney.addListener(taxUpdateTotalJourney);
    // _TotaltaxAmountJourney.addListener(taxUpdateTotalJourney);
    // _IGSTBoardging.addListener(taxUpdateboardging);
    // _SGSTBoardging.addListener(taxUpdateboardging);
    // _CGSTBoardging.addListener(taxUpdateboardging);
    // _CESSBoardging.addListener(taxUpdateboardging);
    // _IGSTJourney.addListener(RowUpdateTotalJourney);
    // _SGSTJourney.addListener(RowUpdateTotalJourney);
    // _CGSTJourney.addListener(RowUpdateTotalJourney);
    // _CESSJourney.addListener(RowUpdateTotalJourney);
    // _IGSTBoardging.addListener(RowUpdateTotalboardging);
    // _SGSTBoardging.addListener(RowUpdateTotalboardging);
    // _CGSTBoardging.addListener(RowUpdateTotalboardging);
    // _CESSBoardging.addListener(RowUpdateTotalboardging);

    _ItemDetilsJourney.text = "0";
    _SACCodeJourney.text = "0";
    _QuanityJourney.text = "0";
    _RateJourney.text = "0";
    _SGSTJourney.text = "0";
    _CGSTJourney.text = "0";
    _CESSJourney.text = "0";
    _IGSTJourney.text = "0";
    _BillNoJourney.text = "0";
    _TotaltaxAmountJourney.text = "0";
    _VendornameJourney.text = "null";
    _GSTNUMBERJourney.text = "0";
    _ItemDetilsBoardging.text = "0";
    _SACCodeBoardging.text = "0";
    _QuanityBoardging.text = "0";
    _RateBoardging.text = "0";
    _SGSTBoardging.text = "0";
    _CGSTBoardging.text = "0";
    _CESSBoardging.text = "0";
    _TotaltaxAmountBoardging.text = "0";
    _VendornameBoardging.text = "null";
    _GSTNUMBERBoardging.text = "0";
    _IGSTBoardging.text = "0";
    _BillNoBoardging.text = "0";
  }

  // Class to hold each journey's data

  // Convert the journeyDataList into the desired format (wrap each JourneyData in 'Table1')

  void addData() {
    // if (_departuredate.toString() == "null") {
    //   Alert_DialogBox.showAlert(context, "PLease Select Departure Date");
    //   return;
    // } else if (_DepartureTime.text == null ||
    //     _DepartureTime.text.toString() == "") {
    //   Alert_DialogBox.showAlert(context, "PLease Enter Departure Time");
    //   return;
    // }

    // toDay
    if (_ArrivalDate.toString() == null || _ArrivalDate.toString() == "") {
      Alert_DialogBox.showAlert(context, "PLease Select Arrival Date");
      return;
    } else if (_ArrivalTime.text == null ||
        _ArrivalTime.text.toString() == "") {
      Alert_DialogBox.showAlert(context, "PLease Enter Departure Time");
      return;
    } else if (_DepartureStartpoint.text == null ||
        _DepartureStartpoint.text == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    } else if (_DepartureEndpoint.text == null ||
        _DepartureEndpoint.text == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    } else if (SecondTravelMode == null || SecondTravelMode == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    } else if (_BasicFair.text == null || _BasicFair.text == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    } else if (_distance.text == null || _distance.text == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    } else if (selectedPurposeVisit == null || selectedPurposeVisit == "") {
      Alert_DialogBox.showAlert(context, "PLease Fill All Details");
      return;
    }
    if (_GSTNUMBERJourney.text != "0") {
      if (!_gstRegExp.hasMatch(_GSTNUMBERJourney.text.trim())) {
        Alert_DialogBox.showAlert(context,
            "Invalid GST number format. Please enter a valid GST number");
        return;
      }
      // String ddd = _GSTNUMBERJourney.text.toString();
    }

    String field1 = _DepartureStartpoint.text;
    String field2 = _DepartureEndpoint.text;
    String field3 = _DepartureTime.text;
    String field4 = _ArrivalTime.text;
    String field5 = _BasicFair.text;
    String field6 = _distance.text;
    String field7 = _PurposeRemark.text;
    _TotalRawAmountJourney.text = _BasicFair.text.toString();

    if (TaxJourney == null) {
      Journey = "Self";
    } else {
      Journey = TaxJourney.toString();
    }
    String? formatted;
    if (__TaxJorneydate.toString() == "null") {
      DateTime now = DateTime.now();

      // Format the date if needed
      formatted = DateFormat('dd/MM/yyyy').format(now);
    }

    String TaxData = Journey.toString() +
        "~" +
        _GSTNUMBERJourney.text.toString() +
        "~" +
        _VendornameJourney.text.toString() +
        "~" +
        _BillNoJourney.text.toString() +
        "~" +
        formatted.toString() +
        "~" +
        _ItemDetilsJourney.text.toString() +
        "~" +
        _SACCodeJourney.text.toString() +
        "~" +
        _QuanityJourney.text.toString() +
        "~" +
        _RateJourney.text.toString() +
        "~" +
        _IGSTJourney.text.toString() +
        "~" +
        _SGSTJourney.text.toString() +
        "~" +
        _CGSTJourney.text.toString() +
        "~" +
        _CESSJourney.text.toString() +
        "~" +
        _TotaltaxAmountJourney.text.toString() +
        "~" +
        _TotalRawAmountJourney.text.toString();

    // Create a new JourneyData object

    try {
      JourneyData newJourney = JourneyData(
        // taxAmount: "SELF~0~null~0~0~01/01/1900~0~0~0~0~0~0~0~0~0~$field5,",

        TaxAmount: TaxData,
        Kid: 0, // Assuming this is always 0, modify as necessary
        jourDepDate: _departuredate.toString(),
        jourDepTime: field3, //done
        jourDepPlace: field1, //done
        jourArrDate: _ArrivalDate.toString(), //done
        jourArrTime: field4, //done
        jourArrPlace: field2,
        travelMode: LabelTextField.toString(),
        jourFare: field5.toString(), //done
        jourDist: field6, //done
        visitPur: PurPoseKid.toString(),
        remarks: field7, //done
      );

      // Add JourneyData wrapped in Table1 to the journey list
      setState(() {
        journeyList.add({
          'Table1': newJourney.toJson(),
        });

        // Clear text fields after adding the data
        _DepartureStartpoint.clear();
        _DepartureEndpoint.clear();
        _DepartureTime.clear();
        _ArrivalTime.clear();
        _BasicFair.clear();
        _distance.clear();
        _PurposeRemark.clear();
        taxLocal = false;
      });
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void addDataBoarddging() {
    if (_lodgingfrmdate == "null") {
      Alert_DialogBox.showAlert(context, "Please Select Period From Date");
    } else if (_lodgingToDate == "null") {
      Alert_DialogBox.showAlert(context, "Please Select Period To Date");
    } else if (SelectTravelHotel == null || SelectTravelHotel == "") {
      Alert_DialogBox.showAlert(context, "Please Select Hotel Type");
      return;
    } else if (_NameHotel.text == null || _NameHotel.text == "") {
      Alert_DialogBox.showAlert(context, "Please Enter Hotel Name ");
      return;
    } else if (_lodgingcharged.text == null || _lodgingcharged.text == "") {
      Alert_DialogBox.showAlert(context, "Please Enter Lodging Charged");
      return;
    } else if (_foodbillamount.text == null || _foodbillamount.text == "") {
      Alert_DialogBox.showAlert(context, "Please Enter Food Bill Amount");
      return;
    } else if (_GSTNUMBERJourney.text != "0") {
      if (!_gstRegExp.hasMatch(_GSTNUMBERJourney.text.trim())) {
        Alert_DialogBox.showAlert(context,
            "Invalid GST number format. Please enter a valid GST number");
        return;
      }
      // String ddd = _GSTNUMBERJourney.text.toString();
    }

    String field1 = HotelTypeKid.toString();
    String field2 = _NameHotel.text;
    String field3 = _lodgingcharged.text;
    String field4 = _foodbillamount.text;
    String field5 = _amountwithouttax.text;
    String Field6 = _lodgingToDate.toString();
    String field7 = _lodgingfrmdate.toString();
    _TotalRawAmountBoardging.text = _amountwithouttax.text.toString();
    if (_Boardgingclaimant == null) {
      Boardgingtax = "Self";
    } else {
      Boardgingtax = _Boardgingclaimant.toString();
    }
    String? formattedd;
    if (__TaxBoardgingDate.toString() == "null") {
      DateTime now = DateTime.now();

      // Format the date if needed
      formattedd = DateFormat('dd/MM/yyyy').format(now);
    }

    String TaxData = Boardgingtax.toString() +
        "~" +
        _GSTNUMBERBoardging.text.toString() +
        "~" +
        _VendornameBoardging.text.toString() +
        "~" +
        _BillNoBoardging.text.toString() +
        "~" +
        __TaxBoardgingDate.toString() +
        "~" +
        _ItemDetilsBoardging.text.toString() +
        "~" +
        _SACCodeBoardging.text.toString() +
        "~" +
        _QuanityBoardging.text.toString() +
        "~" +
        _RateBoardging.text.toString() +
        "~" +
        _IGSTBoardging.text.toString() +
        "~" +
        _SGSTBoardging.text.toString() +
        "~" +
        _CGSTBoardging.text.toString() +
        "~" +
        _CESSBoardging.text.toString() +
        "~" +
        _TotaltaxAmountBoardging.text.toString() +
        "~" +
        _TotalRawAmountBoardging.text.toString();

    // Create a new JourneyData object
    Boardging newJourney = Boardging(
      TaxAmount: TaxData,
      Kid: 0, // Assuming this is always 0, modify as necessary
      BoardFromDate: field7,
      BoardToDate: Field6,
      BoardHotelType: field1,
      BoardHotel: field2,
      BoardRate: field3,
      FoodBillAmount: field4,
      BoardtotAmt: field5,
    );

    // Add JourneyData wrapped in Table1 to the journey list
    setState(() {
      BoardginList.add({
        'Table1': newJourney.toJson(),
      });

      // Clear text fields after adding the data
      _NameHotel.clear();
      _lodgingcharged.clear();
      _foodbillamount.clear();
      _amountwithouttax.clear();
      taxBoarding = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: startDate,
      lastDate: endDate,
      selectableDayPredicate: (DateTime date) {
        // Only allow dates between startDate and endDate
        return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            date.isBefore(endDate.add(const Duration(days: 1)));
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> dataFound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dateRange = prefs.getString("_dateRange") ?? '';
    });
  }

  String _dateRange = "";

  void updateTotal() {
    double firstAmount = double.tryParse(_lodgingcharged.text) ?? 0;
    double secondAmount = double.tryParse(_foodbillamount.text) ?? 0;
    double total = firstAmount + secondAmount;

    setState(() {
      _amountwithouttax.text = total.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Split by "To"

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
              MaterialPageRoute(builder: (context) => TravelClaimDetails()),
            );
            //Navigator.pop(context);
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
                  labelText: "Journey Details Required*",
                  items: ["Yes", "No"],
                  selectedItem: journeydetaisl,
                  onChanged: (value) {
                    setState(() {
                      journeydetaisl = value;
                      journey = (journeydetaisl == "Yes");
                    });
                  },
                  displayText: (Vehicle) => Vehicle),
              Visibility(
                  visible: journey,
                  child: DeparturefieldDate("Departure Date", "Time",
                      controller: _DepartureTime)),
              Visibility(
                visible: journey,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: journey,
                child: buildTextField("Departure Start Point", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _DepartureStartpoint,
                    keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: journey,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: journey,
                child: Arrivalfielddate("Arrival Date", "Time",
                    controller: _ArrivalTime),
              ),
              Visibility(
                visible: journey,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: journey,
                child: buildTextField("Departure End Point", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _DepartureEndpoint,
                    keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: journey,
                child: buildDropdownField<travelmodes>(
                  labelText: "Travel Mode",
                  items: fromAccountList,
                  selectedItem: SecondTravelMode,
                  onChanged: (value) {
                    setState(() {
                      SecondTravelMode = value;
                    });

                    LabelTextField = value!.kid.toString();
                  },
                  displayText: (SecondTravelMode) => SecondTravelMode.text
                      .toString(), // Display only the text field
                ),
              ),
              Visibility(
                visible: journey,
                child: buildTextField("Basic Fair", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                }, controller: _BasicFair, keyboardType: TextInputType.number),
              ),
              Visibility(
                visible: journey,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: journey,
                child: buildTextField("Distance", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                }, controller: _distance, keyboardType: TextInputType.number),
              ),
              Visibility(
                visible: journey,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: journey,
                child: buildDropdownField<TravelPurpose>(
                    labelText: "Purpose of Visit*",
                    items: travelpurpose,
                    selectedItem: selectedPurposeVisit,
                    onChanged: (value) {
                      setState(() {
                        selectedPurposeVisit = value;
                      });

                      PurPoseKid = value!.kid.toString();
                      _PurposeRemark.text = value!.text.toString();
                    },
                    displayText: (mode) => mode.text),
              ),
              Visibility(
                visible: journey,
                child: buildTextField("Purpose Remarks", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _PurposeRemark,
                    keyboardType: TextInputType.text),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: journey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (journeydetaisl == "Yes") {
                            if (_DepartureStartpoint.text == null ||
                                _DepartureStartpoint.text == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            } else if (_DepartureEndpoint.text == null ||
                                _DepartureEndpoint.text == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            } else if (SecondTravelMode == null ||
                                SecondTravelMode == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            } else if (_BasicFair.text == null ||
                                _BasicFair.text == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            } else if (_distance.text == null ||
                                _distance.text == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            } else if (selectedPurposeVisit == null ||
                                selectedPurposeVisit == "") {
                              Alert_DialogBox.showAlert(
                                  context, "PLease Fill All Details");
                              return;
                            }
                          }
                          _TotalRawAmountJourney.text =
                              _BasicFair.text.toString();
                          TotalRowAmount = double.parse(_BasicFair.text);

                          taxLocal = true;
                          _calculateTotalTax();
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
                visible: taxLocal,
                child: buildDropdownField<String>(
                    labelText: "Claimant",
                    items: ["Self", "Agent", "Office"],
                    selectedItem: TaxJourney,
                    onChanged: (value) {
                      setState(() {
                        TaxJourney = value;
                      });
                    },
                    displayText: (Vehicle) => Vehicle),
              ),
              Visibility(
                visible: taxLocal,
                child: GSTNUMBERFIELD("GST Number", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    controller: _GSTNUMBERJourney,
                    keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: taxLocal,
                child: TaxDatedepatrue("Bill Date", "Vendor Name",
                    controller: _VendornameJourney),
              ),
              Visibility(
                visible: taxLocal,
                child: TaxFieldd(
                  entryName: "Bill No",
                  labelName: "Item Details",
                  entryController: _BillNoJourney,
                  labelController: _ItemDetilsJourney,
                ),
              ),
              Visibility(
                visible: taxLocal,
                child: TaxFieldd(
                  entryName: "SAC Code",
                  labelName: "Quantity",
                  entryController: _SACCodeJourney,
                  labelController: _QuanityJourney,
                ),
              ),
              Visibility(
                visible: taxLocal,
                child: buildTextField("Rate", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _RateJourney,
                    keyboardType: TextInputType.number),
              ),
              // Visibility(
              //   visible: taxLocal,
              //   child: TaxFieldd(
              //     entryName: "Rate",
              //     labelName: "IGST",
              //     entryController: _RateJourney,
              //     labelController: _IGSTJourney,
              //   ),
              // ),
              // Visibility(
              //   visible: taxLocal,
              //   child: IGSTNUMBER(
              //     entryName: "SGST",
              //     labelName: "CGST",
              //     entryController: _SGSTJourney,
              //     labelController: _CGSTJourney,
              //   ),
              // ),
              Visibility(
                visible: taxLocal,
                child: IGSTNUMBER(
                  entryName: "IGST",
                  labelName: "SGST",
                  entryController: _IGSTJourney,
                  labelController: _SGSTJourney,
                  onChanged: (value) => _calculateTotalTax(),
                ),
              ),
              Visibility(
                visible: taxLocal,
                child: IGSTNUMBER(
                  entryName: "CGST",
                  labelName: "CESS",
                  entryController: _CGSTJourney,
                  labelController: _CESSJourney,
                  onChanged: (value) => _calculateTotalTax(),
                ),
              ),
              Visibility(
                visible: taxLocal,
                child: TaxbuildTextField("Total Tax Amount", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    controller: _TotaltaxAmountJourney,
                    keyboardType: TextInputType.text),
              ),

              Visibility(
                visible: taxLocal,
                child: TaxbuildTextField("Total Row Amount", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    controller: _TotalRawAmountJourney,
                    keyboardType: TextInputType.text),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: journey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        onPressed:
                        addData();
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
              buildDropdownField<String>(
                  labelText: "Boarding/lodging Details Requires*",
                  items: ["Yes", "No"],
                  selectedItem: boardingdetail,
                  onChanged: (value) {
                    setState(() {
                      boardingdetail = value;
                      boarding = (boardingdetail == "Yes");
                    });
                  },
                  displayText: (Vehicle) => Vehicle),
              Visibility(
                visible: boarding,
                child: buildSectionLabel("Period Of Stay"),
              ),
              Visibility(
                visible: boarding,
                child: buildDateFields("From Date"),
              ),
              Visibility(
                visible: boarding,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: boarding,
                child: buildDropdownField<TravelHotel>(
                    labelText: "Type Of Hotel",
                    items: travelhotel,
                    selectedItem: SelectTravelHotel,
                    onChanged: (value) {
                      setState(() {
                        SelectTravelHotel = value;
                      });

                      HotelTypeKid = value!.kid.toString();
                    },
                    displayText: (mode) => mode.Name),
              ),
              Visibility(
                visible: boarding,
                child: buildTextField("Name Of Hotel", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                }, controller: _NameHotel, keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: boarding,
                child: buildTextField("Lodging Charged", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _lodgingcharged,
                    keyboardType: TextInputType.number),
              ),
              Visibility(
                visible: boarding,
                child: buildTextField("Food Bill Amount", (value) {
                  setState(() {
                    purposeDetails = value;
                  });
                },
                    controller: _foodbillamount,
                    keyboardType: TextInputType.number),
              ),
              Visibility(
                visible: boarding,
                child: buildTextFieldhardcode(
                  "Amount Without Tax",
                  (value) {
                    setState(() {
                      purposeDetails = value;
                    });
                  },
                  controller: _amountwithouttax,
                ),
              ),
              Visibility(
                visible: boarding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (SelectTravelHotel == null ||
                              SelectTravelHotel == "") {
                            Alert_DialogBox.showAlert(
                                context, "Please Select Hotel Type");
                            return;
                          } else if (_NameHotel.text == null ||
                              _NameHotel.text == "") {
                            Alert_DialogBox.showAlert(
                                context, "Please Enter Hotel Name ");
                            return;
                          } else if (_lodgingcharged.text == null ||
                              _lodgingcharged.text == "") {
                            Alert_DialogBox.showAlert(
                                context, "Please Enter Lodging Charged");
                            return;
                          } else if (_foodbillamount.text == null ||
                              _foodbillamount.text == "") {
                            Alert_DialogBox.showAlert(
                                context, "Please Enter Food Bill Amount");
                            return;
                          }
                          taxBoarding = true;
                          // String ronam =
                          //     _TotaltaxAmountBoardging.text.toString();
                          _TotalRawAmountBoardging.text =
                              _amountwithouttax.text.toString();
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
                visible: taxBoarding,
                child: buildDropdownField<String>(
                    labelText: "Claimant",
                    items: ["Self", "Agent", "Office"],
                    selectedItem: _Boardgingclaimant,
                    onChanged: (value) {
                      setState(() {
                        _Boardgingclaimant = value;
                      });
                    },
                    displayText: (Vehicle) => Vehicle),
              ),
              Visibility(
                visible: taxBoarding,
                child: GSTNUMBERFIELD("GST Number", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    controller: _GSTNUMBERBoardging,
                    keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxDateBoardging("Bill Date", "Vendor Name",
                    controller: _VendornameBoardging),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxFieldd(
                  entryName: "Bill No",
                  labelName: "Item Details",
                  entryController: _BillNoBoardging,
                  labelController: _ItemDetilsBoardging,
                ),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxFieldd(
                  entryName: "SAC Code",
                  labelName: "Quantity",
                  entryController: _SACCodeBoardging,
                  labelController: _QuanityBoardging,
                ),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxFieldd(
                  entryName: "Rate",
                  labelName: "IGST",
                  entryController: _RateBoardging,
                  labelController: _IGSTBoardging,
                ),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxFieldd(
                  entryName: "SGST",
                  labelName: "CGST",
                  entryController: _SGSTBoardging,
                  labelController: _CGSTBoardging,
                ),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxFieldd(
                  entryName: "CESS",
                  labelName: "Total Tax Amount",
                  entryController: _CESSBoardging,
                  labelController: _TotaltaxAmountBoardging,
                ),
              ),
              Visibility(
                visible: taxBoarding,
                child: TaxbuildTextField("Total Row Amount", (value) {
                  setState(
                    () {
                      purposeDetails = value;
                    },
                  );
                },
                    controller: _TotalRawAmountBoardging,
                    keyboardType: TextInputType.text),
              ),
              Visibility(
                visible: boarding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligning horizontally in the center
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        onPressed:
                        addDataBoarddging();
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
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  if (journeydetaisl == null || journeydetaisl == "") {
                    Alert_DialogBox.showAlert(
                        context, "Please Select Journey Details Required");
                    return;
                  }
                  // if (journeydetaisl == "Yes") {
                  //   if (_DepartureStartpoint.text == null ||
                  //       _DepartureStartpoint.text == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Enter Departure Start Point");
                  //     return;
                  //   } else if (_DepartureEndpoint.text == null ||
                  //       _DepartureEndpoint.text == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Enter Departure End Point");
                  //     return;
                  //   } else if (SecondTravelMode == null ||
                  //       SecondTravelMode == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Select Travel Mode");
                  //     return;
                  //   } else if (_BasicFair.text == null ||
                  //       _BasicFair.text == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Enter Basic Fair");
                  //     return;
                  //   } else if (_distance.text == null || _distance.text == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Enter Distance KM");
                  //     return;
                  //   } else if (selectedPurposeVisit == null ||
                  //       selectedPurposeVisit == "") {
                  //     Alert_DialogBox.showAlert(
                  //         context, "Please Select Purpose Visit");
                  //     return;
                  //   }
                  // }
                  if (boardingdetail == null || boardingdetail == "") {
                    Alert_DialogBox.showAlert(context,
                        "Please Select Boarding/Lodging Details Required");
                    return;
                  }

                  if (journeyList.isEmpty) {
                    if (journeydetaisl == "Yes") {
                      if (_DepartureStartpoint.text == null ||
                          _DepartureStartpoint.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Departure Start Point");
                        return;
                      } else if (_DepartureEndpoint.text == null ||
                          _DepartureEndpoint.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Departure End Point");
                        return;
                      } else if (SecondTravelMode == null ||
                          SecondTravelMode == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Select Travel Mode");
                        return;
                      } else if (_BasicFair.text == null ||
                          _BasicFair.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Basic Fair");
                        return;
                      } else if (_distance.text == null ||
                          _distance.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Distance KM");
                        return;
                      } else if (selectedPurposeVisit == null ||
                          selectedPurposeVisit == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Select Purpose Visit");
                        return;
                      }
                    }
                    addData();
                  }
                  if (BoardginList.isEmpty) {
                    if (boardingdetail == "Yes") {
                      if (SelectTravelHotel == null ||
                          SelectTravelHotel == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Select Hotel Type");
                        return;
                      } else if (_NameHotel.text == null ||
                          _NameHotel.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Hotel Name ");
                        return;
                      }
                      if (_lodgingcharged.text == null ||
                          _lodgingcharged.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Lodging Charged");
                        return;
                      }
                      if (_foodbillamount.text == null ||
                          _foodbillamount.text == "") {
                        Alert_DialogBox.showAlert(
                            context, "Please Enter Food Bill Amount");
                        return;
                      }
                    }
                    addDataBoarddging();
                  }

                  final prefs = await SharedPreferences.getInstance();

                  String _DepartureDater = DepartureDate.toString();
                  String _ArrivalDate = ArrivalDate.toString();
                  String _boardgingFromDate = boardgingFromDate.toString();
                  String _boardgingtoDate = boardgingtoDate.toString();
                  String _DepartureTaxFromDate =
                      DepartureTaxFromDate.toString();
                  String _boardgingTaxDate = boardgingTaxDate.toString();

                  List<String> splitDate = _DepartureDater.split(" ");
                  List<String> arrivalDate = _ArrivalDate.split(" ");
                  List<String> todate = _boardgingtoDate.split(" ");
                  List<String> BoardgingFromDate =
                      _boardgingFromDate.split(" ");
                  List<String> departureTaxFromDate =
                      _DepartureTaxFromDate.split(" ");
                  List<String> BoardgingTaxDate = _boardgingTaxDate.split(" ");

                  String _DateDepature = splitDate[0];
                  String _Arrivaldate = arrivalDate[0];
                  String _BOARDDGINDDATEFrom = BoardgingFromDate[0];
                  String _BOARDDGINDDATEto = todate[0];
                  String _depatruretaxfromdate = departureTaxFromDate[0];
                  String _boardgingtaxdate = BoardgingTaxDate[0];

                  prefs.setString(
                      "_DepartureStartpoint", _DepartureStartpoint.text);
                  prefs.setString(
                      "_DepartureEndpoint", _DepartureEndpoint.text);
                  prefs.setString("_BasicFair", _BasicFair.text);
                  prefs.setString("_distance", _distance.text);
                  prefs.setString("_PurposeRemark", _PurposeRemark.text);
                  prefs.setString("_ArrivalTime", _ArrivalTime.text);
                  prefs.setString("_DepartureTime", _DepartureTime.text);
                  prefs.setString("LabelTextField", LabelTextField);
                  prefs.setString("PurPoseKid", PurPoseKid.toString());
                  prefs.setString("_NameHotel", _NameHotel.text);
                  prefs.setString("_lodgingcharged", _lodgingcharged.text);
                  prefs.setString("_foodbillamount", _foodbillamount.text);
                  prefs.setString("_amountwithouttax", _amountwithouttax.text);
                  prefs.setString("HotelTypeKid", HotelTypeKid.toString());
                  prefs.setString("_DepartureDate", _DateDepature.toString());
                  prefs.setString("_ArrivalDate", _Arrivaldate.toString());
                  prefs.setString(
                      "_BoardgingFromDate", _BOARDDGINDDATEFrom.toString());
                  prefs.setString(
                      "_BoardgingTodate", _BOARDDGINDDATEto.toString());
                  prefs.setString(
                      "_DepartureTaxDate", _depatruretaxfromdate.toString());
                  prefs.setString(
                      "_BoardgonfTaxDate", _boardgingtaxdate.toString());

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TravelClaimThird(
                              JourneyList: journeyList,
                              BoardgingList: BoardginList)));
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
            ],
          ),
        ),
      ),
    );
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

  Widget TaxbuildTextField(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
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
            enabled: false,
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

  Widget buildTextField(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
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
            enabled: true,
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

  Widget IGSTNUMBER({
    required String entryName,
    required String labelName,
    required TextEditingController entryController,
    required TextEditingController labelController,
    required Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entryName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF547EC8),
              ),
            ),
            Container(
              width: 150,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: entryController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: entryName,
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        // Second Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF547EC8),
              ),
            ),
            Container(
              width: 150,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: labelController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: labelName,
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget GSTNUMBERFIELD(
    String labelText,
    Function(String) onChanged, {
    bool isEnabled = false,
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
            enabled: true,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.black,

              // Set the color for the input text
            ),
            decoration: InputDecoration(
              hintText: labelText,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
              UpperCaseTextInputFormatter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldhardcode(
    String labelText,
    Function(String) onChanged, {
    // bool isEnabled = true,
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
            enabled: false,
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

  Widget buildNumericField(String labelText, TextEditingController controller,
      Function(String) onChanged, String? initialValue,
      {bool isEnabled = true}) {
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
        TextField(
          // controller: controller,
          enabled: isEnabled,
          decoration: const InputDecoration(
            hintText: "Vendor Name",
            hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black),

          keyboardType: TextInputType.text,
          onChanged: onChanged,
          controller: TextEditingController(text: initialValue),
        ),
      ],
    );
  }

  Widget Arrivalfielddate(
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
                try {
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
                      : (_focusedDay.isAfter(_endDate)
                          ? _endDate
                          : _focusedDay);

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: _startDate,
                    lastDate: _endDate,
                  );
                  if (pickedDate != null) {
                    setState(() {
                      ArrivalDate = pickedDate;
                    });

                    String Arrival = ArrivalDate.toString();

                    List<String> splitDte = Arrival.split(" ");

                    _ArrivalDate = splitDte[0];
                  }
                } catch (e) {
                  String errorMessage = 'An error occurred: $e';
                  print(errorMessage);
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
                  ArrivalDate != null
                      ? DateFormat('yyyy-MM-dd').format(ArrivalDate!)
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
                keyboardType: TextInputType.number,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "HH:MM",
                  border: InputBorder.none, // Remove the inner border
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5), // 16 digits + 3 spaces
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberFormatter(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget DeparturefieldDate(
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
                try {
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
                      : (_focusedDay.isAfter(_endDate)
                          ? _endDate
                          : _focusedDay);

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: _startDate,
                    lastDate: _endDate,
                  );
                  if (pickedDate != null) {
                    setState(() {
                      DepartureDate = pickedDate;
                    });

                    String Dat = DepartureDate.toString();

                    List<String> splitDte = Dat.split(" ");

                    _departuredate = splitDte[0];
                  }
                } catch (e) {
                  String errorMessage = 'An error occurred: $e';
                  print(errorMessage);
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
                  DepartureDate != null
                      ? DateFormat('yyyy-MM-dd').format(DepartureDate!)
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
                keyboardType: TextInputType.number,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "HH:MM",
                  border: InputBorder.none,
                  // Remove the inner border
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5), // 16 digits + 3 spaces
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberFormatter(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget TaxDatedepatrue(
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
                    DepartureTaxFromDate = pickedDate;
                  });

                  List<String> splitDate =
                      DepartureTaxFromDate.toString().split(" ");

                  __TaxJorneydate = splitDate[0];
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
                  DepartureTaxFromDate != null
                      ? DateFormat('dd-MM-yyyy').format(DepartureTaxFromDate!)
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

  Widget TaxDateBoardging(
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
                    boardgingTaxDate = pickedDate;
                  });

                  List<String> splitDate =
                      boardgingTaxDate.toString().split(" ");

                  __TaxBoardgingDate = splitDate[0];
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
                  boardgingTaxDate != null
                      ? DateFormat('dd-MM-yyyy').format(boardgingTaxDate!)
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

  Widget buildDateFields(String Name) {
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
                    boardgingFromDate = pickedDate;
                  });

                  String Datee = boardgingFromDate.toString();

                  List<String> splitDate = Datee.split(" ");

                  _lodgingfrmdate = splitDate[0];
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
                  boardgingFromDate != null
                      ? DateFormat('yyyy-MM-dd').format(boardgingFromDate!)
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
                    boardgingtoDate = pickedDate;
                  });

                  String Dateee = boardgingtoDate.toString();

                  List<String> splitDatee = Dateee.split(" ");

                  _lodgingToDate = splitDatee[0];
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
                  boardgingtoDate != null
                      ? DateFormat('yyyy-MM-dd').format(boardgingtoDate!)
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

  Widget buildDocumentUploadSection(String label, String descriptionLabel,
      String buttonText, String buttonId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        buildTextField(descriptionLabel, (value) {
          setState(() {
            if (buttonId == "Doc_upload_button") {
              documentDescription = value;
            } else if (buttonId == "Uploadexcel") {
              uploadedExcelName = value;
            }
          });
        }, controller: _uploadfile, keyboardType: TextInputType.text),
        ElevatedButton(
          onPressed: () {
            // Handle file upload action
          },
          child: Text(buttonText,
              style:
                  const TextStyle(fontSize: 12, fontFamily: "TimesNewRoman")),
        ),
      ],
    );
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

        // List<dynamic> jsonResponse = jsonDecode(responseData["data"]);

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

  Future<void> _TravelHotelType() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await EasyLoading.show(status: 'Loading...');

      ServerDetails serverDetails = ServerDetails();
     

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_HotelType';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        await EasyLoading.dismiss();
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelhotel =
              jsonData.map((data) => TravelHotel.fromJson(data)).toList();
        });
      } else {
        await EasyLoading.dismiss();
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      await EasyLoading.dismiss();
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

// class TravelMode {
//   final int kid;
//   final String value;
//   final String text;

//   TravelMode({
//     required this.kid,
//     required this.value,
//     required this.text,
//   });

//   factory TravelMode.fromJson(Map<String, dynamic> json) {
//     return TravelMode(
//         kid: json['kid'], value: json["value"], text: json['text']);
//   }
// }

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

class TravelHotel {
  final int kid;
  final String Name;

  TravelHotel({
    required this.kid,
    required this.Name,
  });

  factory TravelHotel.fromJson(Map<String, dynamic> json) {
    return TravelHotel(
      kid: json['kid'],
      Name: json["text"],
    );
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

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length == 1 && int.parse(text) > 2) {
      // Prevent entering hour > 2 in the first digit.
      return oldValue;
    } else if (text.length == 2) {
      final hour = int.parse(text.substring(0, 2));
      if (hour > 23) {
        return oldValue;
      }
    } else if (text.length == 5) {
      final minute = int.parse(text.substring(3, 5));
      if (minute > 59) {
        return oldValue;
      }
    }
    return newValue;
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', ''); // Remove all spaces
    String formattedText = '';

    for (int i = 0; i < newText.length; i++) {
      if (i % 2 == 0 && i != 0) {
        formattedText += ':'; // Add a space after every 4 digits
      }
      formattedText += newText[i];
    }

    if (formattedText.length == 5) {
      String hours = formattedText;
      List<String> timeParts = hours.split(":");
      String HOURS = timeParts[0];
      String MINUTES = timeParts[1];

// Convert HOURS and MINUTES to integers for comparison
      int hourInt = int.parse(HOURS);
      int minuteInt = int.parse(MINUTES);

      if (hourInt > 23 || minuteInt > 59) {
        // Time.text = "";

        return const TextEditingValue(
          text: '', // Clear the entire field
          selection: TextSelection.collapsed(offset: 0),
        ); // Disallow invalid input
      }
    }

    // Return the formatted value
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
