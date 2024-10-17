class Activity {
  final int id;
  final String activityType;
  final int timePerQuestion;
  final int numberOfQuestions;
  final int timesPlayed;
  final int maxScore;
  bool favorite;
  final bool completed;
  bool private;
  final bool rated;
  final String name;
  final int flashcardId;
  final int userId;

  Activity({
    required this.id,
    required this.activityType,
    required this.timePerQuestion,
    required this.numberOfQuestions,
    required this.timesPlayed,
    required this.maxScore,
    required this.favorite,
    required this.completed,
    required this.private,
    required this.rated,
    required this.name,
    required this.flashcardId,
    required this.userId,
  });

  // Método para crear una instancia de Activity desde un JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activityType: json['tipo_actividad'],
      timePerQuestion: json['tiempo_por_pregunta'],
      numberOfQuestions: json['numero_preguntas'],
      timesPlayed: json['veces_jugado'],
      maxScore: json['puntuacion_maxima'],
      favorite: json['favorito'],
      completed: json['completado'],
      private: json['privado'],
      rated: json['rated'],
      name: json['nombre'],
      flashcardId: json['flashcard_id'],
      userId: json['usuario'],
    );
  }
}
