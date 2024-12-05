import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:sesil_fe/config.dart';
import 'package:flutter/material.dart';

Future<void> login(BuildContext context, String email, String password) async {
  final _storage = const FlutterSecureStorage();

  final response = await http.post(
    Uri.parse('$apiBaseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final token = responseData['access_token'];

    // Save the token securely
    await _storage.write(key: 'jwt_token', value: token);

    // Navigate to the home screen
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Handle login failure
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials!')),
    );
  }
}
