import 'package:flutter/foundation.dart';
import '../../application/delete_pdf_use_case.dart';
import '../../domain/entities/pdf.dart';

class DeletePdfsProvider extends ChangeNotifier {
  final DeletePdfUseCase deletePdfsUseCase;

  // Constructor que inicializa el supportUseCase
  DeletePdfsProvider(this.deletePdfsUseCase);

  Future<bool> deleteById(int pdfId) async {
    return await deletePdfsUseCase.deletePdf(pdfId);
  }
}
