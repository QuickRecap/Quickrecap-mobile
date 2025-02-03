import '../domain/entities/linkers_activity.dart';
import '../domain/entities/linkers.dart';
import '../domain/entities/results.dart';
import '../domain/repositories/activity_repository.dart';
import 'dart:math';

class CreateLinkersUseCase {
  final ActivityRepository activityRepository;

  CreateLinkersUseCase(this.activityRepository);

  Future<Result<LinkersActivity>?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final Result<LinkersActivity>? result = await activityRepository.createLinkers(activityName, activityTimer, activityQuantity, pdfUrl);

      if (result == null) {
        return null;
      }

      if (!result.isSuccess || result.data == null) {
        return Result(
            error: result.error,
            statusCode: result.statusCode
        );
      }

      // Mostrar los ítems de linkers antes de la mezcla
      for (var linkers in result.data!.linkers ?? []) {
        print("Antes de mezclar:");
        for (var item in linkers.linkerItems) {
          print("Word: ${item.wordItem.position} ${item.wordItem.content}, Definition: ${item.definitionItem.position} ${item.definitionItem.content}");
        }

        // Mezclar los ítems de cada Linkers
        _shuffleLinkerItems(linkers.linkerItems);

        // Mostrar los ítems de linkers después de la mezcla
        print("Después de mezclar:");
        for (var item in linkers.linkerItems) {
          print("Word: ${item.wordItem.position} ${item.wordItem.content}, Definition: ${item.definitionItem.position} ${item.definitionItem.content}");
        }
      }

      return Result(data: result.data);
    } catch (e) {
      print("Error: $e");
      return Result(error: e.toString());
    }
  }

  void _shuffleLinkerItems(List<LinkerItem> linkerItems) {
    if (linkerItems.length == 3) {
      // Crear una copia de las definiciones originales
      List<Definition> shuffledDefinitions = List.from(linkerItems.map((item) => Definition(
        content: item.definitionItem.content,
        position: item.definitionItem.position,
      )).toList());

      // Barajar solo las definiciones
      shuffledDefinitions.shuffle(Random());

      // Actualizar solo las definiciones en los LinkerItems
      // manteniendo las palabras en su posición original
      for (int i = 0; i < linkerItems.length; i++) {
        linkerItems[i].definitionItem = shuffledDefinitions[i];
      }
    }
  }
}
