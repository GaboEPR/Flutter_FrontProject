import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // Asegurar que los widgets estén inicializados
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicializar localizaciones
    await _initializeLocalization();
  }

  static Future<void> _initializeLocalization() async {
    // Inicializar los datos de localización para español
    await initializeDateFormatting('es_ES', null);
    
    // También inicializar inglés como fallback
    await initializeDateFormatting('en_US', null);
    
    // Establecer el locale por defecto para Intl
    Intl.defaultLocale = 'es_ES';
  }
}