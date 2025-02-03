import 'package:flutter/foundation.dart';
import '../../application/get_history_use_case.dart';
import '../../domain/entities/history_activity.dart';

class GetHistoryProvider extends ChangeNotifier {
  final GetHistoryUseCase getHistoryUseCase;

  // Constructor que inicializa el supportUseCase
  GetHistoryProvider(this.getHistoryUseCase);

  Future<List<HistoryActivity>?> getHistoryByUserId() async {
    return await getHistoryUseCase.getHistoryByUserId();
  }
}
