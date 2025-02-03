
import 'package:ehr/Dashboard/viewmore/GPF%20Management/gpfsavetitle.dart';
import 'package:ehr/Dashboard/viewmore/model/viewdatavalid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class StaffPolicyClaim extends StatefulWidget {
  const StaffPolicyClaim({super.key});

  @override
  State<StatefulWidget> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<StaffPolicyClaim> {

  InAppWebViewController? webViewController;
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _showLoader();
  }

  void _showLoader() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false; // Stop showing the loader after 2 seconds
    });
  }

     String link = '';

  @override
  Widget build(BuildContext context) {

    if(Gpfsavetitle.title == "GPF Request"){

             String  id =  ViewData.emikid;
             
          link = 'http://192.168.1.113/Mobile/Mobile/MobileAuthication.aspx?Empkid=$id&Type=Mobileclaimrequest&IsMobile=Y';
    }else if(Gpfsavetitle.title == "GPF Status"){
      String  id1 =  ViewData.emikid;
          link = 'http://192.168.1.113/Mobile/Mobile/MobileAuthication.aspx?Empkid=$id1&Type=Mobileclaim&IsMobile=Y';

    }else{
      String  id2 =  ViewData.emikid;
          link = 'http://192.168.1.113/Mobile/Mobile/MobileAuthication.aspx?Empkid=$id2&Type=Mobileclaimreqauth&IsMobile=Y';

    }
    
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
          // ignore: deprecated_member_use
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title:  Text(
                Gpfsavetitle.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                              5.0, // 90% of screen width
                          height: MediaQuery.of(context).size.height *
                              2.0, // 80% of screen height
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(0),
                          ),
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri(
                             // 'http://192.168.1.254/eHR/Mobile/MobileAuthication.aspx?Empkid=15658&Type=LeaveRequest'
                            link
                              ),
                        ),
                        initialSettings: InAppWebViewSettings(
                       javaScriptEnabled: true,
                          supportZoom: false,
                          builtInZoomControls: true,
                          displayZoomControls: true,
                          verticalScrollBarEnabled: true,
                          overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
                          pageZoom: 10,
                          textZoom: 120,
                        ),
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                      
                          controller.addJavaScriptHandler(
                                    handlerName: "webviewbackbutton",
                                    callback: (args) {
                                      // Here you receive all the arguments from the JavaScript side
                                      // that is a List<dynamic>
                                      if (kDebugMode) {
                                        print("From the JavaScript side:");
                                      }
                                      if (kDebugMode) {
                                        print(args);
                                      }
                      
                                     Navigator.pop(context);
          
                                      
                                      return null;
                                      // return args.reduce((curr, next) => curr + next);
                                    });
                                    
                        },
          
                        onLoadStop: (controller, url) async {
                    // Inject JavaScript to set zoom scale to 200%
                    await controller.evaluateJavascript(
                        source: "document.body.style.zoom = '2';");
                  },
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    );
  }
}
