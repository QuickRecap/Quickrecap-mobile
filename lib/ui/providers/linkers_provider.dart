import 'package:flutter/foundation.dart';
import '../../application/create_linkers_use_case.dart';
import '../../domain/entities/linkers_activity.dart';

class LinkersProvider extends ChangeNotifier {
  final CreateLinkersUseCase createLinkersUseCase;

  // Constructor que inicializa el supportUseCase
  LinkersProvider(this.createLinkersUseCase);

  Future<LinkersActivity?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await createLinkersUseCase.createLinkers(activityName, activityTimer, activityQuantity, pdfUrl);
  }
}