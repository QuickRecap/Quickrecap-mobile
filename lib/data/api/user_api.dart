import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import '../repositories/local_storage_service.dart';

class UserApi {
  final String baseUrl = 'https://quickrecap.rj.r.appspot.com/quickrecap';

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
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

  Future<bool> register(String nombre, String apellidos, String gender,
      String phone, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      body: {
        'email': email,
        'password': password,
        'nombres': nombre,
        'apellidos': apellidos,
        'celular': phone,
        'genero': gender,
      },
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/change-password/'),
      body: {
        'id': userId,
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
      Uri.parse('$baseUrl/user/update/$userId'),
      body: {
        'nombres': firstName,
        'apellidos': lastName,
        'celular': phone,
        'genero': gender,
        'fecha_nacimiento': birthdate,
        'profile_image': imageUrl,
      },
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> addUserPoints(int points, int activityId, int correctAnswers, int totalQuestions) async {
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.put(
      Uri.parse('$baseUrl/user/addpoints/$userId'),
      body: jsonEncode({
        "puntos": points,
        "actividad_id": activityId,
        "respuestas_correctas": correctAnswers,
        "numero_preguntas": totalQuestions
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}