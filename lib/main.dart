import 'package:flutter/material.dart';
import 'package:proyectadas_flutter/app.dart';
import 'package:proyectadas_flutter/core/app_initializer.dart';

void main() async {
  // Inicializar todas las configuraciones necesarias
  await AppInitializer.initialize();
  
  runApp(const ProyectadasApp());
}

class ProyectadasApp extends StatelessWidget {
  const ProyectadasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}