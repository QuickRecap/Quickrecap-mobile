import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class SupportApi {
  final String baseUrl = ApiConstants.baseUrl;

  Future<bool> reportError(String name, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/report/create'),
      body: jsonEncode({
        'nombre': name,
        'descripcion': description,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Consider both 200 OK and 201 Created as success
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
