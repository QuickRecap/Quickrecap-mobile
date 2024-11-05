import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/pdf.dart';
import '../repositories/local_storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';


class PdfApi {
  final FirebaseStorage _storage = FirebaseStorage.instance;
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

  Future<bool> deletePdf(int pdfId, String pdfUrl) async {
    try {
      // 1. Eliminar de Firebase Storage usando la URL
      Reference ref = _storage.refFromURL(pdfUrl);
      await ref.delete();

      // 2. Eliminar del backend
      final response = await http.delete(
        Uri.parse('$baseUrl/file/delete/$pdfId'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error al eliminar el PDF del backend: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el PDF: $e');
      // Puedes manejar diferentes tipos de errores aquí
      if (e is FirebaseException) {
        print('Error de Firebase: ${e.message}');
      }
      return false;
    }
  }

  // Función auxiliar para extraer el nombre del archivo de la URL
  String getFileNameFromUrl(String url) {
    try {
      // La URL de Firebase Storage suele tener el formato:
      // https://firebasestorage.googleapis.com/.../uploads%2FuniqueId_filename.pdf
      Uri uri = Uri.parse(url);
      String path = uri.path;
      // Obtener la última parte de la URL (el nombre del archivo)
      String fileName = path.split('/').last;
      // Decodificar el nombre del archivo (por si tiene caracteres especiales)
      return Uri.decodeComponent(fileName);
    } catch (e) {
      print('Error al extraer el nombre del archivo: $e');
      return '';
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