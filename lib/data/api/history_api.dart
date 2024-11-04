import 'dart:convert';
import 'package:http/http.dart' as http;
import '../repositories/local_storage_service.dart';
import '../../domain/entities/history_activity.dart';

class HistoryApi {
  final String baseUrl = 'https://quickrecap.rj.r.appspot.com/quickrecap';

  Future<List<HistoryActivity>> getHistoryByUser() async {
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/historial/list/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<HistoryActivity> historyList = jsonList
            .map((json) => HistoryActivity.fromJson(json))
            .toList();
        return historyList;
      } else {
        throw Exception('Error al cargar las estadísticas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
