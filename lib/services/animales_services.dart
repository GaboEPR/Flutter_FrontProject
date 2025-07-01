import 'package:proyectadas_flutter/Models/animal.dart';

import '../../data/api_client.dart';
import '../models/raza.dart' as raza_model;

class AnimalesService {
  static const String _endpoint = 'api/v1/animales';
  static const String _razasEndpoint = 'api/v1/razas';

  static Future<ApiResponse> obtenerAnimales() async {
    return await ApiClient.get(_endpoint);
  }

  static Future<ApiResponse> obtenerAnimal(String id) async {
    return await ApiClient.get('$_endpoint/$id');
  }

  static Future<ApiResponse> crearAnimal(Map<String, dynamic> animal) async {
    return await ApiClient.post(_endpoint, body: animal);
  }

  static Future<ApiResponse> actualizarAnimal(String id, Map<String, dynamic> animal) async {
    return await ApiClient.put('$_endpoint/$id', body: animal);
  }

  static Future<ApiResponse> eliminarAnimal(String id) async {
    return await ApiClient.delete('$_endpoint/$id');
  }

  // Nueva función para obtener las razas
  static Future<List<raza_model.Raza>> getRazas() async {
    final response = await ApiClient.get(_razasEndpoint);
    if (response.success) {
      if (response.data is List) {
        return (response.data as List).map((json) => raza_model.Raza.fromJson(json)).toList();
      } else if (response.data is Map && response.data['data'] is List) {
        return (response.data['data'] as List).map((json) => raza_model.Raza.fromJson(json)).toList();
      }
    }
    throw Exception('Error al obtener razas');
  }
}
