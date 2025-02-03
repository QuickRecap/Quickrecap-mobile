import 'package:flutter/foundation.dart';
import '../../application/create_linkers_use_case.dart';
import '../../domain/entities/linkers_activity.dart';
import '../../domain/entities/results.dart';

class LinkersProvider extends ChangeNotifier {
  final CreateLinkersUseCase createLinkersUseCase;

  // Constructor que inicializa el supportUseCase
  LinkersProvider(this.createLinkersUseCase);

  Future<Result<LinkersActivity>?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    final result = await createLinkersUseCase.createLinkers(activityName, activityTimer, activityQuantity, pdfUrl);
    return result;
  }
}