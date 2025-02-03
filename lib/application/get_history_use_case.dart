import '../domain/repositories/history_repository.dart';
import '../domain/entities/history_activity.dart';

class GetHistoryUseCase {
  final HistoryRepository historyRepository;

  GetHistoryUseCase(this.historyRepository);

  Future<List<HistoryActivity>?> getHistoryByUserId() async {
    try {
      return await historyRepository.getHistoryByUserId();
    } catch (e) {
      return null;
    }
  }
}
