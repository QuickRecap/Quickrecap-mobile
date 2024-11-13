class Gaps {
  String completeText;
  String textWithGaps;
  List<String> incorrectAnswers;
  List<Answer> answers;
  List<Answer>? selectAnswers;

  Gaps({
    required this.completeText,
    required this.textWithGaps,
    required this.incorrectAnswers,
    required this.answers,
    this.selectAnswers,
  });

  // Método para crear una instancia de Gaps desde un JSON
  factory Gaps.fromJson(Map<String, dynamic> json) {
    final incorrectAnswers = List<String>.from(json['incorrectas'] ?? []);
    final maxIncorrectAnswers = 3; // Límite máximo de respuestas incorrectas

    return Gaps(
      completeText: json['texto_completo'],
      textWithGaps: json['texto_con_huecos'],
      incorrectAnswers: incorrectAnswers.length > maxIncorrectAnswers
          ? incorrectAnswers.sublist(0, maxIncorrectAnswers)
          : incorrectAnswers,
      answers: List<Answer>.from(json['respuestas'].map((answer) => Answer.fromJson(answer))),
    );
  }
}

class Answer {
  int position;
  List<String> correctOptions;

  Answer({
    required this.position,
    required this.correctOptions,
  });

  // Método para crear una instancia de Answer desde un JSON
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      position: json['posicion'],
      correctOptions: List<String>.from(json['opciones_correctas']),
    );
  }
}
