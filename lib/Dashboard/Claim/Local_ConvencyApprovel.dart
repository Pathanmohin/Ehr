
// import 'package:ehr/Dashboard/Claim/Local_Convency_Dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class LocalApproval extends StatefulWidget {
//   const LocalApproval({super.key});

//   @override
//   State<StatefulWidget> createState() => _LocalApproval();
// }

// class _LocalApproval extends State<LocalApproval> {
//   InAppWebViewController? webViewController;
//   bool isLoading = true; // To track loading state

//   @override
//   void initState() {
//     super.initState();
//     _showLoader();
//   }

//   void _showLoader() async {
//     await Future.delayed(const Duration(seconds: 3));
//     setState(() {
//       isLoading = false; // Stop showing the loader after 2 seconds
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return MediaQuery(
//         data: MediaQuery.of(context)
//             .copyWith(textScaler: const TextScaler.linear(1.1)),
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: const Text(
//               "Local Conveyance Approval",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: "TimesNewRoman",
//                 fontSize: 18,
//               ),
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               color: Colors.white,
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LocalConvencyClaim()),
//                 );
//               },
//             ),
//             backgroundColor: Colors.blue,
//           ),
//           body: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width *
//                         5.0, // 90% of screen width
//                     height: MediaQuery.of(context).size.height *
//                         5.0, // 80% of screen height
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(0),
//                     ),
//                     child: InAppWebView(
//                       initialUrlRequest: URLRequest(
//                         url: WebUri(
//                             'http://192.168.1.113/Mobile/Mobile/MobileAuthication.aspx?Empkid=15771&Type=LocalConv'),
//                       ),
//                       initialSettings: InAppWebViewSettings(
//                         javaScriptEnabled: true,
//                         supportZoom: false,
//                         builtInZoomControls: true,
//                         displayZoomControls: true,
//                         verticalScrollBarEnabled: true,
//                         overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
//                         pageZoom: 20,
//                         textZoom: 180,
//                       ),
//                       onWebViewCreated: (controller) {
//                         webViewController = controller;

//                         controller.addJavaScriptHandler(
//                             handlerName: "webviewbackbutton",
//                             callback: (args) {
//                               // Here you receive all the arguments from the JavaScript side
//                               // that is a List<dynamic>
//                               print("From the JavaScript side:");
//                               print(args);

//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => LocalConvencyClaim()),
//                               );
//                               // return null;
//                               // return args.reduce((curr, next) => curr + next);
//                             });
//                       },
//                       onLoadStop: (controller, url) async {
//                         // Inject JavaScript to set zoom scale to 200%
//                         await controller.evaluateJavascript(
//                             source: "document.body.style.zoom = '2';");
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               if (isLoading)
//                 Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.blue,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
