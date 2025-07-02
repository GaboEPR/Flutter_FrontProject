import 'dart:typed_data';

class Animal {
  final String codAnimal;
  final String descripcion;
  final String sexo;
  final int edad;
  final String codRaza;
  final String colorPelaje;
  final String colorOjos;

  final Uint8List? imagen;
  final Raza? raza; // Relación con Raza
  final String? imagenUrl; // URL de la imagen

  Animal({
    required this.codAnimal,
    required this.descripcion,
    required this.sexo,
    required this.edad,
    required this.codRaza,
    required this.colorPelaje,
    required this.colorOjos,
    this.imagen,
    this.raza,
    this.imagenUrl,
  });

  // Factory constructor para crear desde JSON
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      codAnimal: json['codAnimal'] ?? json['CodAnimal'] ?? '',
      descripcion: json['descripcion'] ?? json['Descripcion'] ?? '',
      sexo: json['sexo'] ?? json['Sexo'] ?? '',
      edad: json['edad'] ?? json['Edad'] ?? 0,
      codRaza: json['codRaza'] ?? json['CodRaza'] ?? '',
      colorPelaje: json['colorPelaje'] ?? json['ColorPelaje'] ?? '',
      colorOjos: json['colorOjos'] ?? json['Color Ojos'] ?? '',
      imagen:
          json['imagen'] != null ? Uint8List.fromList(json['imagen']) : null,
      raza: json['raza'] != null ? Raza.fromJson(json['raza']) : null,
      imagenUrl: json['imagenUrl'] ?? json['imagen_url'],
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'codAnimal': codAnimal,
      'descripcion': descripcion,
      'sexo': sexo,
      'edad': edad,
      'codRaza': codRaza,
      'colorPelaje': colorPelaje,
      'colorOjos': colorOjos,
      'imagen': imagen?.toList(),
      'imagenUrl': imagenUrl,
    };
  }

  // Crear copia con cambios
  Animal copyWith({
    String? codAnimal,
    String? descripcion,
    String? sexo,
    int? edad,
    String? codRaza,
    String? colorPelaje,
    String? colorOjos,
    Raza? raza,
    Uint8List? imagen,
    String? imagenUrl,
  }) {
    return Animal(
      codAnimal: codAnimal ?? this.codAnimal,
      descripcion: descripcion ?? this.descripcion,
      sexo: sexo ?? this.sexo,
      edad: edad ?? this.edad,
      codRaza: codRaza ?? this.codRaza,
      colorPelaje: colorPelaje ?? this.colorPelaje,
      colorOjos: colorOjos ?? this.colorOjos,
      raza: raza ?? this.raza,
      imagen: imagen ?? this.imagen,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  // Validar si el animal es válido
  bool isValid() {
    return codAnimal.isNotEmpty &&
        descripcion.isNotEmpty &&
        sexo.isNotEmpty &&
        edad > 0 &&
        codRaza.isNotEmpty &&
        colorPelaje.isNotEmpty &&
        colorOjos.isNotEmpty;
  }

  // Obtener edad en texto
  String get edadTexto {
    if (edad == 1) return '1 año';
    return '$edad años';
  }

  // Obtener sexo formateado
  String get sexoFormateado {
    switch (sexo.toLowerCase()) {
      case 'm':
      case 'macho':
        return 'Macho';
      case 'h':
      case 'hembra':
        return 'Hembra';
      default:
        return sexo;
    }
  }

  @override
  String toString() {
    return 'Animal{codAnimal: $codAnimal, descripcion: $descripcion, sexo: $sexo, edad: $edad}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.codAnimal == codAnimal;
  }

  @override
  int get hashCode => codAnimal.hashCode;
}

class Raza {
  final String codRaza;
  final String descripcion;

  Raza({required this.codRaza, required this.descripcion});

  // Factory constructor para crear desde JSON
  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      codRaza: json['codRaza'] ?? json['CodRaza'] ?? '',
      descripcion: json['descripcion'] ?? json['Descripcion'] ?? '',
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {'codRaza': codRaza, 'descripcion': descripcion};
  }

  // Crear copia con cambios
  Raza copyWith({String? codRaza, String? descripcion}) {
    return Raza(
      codRaza: codRaza ?? this.codRaza,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  // Validar si la raza es válida
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
