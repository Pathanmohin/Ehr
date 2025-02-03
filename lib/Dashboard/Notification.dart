
import 'package:ehr/Model/PendingMessage.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'package:http/http.dart' as http;


class NotificationPage extends StatefulWidget {
  final List<PendingMessage> pendingMessages;

  NotificationPage({required this.pendingMessages});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
return false;
      
    },
      child: Builder(
        builder: (context) {
          return MediaQuery(
           data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Notification",
                  style: TextStyle(color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
                backgroundColor: Colors.blue,
              ),
              body: ListView.builder(
              itemCount: widget.pendingMessages.length,
              itemBuilder: (context, index) {
            final message = widget.pendingMessages[index];
            return Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.NotifiMobile_Msg,
                          style: const TextStyle(fontFamily: "TimesNewRoman", fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                         await deleteNotifications([message.NotifiMobile_kid]);
            
                          setState(() {
                            widget.pendingMessages.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                        
            
                       // subtitle: Text(message.body),
                      ),
                       
                       buildDivider()
                    ],
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }
   Widget buildDivider() {
    return const Divider(
      color: Colors.black,
      thickness: 1,
    );
  }

Future<void> deleteNotifications(List<int> checkList) async {
    try {
      
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
    
    
    
   
    String userId = prefs.getString("userID") ?? '';

    StringBuffer sb = StringBuffer();
      for (var item in checkList) {
        sb.write('$item,');
      }

        String restUrl =
            '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=NotificationDelete&kid=${sb.toString()}';
        var uri = Uri.parse(restUrl.replaceAll(' ', ''));
        
        await EasyLoading.show(status: 'Loading...');
        var response = await http.get(uri);

        if (response.statusCode == 200) {
          await EasyLoading.dismiss();
          var content = response.body;
          
          if (content == "True") {
            EasyLoading.showSuccess('Notification Deleted');
            // Update the notifications list here
          }
        } else {
          await EasyLoading.dismiss();
          EasyLoading.showError('Failed to delete notifications');
        }
      }
      catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError('Unable to connect to the server');
      debugPrint('ERROR: $e');
    }
    } 
    
  }




