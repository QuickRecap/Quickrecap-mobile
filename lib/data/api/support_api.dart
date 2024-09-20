import 'dart:convert';
import 'package:http/http.dart' as http;

class SupportApi {
  Future<bool> reportError(String name, String description) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/report/create'),
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
