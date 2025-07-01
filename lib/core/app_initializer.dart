import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInitializer {
  static Future<void> initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      if (kDebugMode) {
        print('✅ AppInitializer: Inicialización completada');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AppInitializer: Error durante la inicialización: $e');
      }
      rethrow;
    }
  }
}
