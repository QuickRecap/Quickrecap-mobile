import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';

class UserApi {
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }
}
