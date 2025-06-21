import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proyectadas_flutter/UI/screens/home/home_screen.dart';
import 'package:proyectadas_flutter/UI/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'data/providers/config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar los datos de localización para español
  await initializeDateFormatting('es_ES', null);
  
  // También puedes inicializar otros locales si los necesitas
  // await initializeDateFormatting('en_US', null);
  
  // Establecer el locale por defecto para Intl
  Intl.defaultLocale = 'es_ES';
  
  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider(prefs)),
        // ChangeNotifierProvider(create: (_) => RazaProvider()),
        // ChangeNotifierProvider(create: (_) => AnimalProvider()),
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
        
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          // '/config': (context) => const ConfigScreen(),
          '/home': (context) => const HomeScreen(),
          // '/animales': (context) => const AnimalesListScreen(),
          // '/animales/form': (context) => const AnimalFormScreen(),
          // '/razas': (context) => const RazasListScreen(),
          // '/razas/form': (context) => const RazaFormScreen(),
        },
      ),
    );
  }
}

class ConfigScreen {
  const ConfigScreen();
}