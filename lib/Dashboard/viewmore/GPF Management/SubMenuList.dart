import 'dart:convert';
import 'dart:typed_data';
import 'package:ehr/Dashboard/viewmore/GPF%20Management/gpf.dart';
import 'package:ehr/Dashboard/viewmore/model/menumodel.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// ignore: camel_case_types
class menulist extends StatefulWidget {
  const menulist({super.key});

  @override
  State<menulist> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<menulist> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title:  Text(
                SubMenuList.menuTitle,
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Other widgets above the GridView
                  GridView.builder(
                    shrinkWrap: true, // Prevents infinite height error
                    physics:
                        const NeverScrollableScrollPhysics(), // Use parent scroll
                    padding: const EdgeInsets.all(8),
                    itemCount: SubMenuList.SublistMenu.length,
                    gridDelegate:
                         const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1, // Adjust for better layout
                    ),
                    itemBuilder: (context, index) {
                      final item = SubMenuList.SublistMenu[index];
                      return GestureDetector(
                        onTap: () async {

                          SubMenuList.menuTitle = item.mobileMenuMenuName.toString();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewExample(item: item)));
                        },
                        child: Card(
                          elevation: 8,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildIconFromBase64(
                                    item.mobileMenuMenuIcon.toString()),
                                const SizedBox(height: 10),
                                Text(
                                  item.mobileMenuMenuName.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Helper method to convert Base64 string to an Image widget
  Widget _buildIconFromBase64(String base64String) {
    try {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      );
    } catch (e) {
      return const Icon(Icons.error, size: 60); // Fallback if decoding fails
    }
  }
}
