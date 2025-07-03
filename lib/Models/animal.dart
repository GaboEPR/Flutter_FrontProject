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
  final String? imagenUrl;

  Animal({
    required this.codAnimal,
    required this.descripcion,
    required this.sexo,
    required this.edad,
    required this.codRaza,
    required this.colorPelaje,
    required this.colorOjos,
    this.raza,
    this.imagenUrl,
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
      imagenUrl: json['imagenUrl'] ?? json['imagen_url'],
    );
  }

  // ✅ Implementación completa de fromMap
  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      codAnimal: map['codAnimal'] ?? '',
      descripcion: map['descripcion'] ?? '',
      sexo: map['sexo'] ?? '',
      edad: map['edad'] ?? 0,
      codRaza: map['codRaza'] ?? '',
      colorPelaje: map['colorPelaje'] ?? '',
      colorOjos: map['colorOjos'] ?? '',
      imagenUrl: map['imagenUrl'],
      raza: map['raza'] != null ? Raza.fromMap(map['raza']) : null,
    );
  }

  // ✅ Implementación de toMap (alias de toJson)
  Map<String, dynamic> toMap() {
    return {
      'codAnimal': codAnimal,
      'descripcion': descripcion,
      'sexo': sexo,
      'edad': edad,
      'codRaza': codRaza,
      'colorPelaje': colorPelaje,
      'colorOjos': colorOjos,
      'imagenUrl': imagenUrl,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // Resto de métodos: copyWith, isValid, edadTexto, sexoFormateado, etc.
  // (ya los tienes bien)
}
