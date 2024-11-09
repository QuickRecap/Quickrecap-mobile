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
  final String author;

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
    required this.author
  });

  // Método para crear una instancia de Activity desde un JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    // Obtener el ID del usuario del objeto usuario anidado
    final userJson = json['usuario'] as Map<String, dynamic>;
    final userId = userJson['id'] as int;

    // Construir el nombre del autor combinando nombres y apellidos
    final firstName = userJson['nombres'] as String? ?? '';
    final lastName = userJson['apellidos'] as String? ?? '';
    final authorName = [firstName, lastName]
        .where((name) => name.isNotEmpty)
        .join(' ')
        .trim();

    return Activity(
      id: json['id'],
      activityType: json['tipo_actividad'],
      timePerQuestion: json['tiempo_por_pregunta'],
      numberOfQuestions: json['numero_preguntas'],
      timesPlayed: json['veces_jugado'],
      maxScore: json['puntuacion_maxima'],
      favorite: json['favourite'],
      completed: json['completado'],
      private: json['privado'],
      rated: true,
      name: json['nombre'],
      flashcardId: json['flashcard_id'] ?? 0,
      userId: userId,
      author: authorName.isNotEmpty ? authorName : 'Sin nombre', // Valor por defecto si no hay nombre
    );
  }
}
