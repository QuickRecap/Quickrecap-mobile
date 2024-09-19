import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';

class UserApi {
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/login/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      return null;
    }
  }

  Future<User?> register(String nombre, String apellidos, String gender,
      String phone, String email, String password) async {
    print(gender);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/register/'),
      body: {
        'email': email,
        'password': password,
        'nombres': nombre,
        'apellidos': apellidos,
        'celular': phone,
        'genero': gender,
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      return null;
    }
  }
}
