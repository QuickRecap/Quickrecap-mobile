import 'package:flutter/foundation.dart';
import '../../application/save_pdf_use_case.dart';

class UploadPdfProvider extends ChangeNotifier {
  final SavePdfUseCase savePdfUseCase;

  // Constructor que inicializa el supportUseCase
  UploadPdfProvider(this.savePdfUseCase);

  Future<bool> uploadPdf(String pdfName, String url) async {
    return await savePdfUseCase.savePdf(pdfName, url);
  }
}
