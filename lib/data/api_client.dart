import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://127.0.0.1:8000/';

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String getFullUrl(String endpoint) {
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$_baseUrl$cleanEndpoint';
  }

  static Future<ApiResponse> get(String endpoint) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.get(Uri.parse(url), headers: _defaultHeaders)
          .timeout(const Duration(seconds: 30));
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

  static Future<ApiResponse> delete(String endpoint) async {
    try {
      final url = getFullUrl(endpoint);
      final response = await http.delete(Uri.parse(url), headers: _defaultHeaders)
          .timeout(const Duration(seconds: 30));
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

  static Future<ApiResponse> uploadFile(String endpoint, File file, {String fieldName = 'file'}) async {
    try {
      final url = getFullUrl(endpoint);
      final request = http.MultipartRequest('POST', Uri.parse(url));
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
        return 'Error desconocido ($statusCode)';
    }
  }
}

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
