import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/pdf.dart';
import '../repositories/local_storage_service.dart';

class PdfApi {
  final String baseUrl = 'https://quickrecap.rj.r.appspot.com/quickrecap';
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final LocalStorageService localStorageService = LocalStorageService();

  Future<bool> postPdf(String pdfName, String url) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final body = jsonEncode({
        "nombre": pdfName,
        "url": url,
        "usuario": userId
      });

      final response = await http.post(
        Uri.parse('$baseUrl/file/create'),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Error al crear el PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en postPdf: $e');
      return false;
    }
  }

  Future<bool> deletePdf(int pdfId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/file/delete/$pdfId'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error al eliminar el PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en deletePdf: $e');
      return false;
    }
  }

  Future<List<Pdf>> getPdfsByUserId() async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/file/search/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Pdf.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los PDFs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getPdfsByUserId: $e');
      return []; // Retorna lista vacía en caso de error
    }
  }
}