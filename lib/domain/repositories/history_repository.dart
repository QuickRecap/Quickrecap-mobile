import '../entities/quiz_activity.dart';
import '../entities/gaps_activity.dart';
import '../entities/flashcard_activity.dart';
import '../entities/linkers_activity.dart';
import '../entities/history_activity.dart';


abstract class HistoryRepository {
  Future<List<HistoryActivity>> getHistoryByUserId();
}
