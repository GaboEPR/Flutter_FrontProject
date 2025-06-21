import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String _baseUrlKey = 'server_url';
  static String _baseUrl = '';
  
  // Headers por defecto
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Inicializar con URL guardada
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_baseUrlKey) ?? '';
  }

  // Configurar URL base
  static Future<void> setBaseUrl(String url) async {
    _baseUrl = url.endsWith('/') ? url : '$url/';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  // Obtener URL completa
  static String getFullUrl(String endpoint) {
    if (_baseUrl.isEmpty) {
      throw Exception('Base URL no configurada. Configure primero el servidor.');
    }
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$_baseUrl$cleanEndpoint';
  }

  // GET Request
  static Future<ApiResponse> get(String endpoint) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.get(
        Uri.parse(url),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Error de conexión: ${e.toString()}',
        data: null,
      );
    }
  }

  // POST Request
  static Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.post(
        Uri.parse(url),
        headers: _defaultHeaders,
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Error de conexión: ${e.toString()}',
        data: null,
      );
    }
  }

  // PUT Request
  static Future<ApiResponse> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.put(
        Uri.parse(url),
        headers: _defaultHeaders,
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Error de conexión: ${e.toString()}',
        data: null,
      );
    }
  }

  // DELETE Request
  static Future<ApiResponse> delete(String endpoint) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.delete(
        Uri.parse(url),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Error de conexión: ${e.toString()}',
        data: null,
      );
    }
  }

  // Upload de archivos
  static Future<ApiResponse> uploadFile(String endpoint, File file, {String fieldName = 'file'}) async {
    try {
      final url = getFullUrl(endpoint);
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Agregar archivo
      request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
      
      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Error subiendo archivo: ${e.toString()}',
        data: null,
      );
    }
  }

  // Probar conexión
  static Future<bool> testConnection() async {
    try {
      if (_baseUrl.isEmpty) return false;
      
      // Intentar health check
      final healthResponse = await http.get(
        Uri.parse('${_baseUrl}health'),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 10));

      if (healthResponse.statusCode == 200) return true;

      // Si no hay health, probar root
      final rootResponse = await http.get(
        Uri.parse(_baseUrl),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 10));

      return rootResponse.statusCode == 200 || rootResponse.statusCode == 404;
    } catch (e) {
      return false;
    }
  }

  // Manejar respuesta HTTP
  static ApiResponse _handleResponse(http.Response response) {
    final success = response.statusCode >= 200 && response.statusCode < 300;
    
    dynamic data;
    String message = '';

    try {
      if (response.body.isNotEmpty) {
        data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          message = data['message'].toString();
        }
      }
    } catch (e) {
      data = response.body;
    }

    if (!success && message.isEmpty) {
      message = _getStatusMessage(response.statusCode);
    }

    return ApiResponse(
      success: success,
      statusCode: response.statusCode,
      message: message,
      data: data,
    );
  }

  // Obtener mensaje según código de estado
  static String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Solicitud incorrecta';
      case 401:
        return 'No autorizado';
      case 403:
        return 'Acceso prohibido';
      case 404:
        return 'Recurso no encontrado';
      case 500:
        return 'Error interno del servidor';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Servicio no disponible';
      default:
        return 'Error desconocido (${statusCode})';
    }
  }
}

// Clase para manejar respuestas de la API
class ApiResponse {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  String toString() {
    return 'ApiResponse{success: $success, statusCode: $statusCode, message: $message, data: $data}';
  }
}