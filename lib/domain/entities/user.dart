class User {
  final String nombre;
  final String apellidos;
  final String genero;
  final String celular;
  final String correo;

  User({
    required this.nombre,
    required this.apellidos,
    required this.genero,
    required this.celular,
    required this.correo,
  });

  // Método para crear una instancia de User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      genero: json['genero'],
      celular: json['celular'],
      correo: json['correo'],
    );
  }

  // Método para convertir una instancia de User a un JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'genero': genero,
      'celular': celular,
      'correo': correo,
    };
  }
}
