import '../entities/pdf.dart';

abstract class PdfRepository {
  Future<bool> postPdf(String pdfName, String url, int userId);
  Future<List<Pdf>?> getPdfsByUserId(int userId);
}
