import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsServices{

 final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings('logo'); 

void initialiseNotification() async{

InitializationSettings initializationSettings = InitializationSettings(
  android: _androidInitializationSettings,
);


 await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

}


void sendNotification(String title, String body) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    importance: Importance.max,
    priority: Priority.high,
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await _flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}


void sendNotificationSed(String title, String body) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    importance: Importance.max,
    priority: Priority.high,
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await _flutterLocalNotificationsPlugin.periodicallyShow(0, title, body, RepeatInterval.everyMinute , notificationDetails);

}

} 