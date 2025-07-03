import 'package:proyectadas_flutter/Models/raza.dart';

class Animal {
  final String codAnimal;
  final String descripcion;
  final String sexo;
  final int edad;
  final String codRaza;
  final String colorPelaje;
  final String colorOjos;
  final Raza? raza;

  Animal({
    required this.codAnimal,
    required this.descripcion,
    required this.sexo,
    required this.edad,
    required this.codRaza,
    required this.colorPelaje,
    required this.colorOjos,
    this.raza,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      codAnimal: json['codAnimal'] ?? json['CodAnimal'] ?? '',
      descripcion: json['descripcion'] ?? json['Descripcion'] ?? '',
      sexo: json['sexo'] ?? json['Sexo'] ?? '',
      edad: json['edad'] ?? json['Edad'] ?? 0,
      codRaza: json['codRaza'] ?? json['CodRaza'] ?? '',
      colorPelaje: json['colorPelaje'] ?? json['ColorPelaje'] ?? '',
      colorOjos: json['colorOjos'] ?? json['Color Ojos'] ?? '',
      raza: json['raza'] != null ? Raza.fromJson(json['raza']) : null,
    );
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      codAnimal: map['codAnimal'] ?? '',
      descripcion: map['descripcion'] ?? '',
      sexo: map['sexo'] ?? '',
      edad: map['edad'] ?? 0,
      codRaza: map['codRaza'] ?? '',
      colorPelaje: map['colorPelaje'] ?? '',
      colorOjos: map['colorOjos'] ?? '',
      raza: map['raza'] != null ? Raza.fromMap(map['raza']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codAnimal': codAnimal,
      'descripcion': descripcion,
      'sexo': sexo,
      'edad': edad,
      'codRaza': codRaza,
      'colorPelaje': colorPelaje,
      'colorOjos': colorOjos,
      'raza': raza?.toMap(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  Animal copyWith({
    String? codAnimal,
    String? descripcion,
    String? sexo,
    int? edad,
    String? codRaza,
    String? colorPelaje,
    String? colorOjos,
    Raza? raza,
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
    );
  }

  bool isValid() {
    return codAnimal.isNotEmpty &&
        descripcion.isNotEmpty &&
        sexo.isNotEmpty &&
        edad > 0 &&
        codRaza.isNotEmpty &&
        colorPelaje.isNotEmpty &&
        colorOjos.isNotEmpty;
  }

  String get edadTexto => edad == 1 ? '1 año' : '$edad años';

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
    return 'Animal{codAnimal: $codAnimal, descripcion: $descripcion, sexo: $sexoFormateado, edad: $edadTexto, raza: ${raza?.nombre ?? 'N/A'}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.codAnimal == codAnimal;
  }

  @override
  int get hashCode => codAnimal.hashCode;

  bool get hasRaza => raza != null;

  String get nombreRaza => raza?.nombre ?? 'Sin raza';

  bool get isValidAge => edad > 0 && edad < 50;

  bool get isValidSexo => ['m', 'h', 'macho', 'hembra'].contains(sexo.toLowerCase());

  bool get isCompletelyValid => isValid() && isValidAge && isValidSexo;
}

extension AnimalExtensions on Animal {
  bool get isMale => sexo.toLowerCase() == 'm' || sexo.toLowerCase() == 'macho';

  bool get isFemale => sexo.toLowerCase() == 'h' || sexo.toLowerCase() == 'hembra';

  bool get isYoung => edad <= 2;

  bool get isAdult => edad > 2 && edad <= 8;

  bool get isSenior => edad > 8;

  String get ageCategory {
    if (isYoung) return 'Joven';
    if (isAdult) return 'Adulto';
    return 'Senior';
  }

  String get displayName => descripcion.isNotEmpty ? descripcion : 'Animal #$codAnimal';

  String get shortDescription => '$displayName - $sexoFormateado - $edadTexto';
}
