// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print, unused_element, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TravelRequest extends StatefulWidget {
  @override
  _TravelRequestState createState() => _TravelRequestState();
}

class _TravelRequestState extends State<TravelRequest> {
  final TextEditingController estimateController = TextEditingController();
  final TextEditingController boardingController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalEstimatedController =
      TextEditingController();
  TextEditingController _Advdetail = TextEditingController();
  TextEditingController _purposedetail = TextEditingController();
  TextEditingController _workinhand = TextEditingController();
  TextEditingController _document = TextEditingController();

  TravelType? selectedTravelType;
  List<TravelMode> travelmodes = [];
  List<TravelType> traveltypes = [];
  List<TravelPurpose> travelpurpose = [];
  List<TravelCountry> travelcountry = [];
  List<TravelState> travelstate = [];
  List<TravelEndState> travelEndstate = [];
  List<TravelCity> travelcity = [];
  List<TravelEndCity> travelEndcity = [];
  List<TravelCityClass> travelcityclass = [];
  List<TravelEndCityClass> travelendcityclass = [];
  List<ContactEmail> contactEmail = [];
  TravelMode? selectedModeOfTravel;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TravelPurpose? selectedPurposeVisit;
  String? purposeDetails;
  String? selectedProjectType;
  String? selectedCompanyVehicle;
  TravelState? selectedStartState;
  TravelCountry? selectedStartCountry;
  TravelCity? selectedStartCity;
  TravelCityClass? selectedStartCityClass;
  TravelCountry? selectedEndCountry;
  TravelEndState? selectedEndState;
  TravelEndCity? selectedEndCity;
  TravelEndCityClass? selectedEndCityClass;
  ContactEmail? selectedEmailTo;
  String? selectedTravelWith;
  String? selectedEmpAccompany;
  String? selectedGuestHouse;
  String? traveltype;
  String? travelmode;
  String? purposevisit;
  String? startcity;
  String? endcity;
  String? emailto;
  String? startcityclass;
  String? endcityclass;
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
  String? Valiation;
  String? travelwith;
  String? companyvehicle;
  String? advdetails;
  String? purposedetails;
  String? workinHAND;
  String? documentdescription;

