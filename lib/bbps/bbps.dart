import 'dart:convert';


import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:ehr/bbps/DTH/DTHRecharge.dart';
import 'package:ehr/bbps/FastTagRecharge/fasttage.dart';
import 'package:ehr/bbps/LPG_Booking/LPG.dart';
import 'package:ehr/bbps/Payment_History.dart';
import 'package:ehr/bbps/Water/WaterRecharge.dart';
import 'package:ehr/bbps/bbpsmenu.dart';
import 'package:ehr/bbps/creditcard/CeditSvaeData.dart';
import 'package:ehr/bbps/creditcard/CreditCard.dart';
import 'package:ehr/bbps/creditcard/ShowAddCReditCard.dart';
import 'package:ehr/bbps/model/information.dart';
import 'package:ehr/bbps/model/modeilcredit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BBPS extends StatefulWidget {
  const BBPS({super.key});
  @override
  State<StatefulWidget> createState() => _BBPSState();
}

class CardItem {
  final String cardNumber;
  final String billerId;
  final String bankName;
  final String userId;
  final String mobile;

  CardItem({
    required this.cardNumber,
    required this.billerId,
    required this.bankName,
    required this.userId,
    required this.mobile,
  });
}

class _BBPSState extends State<BBPS> {
  List<CardItem> cardItemss = [];
  List<CREDITSVAEDATA> CARDNUMBER = [];

  @override
  void initState() {
    super.initState();

   // saftyTipssss();
  }
 

  Future<bool> _onBackPressed() async {
    // Use Future.delayed to simulate async behavior
    await Future.delayed(Duration(milliseconds: 1));

    // Perform the navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );

    // Prevent the default back button behavior
    return false;
  }

