import 'package:ehr/Dashboard/viewmore/Loan/addressdetails.dart';
import 'package:ehr/Dashboard/viewmore/Loan/kycdetails.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loandatasave/loandatasave.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Loandetails extends StatefulWidget {
  const Loandetails({super.key});

  @override
  State<Loandetails> createState() => _LoandetailsState();
}

class _LoandetailsState extends State<Loandetails> {

  String? selectedPurpose;

  final Map<String, int> loanPurposes = {
    'Debt consolidation': 37,
    'Medical emergencies': 38,
    'Education expenses': 39,
    'Home renovation': 40,
    'Travel expenses': 41,
    'Wedding expenses': 42,
    'Working capital requirements': 43,
    'Business expansion': 44,
    'Operational expenses': 45,
    'Construction of a new home': 46,
  };

  // Loan Details

int loanPurpose = 0;
String loanPurposeValue = '';

TextEditingController empSubmittedOnController = TextEditingController();
  TextEditingController empLoanAmountController = TextEditingController();
  TextEditingController empTenureController = TextEditingController();
  TextEditingController empEmiAmountController = TextEditingController();
  TextEditingController empLoanPurposeController = TextEditingController();
  TextEditingController empSubmittedOnDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        DateTime now = DateTime.now();

    // Format the date as "dd MMMM yyyy" (e.g., "27 January 2025")
    String subMittedOnDate = DateFormat('dd MMMM yyyy').format(now);


    empSubmittedOnDateController.text = subMittedOnDate;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    empSubmittedOnController.dispose();
    empLoanAmountController.dispose();
    empTenureController.dispose();
    empEmiAmountController.dispose();
    empLoanPurposeController.dispose();
    empSubmittedOnDateController.dispose();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
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
                                  child: Text('3',
                                      style: TextStyle(color: Colors.white))),
                            )),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          'Loan Details',
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
                    TextFieldField(
                      label: 'Loan Amount*',
                      keyboardType: TextInputType.number,
                      controller: empLoanAmountController,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    TextFieldField(
                      label: 'Tenure (In Months)*',
                      keyboardType: TextInputType.number,
                      controller: empTenureController,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    TextFieldField(
                      label: 'Comfortable EMI Amount',
                      keyboardType: TextInputType.number,
                      controller: empEmiAmountController,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Loan Purpose*",
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                       DropdownButtonFormField<String>(
                  value: selectedPurpose,
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white, // Dropdown background color
                  ),
                  hint: Text("Select Loan Purpose"),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPurpose = newValue;
              
                      if(selectedPurpose == 'Debt consolidation'){
                        loanPurpose = 37;
                        loanPurposeValue = 'Debt consolidation';
                      }else if(selectedPurpose == 'Medical emergencies'){
                        loanPurpose = 38;
                        loanPurposeValue = 'Medical emergencies';
                      }else if(selectedPurpose == 'Education expenses'){
                        loanPurpose = 39;
                        loanPurposeValue = 'Education expenses';
                      }else if(selectedPurpose == 'Home renovation'){
                        loanPurpose = 40;
                        loanPurposeValue = 'Home renovation';
                      }else if(selectedPurpose == 'Travel expenses'){
                        loanPurpose = 41;
                        loanPurposeValue = 'Travel expenses';
                      }else if(selectedPurpose == 'Wedding expenses'){
                        loanPurpose = 42;
                        loanPurposeValue = 'Wedding expenses';
                      }else if(selectedPurpose == 'Working capital requirements'){
                        loanPurpose = 43;
                        loanPurposeValue = 'Working capital requirements';
                      }else if(selectedPurpose == 'Business expansion'){
                        loanPurpose = 44;
                        loanPurposeValue = 'Business expansion';
                      }else if(selectedPurpose == 'Operational expenses'){
                        loanPurpose = 45;
                        loanPurposeValue = 'Operational expenses';
                      }else if(selectedPurpose == 'Construction of a new home'){
                        loanPurpose = 46;
                        loanPurposeValue = 'Construction of a new home';
                      }
              
              
                      // int loanPurpose = 0;
                      // String loanPurposeValue = '';
                    });
                  },
                  items: loanPurposes.keys.map((String purpose) {
                    return DropdownMenuItem<String>(
                      value: purpose,
                      child: Text(purpose),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                if (selectedPurpose != null)
                  Text('Selected Purpose: $selectedPurpose'),
              ],
                      ),
                     
              
                    const SizedBox(height: 16),
                    TextFieldFieldDate(
                      label: 'Submitted On*',
                      controller: empSubmittedOnDateController,
                    ),
      
                    const SizedBox(height: 16),
      
                    InkWell(
                          onTap: () {
                         
                         //submit();
      
            if (empLoanAmountController.text.isEmpty) {
                _showAlert('Alert', 'Please enter Loan Amount');
                return;
              } else if ( double.parse(empLoanAmountController.text) > 50000) {
                _showAlert('Alert', 'Loan Amount should be less than 50000');
                return;
              } else if (empTenureController.text.isEmpty) {
                _showAlert('Alert', 'Please enter Tenure');
                return;
              }else if(empEmiAmountController.text.isEmpty){
                _showAlert('Alert', 'Please enter Comfortable EMI Amount');
                return;
              }
              else if(loanPurposeValue.isEmpty){
                _showAlert('Alert', 'Please select Loan Purpose');
                return;
              }else{
               Loandatasave.loanAmount = empLoanAmountController.text;
        Loandatasave.tenure= empTenureController.text;
        Loandatasave.emi = empEmiAmountController.text;
        Loandatasave.purpose = loanPurposeValue;
        Loandatasave.purposeType = loanPurpose;
        Loandatasave.submittedDate = empSubmittedOnDateController.text;
      
      
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AddressFormScreen()),
                );
      
      
              }
      
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

}

class TextFieldFieldDate extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const TextFieldFieldDate(
      {super.key,
      required this.label,
      this.keyboardType = TextInputType.text,
      required this.controller});

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
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
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