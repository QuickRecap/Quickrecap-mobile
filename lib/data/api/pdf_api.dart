import 'dart:convert';
import 'package:http/http.dart' as http;

class PdfApi {
  Future<bool> postPdf(String pdfName, String url, int userId) async {
    final body = jsonEncode({
      "nombre": pdfName,
      "url": url,
      "usuario": userId
    });

    print('Enviando datos: $body'); // Añadido para imprimir los datos enviados

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/file/create'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Consider both 200 OK and 201 Created as success
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> getPdfsByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/quickrecap/file/search/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Consider both 200 OK and 201 Created as success
    return response.statusCode == 200 || response.statusCode == 201;
  }

}
