import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // Inicializar SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Verificar si está inicializado
  void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception('StorageService no inicializado. Llame a init() primero.');
    }
  }

  // MÉTODOS BÁSICOS
  
  // Guardar string
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  // Obtener string
  String? getString(String key) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  // Guardar int
  Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    return await _prefs!.setInt(key, value);
  }

  // Obtener int
    int? getInt(String key) {
      _ensureInitialized();
      return _prefs!.getInt(key);
    }
  }