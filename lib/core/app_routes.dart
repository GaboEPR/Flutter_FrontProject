import 'package:flutter/material.dart';
import '../UI/screens/welcome/welcome_screen.dart';
import '../UI/navigation/main_navbar.dart';

class AppRoutes {
  // Nombres de las rutas
  static const String welcome = '/';
  static const String main = '/main';

  // Mapa de rutas
  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(),
      main: (context) => const MainNavbar(),
    };
  }

  // Método para navegar programáticamente
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Método para reemplazar la ruta actual
  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  // Método para limpiar el stack y ir a una nueva ruta
  static void navigateAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName, 
      (route) => false,
    );
  }
}