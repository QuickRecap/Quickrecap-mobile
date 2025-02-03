class HomeStats {
  final int totalActividades;
  final int totalArchivos;
  final int totalUsuarios;

  HomeStats({
    required this.totalActividades,
    required this.totalArchivos,
    required this.totalUsuarios,
  });

  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      totalActividades: json['total_actividades'] ?? 0,
      totalArchivos: json['total_archivos'] ?? 0,
      totalUsuarios: json['total_usuarios'] ?? 0,
    );
  }
}