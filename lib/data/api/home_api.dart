import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickrecap/domain/entities/home.dart';
import 'api_constants.dart';

class HomeApi {
  final String baseUrl = ApiConstants.baseUrl;

  Future<HomeStats> getHomeStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home/list'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return HomeStats.fromJson(data);
      } else {
        throw Exception('Error al cargar las estadísticas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}