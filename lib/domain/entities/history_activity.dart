class HistoryActivity {
  final int id;
  final String activityName;
  final String activityType;
  final int numberOfQuestions;
  final int correctAnswers;
  final DateTime date;
  final int activityId;
  final int userId;

  HistoryActivity({
    required this.id,
    required this.activityName,
    required this.activityType,
    required this.numberOfQuestions,
    required this.correctAnswers,
    required this.date,
    required this.activityId,
    required this.userId,
  });

  // Método para crear una instancia de HistoryActivity desde un JSON
  factory HistoryActivity.fromJson(Map<String, dynamic> json) {
    return HistoryActivity(
      id: json['id'],
      activityName: json['nombre_actividad'],
      activityType: json['tipo_actividad'],
      numberOfQuestions: json['numero_preguntas'],
      correctAnswers: json['respuestas_correctas'],
      date: DateTime.parse(json['fecha']),
      activityId: json['activity'],
      userId: json['user'],
    );
  }
}