  static const mRec = IconData(0xf62e, fontFamily: 'MaterialIcons');
  static const mPost = IconData(0xe50d, fontFamily: 'MaterialIcons');
  static const elC = IconData(0xe230, fontFamily: 'MaterialIcons');
  static const dth = IconData(0xf0562, fontFamily: 'MaterialIcons');
  static const water = IconData(0xf05a2, fontFamily: 'MaterialIcons');
  static const Fastag = IconData(0xe870, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          //backgroundColor: Colors.white,
          backgroundColor: const Color(0xFFFAF9F9),
          appBar: AppBar(
            title: Text(
              "Pay Bills",
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
                  MaterialPageRoute(builder: (context) => Dashboard()),
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
          body: WillPopScope(
            onWillPop: _onBackPressed,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Recharge and Pay Bills",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BBPSMenu(iconCode: mRec, title: "Mobile Recharge"),
                          BBPSMenu(iconCode: mPost, title: "Mobile PostPaid"),
                          BBPSMenu(iconCode: elC, title: "Electricity"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Image.asset('assets/images/tollroad.png'),

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DTHRecharhemobile()));
                                },
                                child: Icon(
                                  dth,
                                  color: const Color(0xFF0057C2),
                                  size: 42,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WaterRecharge()));
                                },
                                child: Icon(
                                  water,
                                  color: const Color(0xFF0057C2),
                                  size: 42,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FastTag()));
                                },
                                child: Icon(
                                  Icons.electric_car,
                                  color: const Color(0xFF0057C2),
                                  size: 42,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Image.asset('assets/images/tollroad.png'),

                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DTHRecharhemobile()));
                                    },
                                    child: Text(
                                      "DTH",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WaterRecharge()));
                                    },
                                    child: Text(
                                      "Water",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FastTag()));
                                    },
                                    child: Text(
                                      "FASTag",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      height: 100,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Image.asset('assets/images/tollroad.png'),

                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 Boradbandbill()));
                              //   },
                              //   child: Image.asset(
                              //     "assets/images/router.png",
                              //     height: 42,
                              //     color: Color(0xFF0057C2),
                              //   ),
                               
                              // ),
                               InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LPG()));
                                },
                                child: Icon(
                                  Icons.propane_tank,
                                  color: const Color(0xFF0057C2),
                                  size: 42,
                                ),
                              ),

                              InkWell(
                                onTap: () async {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CreditCard()));
                                  // final prefs =
                                  //     await SharedPreferences.getInstance();

                                  // prefs.setString("Type", "Billpaypast");

                                  GetBillerNamee();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreditCard()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Icon(
                                    Icons.credit_card,
                                    color: const Color(0xFF0057C2),
                                    size: 42,
                                  ),
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => CABLETV()));
                              //   },
                              //   child: Icon(
                              //     Icons.router,
                              //     color: const Color(0xFF0057C2),
                              //     size: 52,
                              //   ),
                              // ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Image.asset('assets/images/tollroad.png'),

                                // InkWell(
                                //     onTap: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   Boradbandbill()));
                                //     },
                                //     child: Text(
                                //       "Boradband Bill",
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     )),
                                 InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LPG()));
                                    },
                                    child: Text(
                                      "LPG Booking",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreditCard()));

                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      prefs.setString("Type", "BillPay");

                                     GetBillerNamee();
                                    },
                                    child: Text(
                                      "Credit Card",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                // InkWell(
                                //     onTap: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => FastTag()));
                                //     },
                                //     child: Text(
                                //       "Cable Tv",
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // Container(
                    //   height: 100,
                    //   width: 450,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.2),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //         offset: const Offset(0, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Row(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           // Image.asset('assets/images/tollroad.png'),

                    //           // InkWell(
                    //           //   onTap: () {
                    //           //     Navigator.push(
                    //           //         context,
                    //           //         MaterialPageRoute(
                    //           //             builder: (context) => Education()));
                    //           //   },
                    //           //   child: Icon(
                    //           //     Icons.school,
                    //           //     color: const Color(0xFF0057C2),
                    //           //     size: 42,
                    //           //   ),
                    //           // ),

                    //           InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LPG()));
                    //             },
                    //             child: Icon(
                    //               Icons.propane_tank,
                    //               color: const Color(0xFF0057C2),
                    //               size: 42,
                    //             ),
                    //           ),

                    //           InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => pipedGass()));
                    //             },
                    //             child: Icon(
                    //               Icons.gas_meter,
                    //               color: const Color(0xFF0057C2),
                    //               size: 42,
                    //             ),
                    //           ),
                    //           InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => Education()));
                    //             },
                    //             child: Icon(
                    //               Icons.school,
                    //               color: const Color(0xFF0057C2),
                    //               size: 42,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(right: 10),
                    //         child: Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             // Image.asset('assets/images/tollroad.png'),

                    //             // Text("Education"),
                    //             InkWell(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) => LPG()));
                    //                 },
                    //                 child: Text(
                    //                   "LPG Booking",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //             // Text("LPG Cylinder"),
                    //             InkWell(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) =>
                    //                               pipedGass()));
                    //                 },
                    //                 child: Text(
                    //                   "Piped Gas",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //             InkWell(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) =>
                    //                               Education()));
                    //                 },
                    //                 child: Text(
                    //                   "Eduaction",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 )),
                    //           ],
                    //         ),
                    //       ),
                          
                    //     ],
                        
                    //   ),
                      
                    // ),

                      
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                MaterialPageRoute(builder: (context) => TransactionListScreen())); // Add your forgot password functionality here
                              },
                              child: const Text('Payment History', style: TextStyle(color: Colors.black, fontSize: 17, 
                              fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),),
                            ),
                          ),
               
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                        'assets/images/BharatLogo.jpg', // Replace with your image path
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
              ),
            
                   
                  ],
             
             
                  
                ),
                
              ),
              
            ),
            
          ),
        ),
      );
    });
  }

  // Vikas Method ---------------------


  Future<void> GetBillerNamee() async {
    try {

     // Loader.show(context, progressIndicator: CircularProgressIndicator());
        
      // API endpoint URL

      String apiUrl =
          "${AppCongifP.apiurllinkBBPS}/rest/AccountService/UserFetchCreditCardDetails";

      String jsonString = jsonEncode({"userid": AppInfoLogin.Userid});

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

        // Check if request was successful
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData['Result'] == "Success") {
            List<dynamic> dataList = jsonDecode(responseData['Data']);

            for (int i = 0; i < dataList.length; i++) {
              var listData = dataList[i];

              CREDITSVAEDATA vObject = CREDITSVAEDATA();

              vObject.CREDITCARDNUMBER = listData["crdrd_crdno"].toString();
              vObject.BillerID = listData["crdr_billerid"].toString();
              vObject.BANKNAME = listData["crdr_bnkname"].toString();
              vObject.CustomerName = listData["crdrd_name"].toString();
              vObject.CutomerMobileNumber = listData["crdrd_mobile"].toString();

              CARDNUMBER.add(vObject);
            }

            CreditCARD.CARDNUMBER = CARDNUMBER;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowCreditCard(),
              ),
            );
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreditCard()));
          }

          // Refresh UI after loading data
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
