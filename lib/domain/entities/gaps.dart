class Gaps {
  String completeText;
  String textWithGaps;
  List<Answer> answers;

  Gaps({
    required this.completeText,
    required this.textWithGaps,
    required this.answers,
  });

  // Método para crear una instancia de Gaps desde un JSON
  factory Gaps.fromJson(Map<String, dynamic> json) {
    return Gaps(
      completeText: json['texto_completo'],
      textWithGaps: json['texto_con_huecos'],
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
