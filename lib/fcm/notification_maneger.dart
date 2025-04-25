import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationManager {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }
  static void _onMessage (RemoteMessage message){
    print(message.data);
    print(message.notification?.title);
    print(message.notification?.body);
  }
}
Future<void> _onBackgroundMessage(RemoteMessage message) async {
 print('Message');
}