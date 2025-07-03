class Raza {
  final String codRaza;
  final String descripcion;

  Raza({
    required this.codRaza,
    required this.descripcion,
  });

  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      codRaza: json['codRaza'] ?? json['CodRaza'] ?? '',
      descripcion: json['descripcion'] ?? json['Descripcion'] ?? '',
    );
  }

  factory Raza.fromMap(Map<String, dynamic> map) {
    return Raza(
      codRaza: map['codRaza'] ?? map['CodRaza'] ?? '',
      descripcion: map['descripcion'] ?? map['Descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codRaza': codRaza,
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
