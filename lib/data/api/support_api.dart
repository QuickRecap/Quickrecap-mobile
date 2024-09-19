import 'dart:convert';
import 'package:http/http.dart' as http;

class SupportApi {
  Future<bool> reportError(String name, String description) async {
    print("error mandado en api");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/report-error/'),
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
