import 'package:quickrecap/domain/repositories/pdf_repository.dart';

class DeletePdfUseCase {
  final PdfRepository pdfRepository;

  DeletePdfUseCase(this.pdfRepository);

  Future<bool> deletePdf(int pdfId, String pdfUrl) async {
    try {
      return await pdfRepository.deletePdf(pdfId, pdfUrl);
    } catch (e) {
      return false;
    }
  }
}
