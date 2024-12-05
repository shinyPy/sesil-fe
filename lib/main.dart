import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sesil_fe/ui/login_screen.dart';
import 'services/fcm_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt_token');
  runApp(MyApp(initialRoute: token == null ? '/login' : '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) {
          final _fcmService = FirebaseMessagingService();
          _fcmService.initialize();
          _fcmService.listenToMessages();
          return HomeScreen();
        },
      },
    );
  }
}
