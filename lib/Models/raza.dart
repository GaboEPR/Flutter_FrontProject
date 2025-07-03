class Raza {
  final String codRaza;
  final String descripcion;

  Raza({
    required this.codRaza,
    required this.descripcion,
  });

  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      codRaza: json['cod_raza'] ?? json['codRaza'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  factory Raza.fromMap(Map<String, dynamic> map) {
    return Raza(
      codRaza: map['cod_raza'] ?? map['codRaza'] ?? '',
      descripcion: map['descripcion'] ?? '',
    );
  }

  // Added missing toMap() method
  Map<String, dynamic> toMap() {
    return {
      'codRaza': codRaza,
      'descripcion': descripcion,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_raza': codRaza,
      'descripcion': descripcion,
    };
  }

  Raza copyWith({
    String? codRaza,
    String? descripcion,
  }) {
    return Raza(
      codRaza: codRaza ?? this.codRaza,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  bool isValid() {
    return codRaza.isNotEmpty && descripcion.isNotEmpty;
  }

  // Add a getter for the name for better readability
  String get nombre => descripcion;

  @override
  String toString() {
    return 'Raza{codRaza: $codRaza, descripcion: $descripcion}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Raza && other.codRaza == codRaza;
  }

  @override
  int get hashCode => codRaza.hashCode;
}