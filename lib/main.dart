import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sesil_fe/ui/forms_screen.dart';
import 'package:sesil_fe/ui/login_screen.dart';
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseMessagingService _fcmService = FirebaseMessagingService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM Demo',
      home: LoginScreen(),
      routes: {
        '/home': (context) {
          _fcmService.initialize();
          _fcmService.listenToMessages();
          return FormsScreen();
        },
      },
    );
  }
}
