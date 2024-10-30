import '../domain/repositories/pdf_repository.dart';
import '../domain/entities/pdf.dart';

class GetPdfsUseCase {
  final PdfRepository pdfRepository;

  GetPdfsUseCase(this.pdfRepository);

  Future<List<Pdf>?> getPdfsByUserId() async {
    try {
      return await pdfRepository.getPdfsByUserId();
    } catch (e) {
      return null;
    }
  }
}
