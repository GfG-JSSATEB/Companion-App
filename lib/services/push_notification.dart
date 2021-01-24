import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService._();
  static final FirebaseMessaging _fcm = FirebaseMessaging();

  static Future<void> initialize() async {
    _fcm.requestNotificationPermissions();

    await _fcm.subscribeToTopic('notification');

    _fcm.configure(
      // When using the app
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('message: $message');
      },
      //   When app is closed
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('message: $message');
      },
      //   When app is in the background
      onResume: (Map<String, dynamic> message) async {
        debugPrint('message: $message');
      },
    );
  }
}
