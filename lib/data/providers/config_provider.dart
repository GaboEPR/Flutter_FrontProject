import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfigProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  static const String _serverUrlKey = 'server_url';
  static const String _isConfiguredKey = 'is_configured';
  
  String _serverUrl = '';
  bool _isConfigured = false;
  bool _isLoading = false;

  ConfigProvider(this._prefs) {
    _loadConfig();
  }

  // Getters
  String get serverUrl => _serverUrl;
  bool get isConfigured => _isConfigured;
  bool get isLoading => _isLoading;
  String get baseUrl => _serverUrl.endsWith('/') ? _serverUrl : '$_serverUrl/';

  // Cargar configuración guardada
  void _loadConfig() {
    _serverUrl = _prefs.getString(_serverUrlKey) ?? '';
    _isConfigured = _prefs.getBool(_isConfiguredKey) ?? false;
    notifyListeners();
  }

  // Guardar configuración
  Future<void> _saveConfig() async {
    await _prefs.setString(_serverUrlKey, _serverUrl);
    await _prefs.setBool(_isConfiguredKey, _isConfigured);
  }

  // Probar conexión con el servidor
  Future<bool> testConnection(String url) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Limpiar URL
      final cleanUrl = url.trim();
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        throw Exception('La URL debe comenzar con http:// o https://');
      }

      // Probar endpoint de health o raíz
      final healthUrl = cleanUrl.endsWith('/') ? '${cleanUrl}health' : '$cleanUrl/health';
      
      final response = await http.get(
        Uri.parse(healthUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Conexión exitosa
        _serverUrl = cleanUrl;
        _isConfigured = true;
        await _saveConfig();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Probar endpoint raíz si health no funciona
        final rootResponse = await http.get(
          Uri.parse(cleanUrl),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 10));
        
        if (rootResponse.statusCode == 200 || rootResponse.statusCode == 404) {
          // Servidor responde, aunque sea con 404
          _serverUrl = cleanUrl;
          _isConfigured = true;
          await _saveConfig();
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Error testing connection: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Resetear configuración
  Future<void> resetConfig() async {
    _serverUrl = '';
    _isConfigured = false;
    await _prefs.remove(_serverUrlKey);
    await _prefs.remove(_isConfiguredKey);
    notifyListeners();
  }

  // Obtener URL completa para endpoint
  String getEndpointUrl(String endpoint) {
    if (_serverUrl.isEmpty) {
      throw Exception('URL del servidor no configurada');
    }
    
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '${baseUrl}$cleanEndpoint';
  }

  // Verificar si la configuración es válida
  bool isValidConfig() {
    return _serverUrl.isNotEmpty && _isConfigured;
  }
}