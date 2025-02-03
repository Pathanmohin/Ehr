import 'dart:convert';
import 'dart:typed_data';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/viewmore/GPF%20Management/SubMenuList.dart';
import 'package:ehr/Dashboard/viewmore/GPF%20Management/gpf.dart';
import 'package:ehr/Dashboard/viewmore/model/menumodel.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewMore extends StatefulWidget {
  const ViewMore({super.key});

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "View More",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: MenuList.listMenu.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10.0, // Horizontal spacing between items
                mainAxisSpacing: 10.0, // Vertical spacing between items
                childAspectRatio: 1, // Width-to-height ratio of items
              ),
              itemBuilder: (context, index) {
                final item = MenuList.listMenu[index];
                return GestureDetector(
                  onTap: () async{

                    String Name=item.mobileMenuParentName.toString();


                    Sublist(Name);

              //Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(item :item)));

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
                          _buildIconFromBase64(item.mobileMenuIcon.toString()),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              item.mobileMenuParentName.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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


   Future<void> Sublist(String MenuName) async {
    // String empKid = prefs.getString('EmpKid') ?? '';
    String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=SubMenuList&ParentName=$MenuName';

    var uri = Uri.parse(restUrl);
    var response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var res = jsonDecode(response.body);

          List<MobileMenu> listMenu = [];
          MenuList.listMenu.clear();

          for (int i = 0; i < res.length; i++) {
            var data = res[i];

            print(data);

            MobileMenu object = MobileMenu();

            object.mobileMenuKid = data["MobileMenu_kid"];

            object.mobileMenuMenuName = data["MobileMenu_MenuName"];
            object.mobileMenuType = data["MobileMenu_type"];
            object.mobileMenuPath = data["MobileMenu_Path"];
            object.mobileMenuMenuIcon = data["MobileMenu_MenuIcon"];
            object.mobileMenuParentName = data["MobileMenu_ParentName"];
            listMenu.add(object);
          }

          SubMenuList.SublistMenu = listMenu;

          SubMenuList.menuTitle = MenuName;


          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  const menulist()));



        } else {
          Alert_DialogBox.showAlert(context, "Menu List Not Available");
        }
      } else {
        Alert_DialogBox.showAlert(context, "Unable to connect with server");
      }
    } catch (e) {
      Alert_DialogBox.showAlert(context, "Unable to connect with server");
    }
  }
}
