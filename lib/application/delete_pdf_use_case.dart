import 'package:quickrecap/domain/repositories/pdf_repository.dart';

class DeletePdfUseCase {
  final PdfRepository pdfRepository;

  DeletePdfUseCase(this.pdfRepository);

  Future<bool> deletePdf(int pdfId) async {
    try {
      return await pdfRepository.deletePdf(pdfId);
    } catch (e) {
      return false;
    }
  }
}
