class User {
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.email,
  });

  // Método para crear una instancia de User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  // Método para convertir una instancia de User a un JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phone': phone,
      'email': email,
    };
  }
}
