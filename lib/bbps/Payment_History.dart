import 'dart:convert';

import 'package:ehr/app.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:ehr/bbps/paymentHistory_Data.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {


   List<paymentDataH> histroyData = [];

  final List<Transaction> transactions = [
    Transaction(
      cardNumber: '1234 5678 9012 3456',
      amount: 1500.75,
      date: '2024-12-10',
      paymentMode: 'Credit Card',
      transactionId: 'TXN123456',
    ),
    Transaction(
      cardNumber: '9876 5432 1098 7654',
      amount: 299.99,
      date: '2024-12-11',
      paymentMode: 'UPI',
      transactionId: 'TXN123457',
    ),
    Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
     Transaction(
      cardNumber: '1111 2222 3333 4444',
      amount: 50.00,
      date: '2024-12-12',
      paymentMode: 'Cash',
      transactionId: 'TXN123458',
    ),
  ];

  List<Transaction> filteredTransactions = [];
  String searchQuery = '';

  @override
  void initState() {
    getPaymentHistory();
    super.initState();
    filteredTransactions = transactions; // Initially, show all transactions
  }

  void filterTransactions(String query) {
    final filtered = transactions.where((transaction) {
      final txnIdMatch = transaction.transactionId.contains(query);
      final paymentModeMatch =
          transaction.paymentMode.toLowerCase().contains(query.toLowerCase());
      return txnIdMatch || paymentModeMatch;
    }).toList();

    setState(() {
      searchQuery = query;
      filteredTransactions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text(
              "Transaction Deatils",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF0057C2),

            //                   BackgroundColor="#FFFAF9F9"

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                    width: 50,
                    height: 45,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(100.0),
                        color: Colors.white),
                    child: Image.asset("assets/images/Blogo.jpg")),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BBPS()),
                );
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              //change your color here
            ),
          ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Transaction ID or Payment Mode',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterTransactions,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return Card(
                  color: const Color(0xFF0057C2),
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Card Number: ${transaction.cardNumber}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        SizedBox(height: 4),
                        Text(
                          'Amount: ₹${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Date: ${transaction.date}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Payment Mode: ${transaction.paymentMode}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Transaction ID: ${transaction.transactionId}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

   Future<void> getPaymentHistory() async {
    try {

      String apiUrl =
          "${AppCongifP.apiurllinkBBPS}/rest/AccountService/PaymentGateWayTrndetails";

      String jsonString = jsonEncode({});

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
      };

      final parameters = <String, dynamic>{
        "data": jsonString,
      };

      try {
        // Make POST request
        var response = await http.post(
          Uri.parse(apiUrl),
          body: jsonString,
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
        );

    
        if (response.statusCode == 200) {
         
         {
            final data = json.decode(response.body) as List<dynamic>;

            for (int i = 0; i < data.length; i++) {
              var listData = data[i];

              paymentDataH vObject = paymentDataH();

              vObject.ammount = listData["Amount"].toString();
              vObject.dataee = listData["Date"].toString();
              vObject.paymentmode = listData["PaymnetMode"].toString();
              vObject.taxnidd = listData["Transactionid"].toString();
             // vObject.CutomerMobileNumber = listData["crdrd_mobile"].toString();

              histroyData.add(vObject);
            }

           // CreditCARD.paymentDataa = paymentDataa;

           
          }  {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => CreditCard()));
          }

        } else {
          return;
        }
      } catch (error) {
        return;
      }
    } catch (e) {
      return;
    }
  }
}

class Transaction {
  final String cardNumber;
  final double amount;
  final String date;
  final String paymentMode;
  final String transactionId;

  Transaction({
    required this.cardNumber,
    required this.amount,
    required this.date,
    required this.paymentMode,
    required this.transactionId,
  });
}
