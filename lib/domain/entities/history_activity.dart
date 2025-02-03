class HistoryActivity {
  final int id;
  final String activityName;
  final String activityType;
  final int numberOfQuestions;
  final int correctAnswers;
  final DateTime date;
  final int activityId;
  final int userId;
  final String author;

  HistoryActivity({
    required this.id,
    required this.activityName,
    required this.activityType,
    required this.numberOfQuestions,
    required this.correctAnswers,
    required this.date,
    required this.activityId,
    required this.userId,
    required this.author
  });

  factory HistoryActivity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final activityJson = json['activity'] as Map<String, dynamic>;

    final userId = userJson['id'] as int;
    final activityId = activityJson['id'] as int;

    final firstName = userJson['nombres'] as String? ?? '';
    final lastName = userJson['apellidos'] as String? ?? '';
    final authorName = [firstName, lastName]
        .where((name) => name.isNotEmpty)
        .join(' ')
        .trim();

    return HistoryActivity(
      id: json['id'],
      activityName: json['nombre_actividad'],
      activityType: json['tipo_actividad'],
      numberOfQuestions: json['numero_preguntas'],
      correctAnswers: json['respuestas_correctas'],
      date: DateTime.parse(json['fecha']),
      activityId: activityId,
      userId: userId,
      author: authorName.isNotEmpty ? authorName : 'Sin nombre', // Valor por defecto si no hay nombre
    );
  }
}
