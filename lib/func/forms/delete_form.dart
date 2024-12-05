import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sesil_fe/config.dart';

Future<void> deleteForm(int formId) async {
  final _storage = const FlutterSecureStorage();
  String? jwt = await _storage.read(key: 'jwt_token');

  if (jwt == null) {
    print('JWT token not found');
    return;
  }

  final response = await http.delete(
    Uri.parse('$apiBaseUrl/forms/$formId'),
    headers: {
      'Authorization': 'Bearer $jwt',
    },
  );

  if (response.statusCode == 200) {
    print('Form deleted successfully');
  } else {
    print('Error deleting form: ${response.body}');
  }
}
