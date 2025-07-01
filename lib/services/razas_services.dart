// lib/services/razas_service.dart
import '../../data/api_client.dart';

class RazasService {
  static const String _endpoint = 'api/v1/razas';

  // Obtener todas las razas
  static Future<ApiResponse> obtenerRazas() async {
    return await ApiClient.get(_endpoint);
  }

  // Obtener una raza por ID
  static Future<ApiResponse> obtenerRaza(String id) async {
    return await ApiClient.get('$_endpoint/$id');
  }

  // Crear una nueva raza
  static Future<ApiResponse> crearRaza(Map<String, dynamic> raza) async {
    return await ApiClient.post(_endpoint, body: raza);
  }

  // Actualizar una raza
  static Future<ApiResponse> actualizarRaza(String id, Map<String, dynamic> raza) async {
    return await ApiClient.put('$_endpoint/$id', body: raza);
  }

  // Eliminar una raza
  static Future<ApiResponse> eliminarRaza(String id) async {
    return await ApiClient.delete('$_endpoint/$id');
  }
}