import 'package:quickrecap/domain/repositories/pdf_repository.dart';

class GetPdfsUseCase {
  final PdfRepository pdfRepository;

  GetPdfsUseCase(this.pdfRepository);

  Future<bool> getPdfsByUserId(int userId) async {
    try {
      return await pdfRepository.getPdfsByUserId(userId);
    } catch (e) {
      return false;
    }
  }
}
