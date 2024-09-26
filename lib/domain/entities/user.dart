class User {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String email;
  final String birthday;
  final String profileImg;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.profileImg
  });

  // Método para crear una instancia de User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Convertir a String
      firstName: json['nombres'], // Mapea 'nombres' a 'firstName'
      lastName: json['apellidos'], // Mapea 'apellidos' a 'lastName'
      gender: json['genero'], // Mapea 'genero' a 'gender'
      phone: json['celular'], // Mapea 'celular' a 'phone'
      email: json['email'], // Mapea 'email' a 'email'
      birthday: json['fecha_nacimiento'] ?? '', // Mapea 'fecha_nacimiento' a 'birthday', usando una cadena vacía si es nulo
      profileImg: json['profile_image'] ?? '', // Mapea 'fecha_nacimiento' a 'birthday', usando una cadena vacía si es nulo
    );
  }

  // Método para convertir una instancia de User a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': firstName,
      'apellidos': lastName,
      'genero': gender,
      'celular': phone,
      'email': email,
      'fecha_nacimiento': birthday,
      'profile_image': profileImg
    };
  }
}
