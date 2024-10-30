import '../entities/pdf.dart';

abstract class PdfRepository {
  Future<bool> postPdf(String pdfName, String url);
  Future<bool> deletePdf(int pdfId);
  Future<List<Pdf>?> getPdfsByUserId();
}
