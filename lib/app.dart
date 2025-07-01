// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UI/screens/welcome/welcome_screen.dart';
import 'UI/navigation/main_navbar.dart';
import 'data/providers/config_provider.dart';
import 'data/providers/animal_provider.dart';
// import 'data/providers/raza_provider.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final prefs = snapshot.data!;

        return MultiProvider(
          providers: [
            // Provider de configuración existente
            ChangeNotifierProvider(create: (_) => ConfigProvider(prefs)),
            
            // Nuevos providers para API
            // ChangeNotifierProvider(create: (_) => RazaProvider()),
            ChangeNotifierProvider(create: (_) => AnimalProvider()),
          ],
          child: MaterialApp(
            title: 'Gestión de Animales',
            
            // Configuración de localización
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'), // Español
              Locale('en', 'US'), // Inglés (fallback)
            ],
            locale: const Locale('es', 'ES'),
            
            // Tema de la aplicación
            theme: AppTheme.lightTheme,
            
            // Configuración de rutas
            initialRoute: AppRoutes.welcome,
            routes: AppRoutes.routes,
            
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

class AppTheme {
  static var lightTheme;
}