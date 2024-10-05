class Quiz {
  String question;
  List<String> alternatives;
  int answer;

  Quiz({
    required this.question,
    required this.alternatives,
    required this.answer,
  });

  // Método para crear una instancia de Quiz desde un JSON
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      alternatives: List<String>.from(json['alternatives']),
      answer: json['answer'],
    );
  }

  // Método para convertir una instancia de Quiz a un JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'alternatives': alternatives,
      'answer': answer,
    };
  }
}
