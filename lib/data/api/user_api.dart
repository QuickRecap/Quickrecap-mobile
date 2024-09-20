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

  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/quickrecap/change-password/'),
      body: {
        'id': userId, // Agrega el user_id
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> editProfile(
      String userId,
      String firstName,
      String lastName,
      String phone,
      String gender,
      String birthdate,
      String imageUrl,
      ) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/quickrecap/edit-profile/$userId'),
      body: {
        'nombres': firstName,
        'apellidos': lastName,
        'celular': phone,
        'genero': gender,
        'fecha_nacimiento': birthdate,
        'image_url': imageUrl,
      },
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

}
