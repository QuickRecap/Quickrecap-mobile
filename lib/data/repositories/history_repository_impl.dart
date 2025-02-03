import 'package:quickrecap/domain/entities/history_activity.dart';
import 'package:quickrecap/domain/repositories/history_repository.dart';
import '../api/history_api.dart';

class HistoryRepositoryImpl implements HistoryRepository{

  final HistoryApi historyApi;

  HistoryRepositoryImpl(this.historyApi);

  @override
  Future<List<HistoryActivity>> getHistoryByUserId() async{
    return await historyApi.getHistoryByUser();
  }

}