  @override
  void initState() {
    super.initState();
    _TravelMode();
    _TravelType();
    _TravelPurpose();
    _TravelCountry();

    //  _TravelState();
    //  _TravelCity();
    //  _TravelCityClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdownField<TravelType>(
                labelText: "Travel Type*",
                items: traveltypes,
                selectedItem: selectedTravelType,
                onChanged: (value) {
                  setState(() {
                    selectedTravelType = value;
                    traveltype = selectedTravelType?.value.toString();
                  });
                },
                displayText: (item) => item.text,
              ),
              buildDropdownField<TravelMode>(
                labelText: "Preferred Mode of Travel*",
                items: travelmodes,
                selectedItem: selectedModeOfTravel,
                onChanged: (value) {
                  setState(() {
                    selectedModeOfTravel = value;
                    travelmode = selectedModeOfTravel?.kid.toString();
                  });
                },
                displayText: (mode) => mode.text, // Display only the text field
              ),
              buildDateFields(),
              buildDropdownField<TravelPurpose>(
                  labelText: "Purpose of Visit*",
                  items: travelpurpose,
                  selectedItem: selectedPurposeVisit,
                  onChanged: (value) {
                    setState(() {
                      selectedPurposeVisit = value;
                      purposevisit = selectedPurposeVisit?.kid.toString();
                    });
                  },
                  displayText: (mode1) => mode1.text),
              buildTextField("Purpose of Visit Details*", (value) {
                setState(() {
                  purposeDetails = value;
                });
              }, controller: _purposedetail),
              buildDropdownField<String>(
                  labelText: "Company Vehicle",
                  items: ["Yes", "No"],
                  selectedItem: selectedCompanyVehicle,
                  onChanged: (value) {
                    setState(() {
                      selectedCompanyVehicle = value;
                    });
                  },
                  displayText: (Vehicle) => Vehicle),
              // buildDropdownField("Project Type", ["Project Type 1", "Project Type 2"], (value) {
              //   setState(() {
              //     selectedProjectType = value;
              //   });
              // }, selectedProjectType),
              buildSectionLabel("Start Point"),
              buildDropdownField<TravelCountry>(
                  labelText: "Country",
                  items: travelcountry,
                  selectedItem: selectedStartCountry,
                  onChanged: (value) {
                    setState(() {
                      selectedStartCountry = value;
                      _TravelStartState();
                    });
                  },
                  displayText: (country) => country.text),
              buildDropdownField<TravelState>(
                  labelText: "State",
                  items: travelstate,
                  selectedItem: selectedStartState,
                  onChanged: (value) {
                    setState(() {
                      selectedStartState = value;
                      _TravelStartCity();
                    });
                  },
                  displayText: (state) => state.text),
              buildCityAndClassFields("City", "City Class", true),
              buildSectionLabel("End Point"),
              buildDropdownField<TravelCountry>(
                  labelText: "Country",
                  items: travelcountry,
                  selectedItem: selectedEndCountry,
                  onChanged: (value) {
                    setState(() {
                      selectedEndCountry = value;
                      _TravelEndState();
                    });
                  },
                  displayText: (endcountry) => endcountry.text),
              buildDropdownField<TravelEndState>(
                  labelText: "State",
                  items: travelEndstate,
                  selectedItem: selectedEndState,
                  onChanged: (value) {
                    setState(() {
                      selectedEndState = value;
                      _TravelEndCity();
                    });
                  },
                  displayText: (endstate) => endstate.text),
              buildEndCityAndClassFields("City", "City Class", false),
              buildDropdownField<String>(
                  labelText: "Travel With",
                  items: ["Individual", "Group"],
                  selectedItem: selectedTravelWith,
                  onChanged: (value) {
                    setState(() {
                      selectedTravelWith = value;
                    });
                  },
                  displayText: (item2) => item2),
              Visibility(
                visible: selectedTravelWith == "Group",
                child: buildDropdownField<String>(
                    labelText: "Name of Employee Accompanying",
                    items: ["Employee 1", "Employee 2"],
                    selectedItem: selectedEmpAccompany,
                    onChanged: (value) {
                      setState(() {
                        selectedEmpAccompany = value;
                      });
                    },
                    displayText: (item3) => item3),
              ),
              buildDropdownFieldd<ContactEmail>(
                  labelText: "Email To Contact Person",
                  items: contactEmail,
                  selectedItem: selectedEmailTo,
                  onChanged: (value) {
                    setState(() {
                      selectedEmailTo = value;
                      emailto = selectedEmailTo?.EmployeeNo.toString();
                    });
                  },
                  displayText: (item1) =>
                      "${item1.EmployeeNo} - ${item1.EmployeeName}"),
              buildDropdownField<String>(
                  labelText: "GuestHouse",
                  items: ["GuestHouse 1", "GuestHouse 2"],
                  selectedItem: selectedGuestHouse,
                  onChanged: (value) {
                    setState(() {
                      selectedGuestHouse = value;
                    });
                  },
                  displayText: (item) => item),
              buildCheckBoxFields(),
              buildNumericField("Estimated Fare", estimateController, (value) {
                estimatedFare = double.tryParse(value) ?? 0.0;
                calculateTotalEstimatedCost();
              }),
              buildNumericField("Boarding/Lodging Expense", boardingController,
                  (value) {
                estimatedBoardingLodging = double.tryParse(value) ?? 0.0;
                calculateTotalEstimatedCost();
              }),
              buildNumericField("Other Expense", expenseController, (value) {
                otherExpense = double.tryParse(value) ?? 0.0;
                calculateTotalEstimatedCost();
              }),
              buildNumericField(
                "Total Estimated Cost",
                totalEstimatedController,
                (value) {},
                isEnabled: false,
              ),
              buildNumericField(
                "Advance Amount",
                amountController,
                (value) {
                  setState(() {
                    advanceAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),

              buildTextField("Advanced Details*", (value) {
                setState(() {
                  advanceDetails = value;
                });
              }, controller: _Advdetail),
              buildTextField("Current Work in Hand", (value) {
                setState(() {
                  currentWork = value;
                });
              }, controller: _workinhand),
              buildDocumentUploadSection("Attached Document",
                  "Document Description", "Upload", "Doc_upload_button"),
              buildDocumentUploadSection(
                  "Excel Upload", "File Upload", "Choose File", "Uploadexcel"),
              buildProceedButton(),
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

  Widget buildDropdownFieldd<T>({
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: "TimesNewRoman",
            color: Color(0xFF547EC8),
          ),
        ),
        GestureDetector(
          onTap: () => showSearchableDropdown(
              context, items, selectedItem, onChanged, displayText),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem != null ? displayText(selectedItem) : "Select",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TimesNewRoman",
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showSearchableDropdown<T>(
    BuildContext context,
    List<T> items,
    T? selectedItem,
    Function(T?) onChanged,
    String Function(T) displayText,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<T> filteredItems = List.from(items);

        return StatefulBuilder(
          builder: (context, setState) {
            void filterItems(String query) {
              setState(() {
                filteredItems = items
                    .where((item) => displayText(item)
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            }

            return AlertDialog(
              title: Text("Select Employee Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(hintText: "Search"),
                    onChanged: filterItems,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        T item = filteredItems[index];
                        return ListTile(
                          title: Text(displayText(item)),
                          leading: Radio<T>(
                            value: item,
                            groupValue: selectedItem,
                            onChanged: (value) {
                              onChanged(value);
                              Navigator.of(context).pop();
                            },
                          ),
                          onTap: () {
                            onChanged(item);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesNewRoman",
              color: Color(0xFF547EC8)),
        ),
        DropdownButton<T>(
          isExpanded: true,
          value: selectedItem,
          hint: const Text("Select",
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "TimesNewRoman",
                  color: Colors.black)),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayText(item),
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "TimesNewRoman",
                      color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildTextField(String labelText, Function(String) onChanged,
      {bool isEnabled = true, required TextEditingController controller}) {
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
        TextFormField(
          enabled: isEnabled,
          controller: controller,

          decoration: const InputDecoration(
            hintText: "",
            hintStyle: TextStyle(
                fontSize: 12, color: Colors.black, fontFamily: "TimesNewRoman"),
          ),
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontFamily: "TimesNewRoman"),

          keyboardType: TextInputType.text,
          // onChanged: onChanged,
          // controller: TextEditingController(text: initialValue),
        ),
      ],
    );
  }

  Widget buildNumericField(String labelText, TextEditingController controller,
      Function(String) onChanged,
      {bool isEnabled = true}) {
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
        TextFormField(
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

  Widget buildDateFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "From Date",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
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
                    selectedFromDate = pickedDate;
                  });
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
                  selectedFromDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedFromDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 12,
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
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
                    selectedToDate = pickedDate;
                  });
                }
                if (selectedToDate!.isBefore(selectedFromDate!)) {
                  _showAlertDialogg("Alert",
                      "To Date must be greater than or equal to From Date");
                  selectedToDate = selectedFromDate;
                  return;
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
                  selectedToDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedToDate!)
                      : 'Select Date',
                  style: const TextStyle(
                      fontSize: 12,
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
            selectedItem: selectedStartCity,
            onChanged: (value) {
              setState(() {
                selectedStartCity = value;
                startcity = selectedStartCity?.kid.toString();

                _TravelStartCityClass();
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
              selectedItem: selectedStartCityClass,
              onChanged: (value) {
                setState(() {
                  selectedStartCityClass = value;
                  startcityclass = selectedStartCityClass?.kid.toString();
                });
              },
              displayText: (cityClass) => cityClass.text),
        ),
      ],
    );
  }

  Widget buildEndCityAndClassFields(
      String cityLabel, String cityClassLabel, bool isStart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildDropdownField<TravelEndCity>(
            labelText: cityLabel,
            items: travelEndcity,
            selectedItem: selectedEndCity,
            onChanged: (value) {
              setState(() {
                selectedEndCity = value;
                endcity = selectedEndCity?.kid.toString();
                _TravelEndCityClass();
              });
            },
            displayText: (city) => city.text,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: buildDropdownField<TravelEndCityClass>(
              labelText: cityClassLabel,
              items: travelendcityclass,
              selectedItem: selectedEndCityClass,
              onChanged: (value) {
                setState(() {
                  selectedEndCityClass = value;
                  endcityclass = selectedEndCityClass?.kid.toString();
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: "TimesNewRoman",
            color: Color(0xFF547EC8)),
      ),
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
        }, controller: _document),
        ElevatedButton(
          onPressed: () {
            uploadDocument();
          },
          child: Text(buttonText,
              style:
                  const TextStyle(fontSize: 12, fontFamily: "TimesNewRoman")),
        ),
      ],
    );
  }

  Widget buildProceedButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Proceed();
        },
        child: const Text("Proceed",
            style: TextStyle(fontSize: 12, fontFamily: "TimesNewRoman")),
      ),
    );
  }

