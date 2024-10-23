class Linkers {
  Word word;
  Definition definition;

  Linkers({
    required this.word,
    required this.definition,
  });

  factory Linkers.fromJson(Map<String, dynamic> json, int index) {
    return Linkers(
      word: Word.fromJson(json, index),  // Pasamos el índice a Word
      definition: Definition.fromJson(json, index),  // Pasamos el índice a Definition
    );
  }
}

class Word {
  String word;
  int? position;  // La posición se asignará al crear la instancia

  Word({
    required this.word,
    this.position,
  });

  factory Word.fromJson(Map<String, dynamic> json, int index) {
    return Word(
      word: json['word'],
      position: index,  // Asignamos la posición
    );
  }
}

class Definition {
  String definition;
  int? position;  // La posición se asignará al crear la instancia

  Definition({
    required this.definition,
    this.position,
  });

  factory Definition.fromJson(Map<String, dynamic> json, int index) {
    return Definition(
      definition: json['definition'],
      position: index,  // Asignamos la posición
    );
  }
}

