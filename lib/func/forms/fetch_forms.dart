import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sesil_fe/config.dart';

Future<List> fetchForms() async {
  final _storage = const FlutterSecureStorage();
  String? jwt = await _storage.read(key: 'jwt_token');

  if (jwt == null) {
    print('JWT token not found');
    return [];
  }

  final response = await http.get(
    Uri.parse('$apiBaseUrl/forms'),
    headers: {
      'Authorization': 'Bearer $jwt',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Error fetching forms: ${response.body}');
    return [];
  }
}