  Future<void> uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      // FormData formData = FormData.fromMap({
      //   "file": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      // });

      // try {
      //   Dio dio = Dio();
      //   var response = await dio.post('YOUR_UPLOAD_ENDPOINT', data: formData);
      //   print('Upload successful: ${response.data}');
      // } catch (e) {
      //   print('Upload failed: $e');
      // }
    }
  }

  Future<void> _TravelMode() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      // ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_TravelMode';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          // travelmodes = jsonData.map((data) => TravelMode.fromJson(data).text).toList();

          travelmodes =
              jsonData.map((data) => TravelMode.fromJson(data)).toList();
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

  Future<void> _TravelType() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      // ServerDetails serverDetails = ServerDetails();

      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=travelType';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        await EasyLoading.dismiss();
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
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      // ServerDetails serverDetails = ServerDetails();

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
    _emailtocontact();
  }

  Future<void> _TravelCountry() async {
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();

      // ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_cnt';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelcountry =
              jsonData.map((data) => TravelCountry.fromJson(data)).toList();
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

  Future<void> _TravelStartState() async {
    try {
      String countryid = selectedStartCountry!.kid.toString();
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      // ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=State&&CountryId=$countryid';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelstate =
              jsonData.map((data) => TravelState.fromJson(data)).toList();
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

  Future<void> _TravelEndState() async {
    try {
      String countryid = selectedEndCountry!.kid.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=State&&CountryId=$countryid';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelEndstate =
              jsonData.map((data) => TravelEndState.fromJson(data)).toList();
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

  Future<void> _TravelStartCity() async {
    try {
      String stateid = selectedStartState!.kid.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=City&&StateId=$stateid';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelcity =
              jsonData.map((data) => TravelCity.fromJson(data)).toList();
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

  Future<void> _TravelEndCity() async {
    try {
      String stateid = selectedEndState!.kid.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=City&&StateId=$stateid';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelEndcity =
              jsonData.map((data) => TravelEndCity.fromJson(data)).toList();
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

  Future<void> _TravelStartCityClass() async {
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

  Future<void> _TravelEndCityClass() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_cityclass';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          travelendcityclass = jsonData
              .map((data) => TravelEndCityClass.fromJson(data))
              .toList();
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

  Future<void> _emailtocontact() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=emailtocontactperson';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          contactEmail =
              jsonData.map((data) => ContactEmail.fromJson(data)).toList();
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

  Future<void> Proceed() async {
    try {
      if (traveltype == null || traveltype == "") {
        _showAlertDialogg("Alert", "Please Select start City ");
        return;
      } else if (travelmode == null || travelmode == "") {
        _showAlertDialogg("Alert", "Please Select Travel Mode ");
        return;
      } else if (selectedFromDate == null || selectedFromDate == "") {
        _showAlertDialogg("Alert", "Please Select To Date");
        return;
      } else if (selectedToDate == null || selectedToDate == "") {
        _showAlertDialogg("Alert", "Please Select From Date");
        return;
      } else if (purposevisit == null || purposevisit == "") {
        _showAlertDialogg("Alert", "Please Select Purpose Visit");
        return;
      } else if (_purposedetail.text == null || _purposedetail.text == "") {
        _showAlertDialogg("Alert", "Please Select Purpose Details");
        return;
      } else if (selectedCompanyVehicle == null ||
          selectedCompanyVehicle == "") {
        _showAlertDialogg("Alert", "Please Select Company Vehicle");
        return;
      } else if (selectedStartCountry == null || selectedStartCountry == "") {
        _showAlertDialogg("Alert", "Please Select Start Country");
        return;
      } else if (selectedStartState == null || selectedStartState == "") {
        _showAlertDialogg("Alert", "Please Select Start State");
        return;
      } else if (startcity == null || startcity == "") {
        _showAlertDialogg("Alert", "Please Select Start City ");
        return;
      } else if (startcityclass == null || startcityclass == "") {
        _showAlertDialogg("Alert", "Please Select City Class");
        return;
      } else if (selectedEndCountry == null || selectedEndCountry == "") {
        _showAlertDialogg("Alert", "Please Select End Country");
        return;
      } else if (selectedEndState == null || selectedEndState == "") {
        _showAlertDialogg("Alert", "Please Select End State");
        return;
      } else if (endcity == null || endcity == "") {
        _showAlertDialogg("Alert", "Please Select End City ");
        return;
      } else if (endcityclass == null || endcityclass == "") {
        _showAlertDialogg("Alert", "Please Select End City Class");
        return;
      } else if (selectedTravelWith == null || selectedTravelWith == "") {
        _showAlertDialogg("Alert", "Please Select Travel With");
        return;
      } else if (estimatedFare == null || estimatedFare == "") {
        _showAlertDialogg("Alert", "Please Enter Estimate Fare");
        return;
      } else if (estimatedBoardingLodging == null ||
          estimatedBoardingLodging == "") {
        _showAlertDialogg("Alert", "Please Enter Estimate Boarding Fare");
        return;
      } else if (otherExpense == null || otherExpense == "") {
        _showAlertDialogg("Alert", "Please Enter Other Expense");
        return;
      } else if (advanceAmount == null || advanceAmount == "") {
        _showAlertDialogg("Alert", "Please Enter Advance Amount");
        return;
      } else if (_Advdetail.text == null || _Advdetail.text == "") {
        _showAlertDialogg("Alert", "Please Enter Advance Details");
        return;
      } else if (_workinhand.text == null || _workinhand.text == "") {
        _showAlertDialogg("Alert", "Please Enter Work in Hand");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String managerid = prefs.getString('ManagerID') ?? '';
      String userId = prefs.getString("userID") ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=TravelValidation&EmpKid=$empKid&FromDate=$selectedFromDate&ToDate=$selectedToDate';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        var content = response.body;
        var responseList = json.decode(content) as List;

        var firstItem = responseList[0];
        String empid = firstItem['Column1'].toString();
        if (double.parse(empid) > 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Alert"),
                  content: const Text("Date of travel is already taken"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              });
          return;
        } else {
          if (selectedTravelWith == "Individual") {
            travelwith = "I";
          } else {
            travelwith = "G";
          }
          if (selectedCompanyVehicle == "Yes") {
            companyvehicle = "Y";
          } else {
            companyvehicle = "N";
          }
          advanceDetails = _Advdetail.text;
          purposedetails = _purposedetail.text;
          workinHAND = _workinhand.text;
          documentDescription = _document.text;

          String restUrl =
              '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=Travelrequest&EmpId=$empKid&tripCity=$startcityclass&startDate=$selectedFromDate&endDate=$selectedToDate&Empcompvech=$companyvehicle&gustHID=0&eRemark=$purposedetails&projecttype=1&Emp4Mail=$emailto,&workhand=$workinHAND&empcode=$userId&trvpurVisitDet=$purposedetails&GrpType=$travelwith&ManagerID=$managerid&ModeofTravel=$travelmode&AdvDet=$advanceDetails&estimateOther=$otherExpense&AdAmt=$advanceAmount&estimateFare=$estimatedFare&estimateBoarding=$estimatedBoardingLodging&PurposeofVisit=$purposevisit&travelType=$traveltype&fromCity=$startcity&toCity=$endcity&Xml=&DocFiles=';

          try {
            // Replace spaces in the URL
            Uri uri = Uri.parse(restUrl.replaceAll('', ''));

            // Send the GET request
            final response = await http.get(uri);

            if (response.statusCode == 200) {
              // Success, handle response
              String content = response.body;

              //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

              _showAlertDialog("Alert", content);

              //  Navigator.pushReplacement(
              //       context, MaterialPageRoute(builder: (context) => Dashboard()));
            } else {
              // Handle the error
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${response.statusCode}")));
            }
          } catch (e) {
            // Handle any exceptions
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        }
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showAlertDialogg(String title, String message) {
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
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

class TravelEndState {
  final int kid;
  final String value;
  final String text;

  TravelEndState({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelEndState.fromJson(Map<String, dynamic> json) {
    return TravelEndState(
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

class TravelEndCity {
  final int kid;
  final String value;
  final String text;

  TravelEndCity({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelEndCity.fromJson(Map<String, dynamic> json) {
    return TravelEndCity(
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

class TravelEndCityClass {
  final int kid;
  final String value;
  final String text;

  TravelEndCityClass({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory TravelEndCityClass.fromJson(Map<String, dynamic> json) {
    return TravelEndCityClass(
        kid: json['kid'], value: json["value"], text: json['text']);
  }
}

class ContactEmail {
  final String EmployeeNo;
  final String EmployeeName;

  ContactEmail({
    required this.EmployeeNo,
    required this.EmployeeName,
  });

  factory ContactEmail.fromJson(Map<String, dynamic> json) {
    return ContactEmail(
      EmployeeNo: json['Employee No'],
      EmployeeName: json["Employee Name"],
    );
  }
}

class Tvalidate {
  final int Column1;

  Tvalidate({
    required this.Column1,
  });

  factory Tvalidate.fromJson(Map<String, dynamic> json) {
    return Tvalidate(
      Column1: json['Column1'],
    );
  }
}
