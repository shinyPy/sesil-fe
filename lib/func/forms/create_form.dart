import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sesil_fe/config.dart';
import 'package:flutter/material.dart';

Future<void> createForm(
    BuildContext context, String title, String description) async {
  final _storage = const FlutterSecureStorage();
  String? jwt = await _storage.read(key: 'jwt_token');

  if (jwt == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JWT token not found')),
    );
    return;
  }

  final response = await http.post(
    Uri.parse('$apiBaseUrl/forms'),
    headers: {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'title': title,
      'description': description,
    }),
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form created successfully')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating form: ${response.body}')),
    );
  }
}
