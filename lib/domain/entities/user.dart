class User {
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String email;
  final String birthday;

  User({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.email,
    required this.birthday,
  });

  // Método para crear una instancia de User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['nombres'],
      lastName: json['apellidos'],
      gender: json['genero'],
      phone: json['celular'],
      email: json['email'],
      birthday: json['fecha_nacimiento'],
    );
  }

  // Método para convertir una instancia de User a un JSON
  Map<String, dynamic> toJson() {
    return {
      'nombres': firstName,
      'apellidos': lastName,
      'genero': gender,
      'celular': phone,
      'email': email,
      'fecha_nacimiento': birthday,
    };
  }
}
