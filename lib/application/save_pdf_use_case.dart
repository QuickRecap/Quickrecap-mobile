import 'package:quickrecap/domain/repositories/pdf_repository.dart';

class SavePdfUseCase {
  final PdfRepository pdfRepository;

  SavePdfUseCase(this.pdfRepository);

  Future<bool> savePdf(String pdfName, String url) async {
    try {
      return await pdfRepository.postPdf(pdfName, url);
    } catch (e) {
      return false;
    }
  }
}
