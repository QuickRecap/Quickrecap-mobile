class Linkers {
  List<LinkerItem> linkerItems;
  List<LinkerItem> selectedLinkerItems;

  Linkers({
    required this.linkerItems,
    this.selectedLinkerItems = const [],
  });

  factory Linkers.fromJson(Map<String, dynamic> json, int index) {
    var items = (json['linker_item'] as List)
        .asMap()
        .map((itemIndex, itemJson) => MapEntry(
        itemIndex,
        LinkerItem.fromJson(itemJson, itemIndex)))
        .values
        .toList();

    return Linkers(linkerItems: items);
  }
}

class LinkerItem {
  Word wordItem;
  Definition definitionItem;

  LinkerItem({
    required this.wordItem,
    required this.definitionItem,
  });

  factory LinkerItem.fromJson(Map<String, dynamic> json, int index) {
    return LinkerItem(
      wordItem: Word.fromJson(json, index),
      definitionItem: Definition.fromJson(json, index),
    );
  }
}

class Word {
  String content;
  int? position;  // La posición se asignará al crear la instancia

  Word({
    required this.content,
    this.position,
  });

  factory Word.fromJson(Map<String, dynamic> json, int index) {
    return Word(
      content: json['word'],
      position: index,  // Asignamos la posición
    );
  }
}

class Definition {
  String content;
  int? position;  // La posición se asignará al crear la instancia

  Definition({
    required this.content,
    this.position,
  });

  factory Definition.fromJson(Map<String, dynamic> json, int index) {
    return Definition(
      content: json['definition'],
      position: index,  // Asignamos la posición
    );
  }
}

