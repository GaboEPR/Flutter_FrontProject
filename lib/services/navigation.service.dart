import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Obtener el contexto actual
  BuildContext? get currentContext => navigatorKey.currentContext;

  // Navegar a una ruta
  Future<T?> navigateTo<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  // Navegar y reemplazar la ruta actual
  Future<T?> navigateAndReplace<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Navegar y limpiar el stack
  Future<T?> navigateAndClearStack<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Retroceder
  void goBack<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  // Retroceder hasta una ruta específica
  void popUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  // Verificar si se puede retroceder
  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  // Navegar con Material Page Route
  Future<T?> navigateToPage<T extends Object?>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Navegar con Page Route personalizada
  Future<T?> navigateWithCustomRoute<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState!.push<T>(route);
  }

  // Mostrar diálogo
  Future<T?> showDialogCustom<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: navigatorKey.currentContext!,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  // Mostrar bottom sheet
  Future<T?> showBottomSheetCustom<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
  }) {
    return showModalBottomSheet<T>(
      context: navigatorKey.currentContext!,
      builder: builder,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
    );
  }

  // Mostrar snackbar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
    );

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }

  // Mostrar snackbar de éxito
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  // Mostrar snackbar de error
  void showErrorSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  // Mostrar snackbar de advertencia
  void showWarningSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  // Mostrar snackbar de información
  void showInfoSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  // Navegar a pantalla de animales
  Future<void> goToAnimales() {
    return navigateTo('/animales');
  }

  // Navegar a formulario de animal
  Future<void> goToAnimalForm({Map<String, dynamic>? arguments}) {
    return navigateTo('/animales/form', arguments: arguments);
  }

  // Navegar a pantalla de razas
  Future<void> goToRazas() {
    return navigateTo('/razas');
  }

  // Navegar a formulario de raza
  Future<void> goToRazaForm({Map<String, dynamic>? arguments}) {
    return navigateTo('/razas/form', arguments: arguments);
  }

  // Navegar a configuración
  Future<void> goToConfig() {
    return navigateTo('/config');
  }

  // Navegar a home
  Future<void> goToHome() {
    return navigateTo('/home');
  }

  // Navegar a cámara
  Future<void> goToCamera({Map<String, dynamic>? arguments}) {
    return navigateTo('/camera', arguments: arguments);
  }

  // Mostrar diálogo de confirmación
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
  }) {
    return showDialogCustom<bool>(
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.red,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Mostrar diálogo de carga
  void showLoadingDialog({String message = 'Cargando...'}) {
    showDialogCustom(
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  // Ocultar diálogo de carga
  void hideLoadingDialog() {
    if (canGoBack()) {
      goBack();
    }
  }
}