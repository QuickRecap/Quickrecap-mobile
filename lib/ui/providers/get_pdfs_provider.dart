import 'package:flutter/foundation.dart';
import '../../application/get_pdfs_use_case.dart';
import '../../domain/entities/pdf.dart';

class GetPdfsProvider extends ChangeNotifier {
  final GetPdfsUseCase getPdfsUseCase;

  // Constructor que inicializa el supportUseCase
  GetPdfsProvider(this.getPdfsUseCase);

  Future<List<Pdf>?> getPdfsByUserId() async {
    return await getPdfsUseCase.getPdfsByUserId();
  }
}
