import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import '../repositories/local_storage_service.dart';

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

  Future<bool> register(String nombre, String apellidos, String gender,
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

    return response.statusCode == 200 || response.statusCode == 201;
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
      Uri.parse('http://10.0.2.2:8000/quickrecap/user/update/$userId'),
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

  Future<bool> addUserPoints(int points, int activityId) async{
    // Obtener el userId desde el servicio de almacenamiento local
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/quickrecap/user/addpoints/$userId'),
        body: jsonEncode({
          'puntos': points,
          'actividad_id': activityId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Consider both 200 OK and 201 Created as success
      return response.statusCode == 200 || response.statusCode == 201;
  }

}
