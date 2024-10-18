import '../domain/repositories/pdf_repository.dart';
import '../domain/entities/pdf.dart';

class GetPdfsUseCase {
  final PdfRepository pdfRepository;

  GetPdfsUseCase(this.pdfRepository);

  Future<List<Pdf>?> getPdfsByUserId(int userId) async {
    try {
      return await pdfRepository.getPdfsByUserId(userId);
    } catch (e) {
      return null;
    }
  }
}
