// lib/data/providers/raza_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyectadas_flutter/services/razas_services.dart';

import '../../data/api_client.dart';

class RazaProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _razas = [];
  bool _isLoading = false;
  String _error = '';
  String _message = '';

  // Getters
  List<Map<String, dynamic>> get razas => _razas;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get message => _message;
  bool get hasError => _error.isNotEmpty;
  bool get hasMessage => _message.isNotEmpty;

  // Limpiar mensajes
  void clearMessages() {
    _error = '';
    _message = '';
    notifyListeners();
  }

  // Cargar todas las razas
  Future<void> cargarRazas() async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await RazasService.obtenerRazas();
      
      if (response.success) {
        _razas = _processRazasResponse(response.data);
        _setMessage('Razas cargadas correctamente');
      } else {
        _setError('Error al cargar razas: ${response.message}');
      }
    } catch (e) {
      _setError('Error de conexión: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Crear una nueva raza
  Future<bool> crearRaza(Map<String, dynamic> razaData) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await RazasService.crearRaza(razaData);
      
      if (response.success) {
        _setMessage('Raza creada correctamente');
        await cargarRazas(); // Recargar la lista
        return true;
      } else {
        _setError('Error al crear raza: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar una raza existente
  Future<bool> actualizarRaza(String id, Map<String, dynamic> razaData) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await RazasService.actualizarRaza(id, razaData);
      
      if (response.success) {
        _setMessage('Raza actualizada correctamente');
        await cargarRazas(); // Recargar la lista
        return true;
      } else {
        _setError('Error al actualizar raza: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar una raza
  Future<bool> eliminarRaza(String id) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await RazasService.eliminarRaza(id);
      
      if (response.success) {
        _setMessage('Raza eliminada correctamente');
        await cargarRazas(); // Recargar la lista
        return true;
      } else {
        _setError('Error al eliminar raza: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtener una raza por ID
  Future<Map<String, dynamic>?> obtenerRaza(String id) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await RazasService.obtenerRaza(id);
      
      if (response.success) {
        return response.data;
      } else {
        _setError('Error al obtener raza: ${response.message}');
        return null;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Buscar razas por texto
  List<Map<String, dynamic>> buscarRazas(String query) {
    if (query.isEmpty) return _razas;
    
    final queryLower = query.toLowerCase();
    return _razas.where((raza) {
      final codigo = raza['codRaza']?.toString().toLowerCase() ?? '';
      final descripcion = raza['descripcion']?.toString().toLowerCase() ?? '';
      final nombre = raza['nombre']?.toString().toLowerCase() ?? '';
      
      return codigo.contains(queryLower) || 
              descripcion.contains(queryLower) || 
              nombre.contains(queryLower);
    }).toList();
  }

  // Obtener raza por código
  Map<String, dynamic>? obtenerRazaPorCodigo(String codRaza) {
    try {
      return _razas.firstWhere(
        (raza) => raza['codRaza']?.toString() == codRaza ||
                  raza['id']?.toString() == codRaza
      );
    } catch (e) {
      return null;
    }
  }

  // Obtener opciones para dropdown
  List<DropdownMenuItem<String>> get dropdownItems {
    return _razas.map((raza) {
      final id = raza['codRaza']?.toString() ?? raza['id']?.toString() ?? '';
      final descripcion = raza['descripcion']?.toString() ?? 
                         raza['nombre']?.toString() ?? 
                         'Sin descripción';
      
      return DropdownMenuItem<String>(
        value: id,
        child: Text(descripcion),
      );
    }).toList();
  }

  // Verificar si hay razas cargadas
  bool get isEmpty => _razas.isEmpty;
  bool get isNotEmpty => _razas.isNotEmpty;

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _message = '';
    notifyListeners();
  }

  void _setMessage(String message) {
    _message = message;
    _error = '';
    notifyListeners();
  }

  void _clearMessages() {
    _error = '';
    _message = '';
  }

  List<Map<String, dynamic>> _processRazasResponse(dynamic data) {
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else if (data is Map && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    } else if (data is Map && data['razas'] is List) {
      return List<Map<String, dynamic>>.from(data['razas']);
    }
    return [];
  }

  // Método para refrescar datos
  Future<void> refresh() async {
    await cargarRazas();
  }
}