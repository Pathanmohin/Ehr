import 'dart:convert';

import 'package:ehr/Dashboard/viewmore/Loan/Model/applicationceatemodel.dart';
import 'package:ehr/Dashboard/viewmore/Loan/additionaldetails.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandatasave/loandatasave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  String? _addressType;
  String? _addressSubtype;
  String? _state;
  String? _district;
  String? _country;

  bool landMarkEdit = true;
  bool pincodeEdit = true;
  bool stateEdit = true;
  bool cityEdit = true;
  bool tehsilEdit = true;
  bool countoryEdit = true;
  bool addEdit = true;

  // Text editing controllers
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _tasilController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();

  AddressType? addressType;
  AddressType? addressSubType;

  // type

  String addressTypeCheck = '';
  int addressValueCheck = 0;
  String addressSubTypeCheck = ''; 
  int addressSubValueCheck = 0; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  void dispose() {
    _longitudeController.dispose();
    _latitudeController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _tasilController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    super.dispose();
  }

     final _addressTypeOptions = [
      AddressType(label: 'Owned', value: '0'),
      AddressType(label: 'Parental', value: '1'),
      AddressType(label: 'Rental', value: '2'),
    ];

    final _addressSubtypeOptions = [
      AddressType(label: 'Current', value: '0'),
      AddressType(label: 'Permanent', value: '1'),
      AddressType(label: 'Office', value: '2'),
    ];

  @override
  Widget build(BuildContext context) {
    // Dropdown options
 

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
            padding: const EdgeInsets.all(16.0),
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
                                child: Text('4',
                                    style: TextStyle(color: Colors.white))),
                          )),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Text(
                        'Address Details',
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
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Address Type*',
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
                    child: DropdownButton<AddressType>(
                      dropdownColor: Colors.white,
                      value: addressType,
                      hint: const Text(
                        'Select Address Type',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: _addressTypeOptions.map((AddressType obj) {
                        return DropdownMenuItem<AddressType>(
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
                          addressType = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onAddressType(newValue!);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Sub Address Type*',
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
                    child: DropdownButton<AddressType>(
                      dropdownColor: Colors.white,
                      value: addressSubType,
                      hint: const Text(
                        'Select Sub Address Type',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: _addressSubtypeOptions.map((AddressType obj) {
                        return DropdownMenuItem<AddressType>(
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
                          addressSubType = newValue;
                        });
                        // // Call your method here, similar to SelectedIndexChanged
                        onAddressSubType(newValue!);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Address Line 1*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _addressLine1Controller,
                  readOnly: addEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Address Line 2*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _addressLine2Controller,
                  readOnly: addEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Land Mark',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _landmarkController,
                  readOnly: landMarkEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Pin code*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _pincodeController,
                  readOnly: pincodeEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'State *',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _stateController,
                  readOnly: stateEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'City/Village*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _cityController,
                  readOnly: cityEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Mandal/Tehsil',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _tasilController,
                  readOnly: tehsilEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Country*',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _latitudeController,
                  readOnly: countoryEdit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    addDetails();
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
        ),
      ),
    );
  }

  void onAddressType(AddressType addressGetType) {
    String addLable = addressGetType.label;
    String addTypeValue = addressGetType.value;

      addressTypeCheck = addLable;
      addressValueCheck = int.parse(addTypeValue);
 

     AddressType? addressType;
     addressSubType = addressType;
   addressSubTypeCheck = ''; 
   addressSubValueCheck = 0;

    _longitudeController.text = '';
    _latitudeController.text = '';
    _addressLine1Controller.text = '';
    _addressLine2Controller.text = '';
    _landmarkController.text = '';
    _pincodeController.text = '';
    _cityController.text = '';
    _tasilController.text = '';
    _countryController.text = '';
    _stateController.text = '';
   
  }

    void onAddressSubType(AddressType addressType) {
    String addLable = addressType.label;
    String addTypeValue = addressType.value;

   addressSubTypeCheck = addLable; 
   addressSubValueCheck = int.parse(addTypeValue);

    if(addLable == 'Current'){
              _longitudeController.text = '';
    _latitudeController.text = '';
    _addressLine1Controller.text = '';
    _addressLine2Controller.text = '';
    _landmarkController.text = '';
    _pincodeController.text = '';
    _cityController.text = '';
    _tasilController.text = '';
    _countryController.text = '';
    _stateController.text = '';
       getData('T');
    }else if(addLable == 'Permanent'){
              _longitudeController.text = '';
    _latitudeController.text = '';
    _addressLine1Controller.text = '';
    _addressLine2Controller.text = '';
    _landmarkController.text = '';
    _pincodeController.text = '';
    _cityController.text = '';
    _tasilController.text = '';
    _countryController.text = '';
    _stateController.text = '';
       getData('P');
    }else{

    _longitudeController.text = '';
    _latitudeController.text = '';
    _addressLine1Controller.text = '';
    _addressLine2Controller.text = '';
    _landmarkController.text = '';
    _pincodeController.text = '';
    _cityController.text = '';
    _tasilController.text = '';
    _countryController.text = '';
    _stateController.text = '';
       getData('R');

    }

         
    }

  Future<void> getData(String Type) async {
    EasyLoading.show(status: 'loading...');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String empKid = prefs.getString('EmpKid') ?? '';

    String apiUrl =
        "http://192.168.1.113/Mobile/ServiceData.aspx?callFor=Employeeaddress&empkid=15745&Addflag=$Type";
    EasyLoading.dismiss();
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse.toString().isNotEmpty) {
        final List<dynamic> data = json.decode(response.body);

        var getValue = data[0];
        String add = getValue['Addresssubtype'].toString();
        String addType = getValue['Address'].toString();
        String pinCode = getValue['Pincode'].toString();
        String village = getValue['Village'].toString();
        String country = getValue['Country'].toString();
        String tehsil = getValue['tehsil'].toString();
        String city = getValue['City'].toString();
        String state = getValue['State'].toString();
        String landMark = getValue['LandMark'].toString();


        if (addType.isEmpty || addType == "null") {
          addEdit = false;
        }else{
                  _addressLine1Controller.text = addType;
        _addressLine2Controller.text = addType;

        }

        if (landMark.isEmpty || landMark == "null") {
          landMarkEdit = false;
        } else {
          _landmarkController.text = landMark;
        }

        if (pinCode.isEmpty || pinCode == "null") {
          pincodeEdit = false;
        } else {
          _pincodeController.text = pinCode;
        }

        if (state.isEmpty || state == "null") {
          stateEdit = false;
        } else {
          _stateController.text = state;
        }

        if (city.isEmpty || city == "null") {
          _cityController.text = village;
        } else {
          _cityController.text = city;
        }

        if (tehsil.isEmpty || tehsil == "null") {
          landMarkEdit = false;
        } else {
          _tasilController.text = tehsil;
        }

        if (country.isEmpty || country == "null") {
          countoryEdit = false;
          _countryController.text = "India";
          
        } else {
          _countryController.text = country;
        }

        setState(() {});

        print(data);

        EasyLoading.dismiss();
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
  
  void addDetails() {


        if(addressTypeCheck.isEmpty){

          _showAlert('Alert', "Please Select Address Type");
          return;

        }else if(addressSubTypeCheck.isEmpty){
          _showAlert('Alert', "Please Select Sub Address Type");
          return;

        }else if(_addressLine1Controller.text.isEmpty){
          _showAlert('Alert', "Please Enter Address 1 Type");
          return;
        }else if(_addressLine2Controller.text.isEmpty){
          _showAlert('Alert', "Please Enter Address 2 Type");
          return;
        }else if(_landmarkController.text.isEmpty){
          _showAlert('Alert', "Please Enter Land Mark Type");
          return;
        }else if(_pincodeController.text.isEmpty){
          _showAlert('Alert', "Please Enter Pin code");
          return;
        }else if(_stateController.text.isEmpty){
          _showAlert('Alert', "Please Enter State");
          return;
        }else if(_cityController.text.isEmpty){
          _showAlert('Alert', "Please Enter City/Village");
          return;
        }else if(_tasilController.text.isEmpty){
          _showAlert('Alert', "Please Enter Mandal/Tehsil");
          return;          
        }else if(_countryController.text.isEmpty){
           _showAlert('Alert', "Please Enter Country");
          return;         
        }else{
         
         Loandatasave.addSubtypeValue = addressValueCheck;
         Loandatasave.addresstypeValue = addressSubValueCheck;
         Loandatasave.add1 = _addressLine1Controller.text;
         Loandatasave.add2 = _addressLine2Controller.text;
         Loandatasave.long = _longitudeController.text;
         Loandatasave.lat = _latitudeController.text;
         Loandatasave.landmark = _landmarkController.text;
         Loandatasave.postcode = _pincodeController.text;
         Loandatasave.city = _cityController.text;
         Loandatasave.state = _stateController.text;
         Loandatasave.country = _countryController.text;
         Loandatasave.tehsil = _tasilController.text;

          Navigator.push(context,MaterialPageRoute(builder: (context) => const Additionaldetails()));
        }
  }


}
