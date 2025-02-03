import '../entities/pdf.dart';

abstract class PdfRepository {
  Future<bool> postPdf(String pdfName, String url);
  Future<bool> deletePdf(int pdfId, String pdfUrl);
  Future<List<Pdf>?> getPdfsByUserId();
}
