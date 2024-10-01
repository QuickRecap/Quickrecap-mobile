class Pdf {
  final String name;
  final String url;

  Pdf({
    required this.name,
    required this.url,
  });

  // Método para crear una instancia de Pdf desde un JSON
  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      name: json['nombre'], // Mapea 'name' a 'name'
      url: json['url'],   // Mapea 'url' a 'url'
    );
  }

  // Método para convertir una instancia de Pdf a un JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'url': url,
    };
  }

  // Sobrescribe el método toString para imprimir correctamente el objeto Pdf
  @override
  String toString() {
    return 'Pdf(name: $name, url: $url)';
  }
}
