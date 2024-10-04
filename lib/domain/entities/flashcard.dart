class Flashcard {
  String word;
  String definition;

  Flashcard({
    required this.word,
    required this.definition,
  });

  // Método para crear una instancia de Flashcard desde un JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      word: json['word'],
      definition: json['definition'],
    );
  }

  // Método para convertir una instancia de Flashcard a un JSON
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definition': definition,
    };
  }
}
