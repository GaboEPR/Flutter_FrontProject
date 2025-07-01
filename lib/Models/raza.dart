class Raza {
  final String codRaza;
  final String descripcion;

  Raza({required this.codRaza, required this.descripcion});

  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      codRaza: json['codRaza'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
}
