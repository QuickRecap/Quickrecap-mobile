import 'package:flutter/foundation.dart';
import '../../application/get_pdfs_use_case.dart.dart';

class GetPdfsProvider extends ChangeNotifier {
  final GetPdfsUseCase getPdfsUseCase;

  // Constructor que inicializa el supportUseCase
  GetPdfsProvider(this.getPdfsUseCase);

  Future<bool> getPdfsByUserId(int userId) async {
    return await getPdfsUseCase.getPdfsByUserId(userId);
  }
}
