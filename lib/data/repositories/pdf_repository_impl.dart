import 'package:quickrecap/domain/repositories/pdf_repository.dart';
import '../api/pdf_api.dart';
import '../../domain/entities/pdf.dart';

class PdfRepositoryImpl implements PdfRepository{
  final PdfApi pdfApi;

  PdfRepositoryImpl(this.pdfApi);

  @override
  Future<bool> postPdf(String pdfName, String url, int userId) async {
    return await pdfApi.postPdf(pdfName, url, userId);
  }

  @override
  Future<bool> deletePdf(pdfId) async {
    return await pdfApi.deletePdf(pdfId);
  }

  @override
  Future<List<Pdf>?> getPdfsByUserId() async {
    return await pdfApi.getPdfsByUserId();
  }
  
}