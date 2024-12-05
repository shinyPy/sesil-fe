import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> initialize() async {
    // Request notification permissions
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted');
    }

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Send the token to the backend if valid
    String? jwt = await _storage.read(key: 'jwt_token');
    if (jwt != null && token != null) {
      final response = await http.post(
        Uri.parse('http://10.215.12.43:8000/api/fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt', // Send the JWT for authentication
        },
        body: jsonEncode({'fcm_token': token}),
      );

      if (response.statusCode == 200) {
        print('FCM token successfully sent to the backend');
      } else {
        print('Failed to send FCM token');
      }
    } else {
      print('No JWT token found or FCM token is null');
    }
  }

  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification?.body}');
      print('Message received: ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
    });
  }
}
