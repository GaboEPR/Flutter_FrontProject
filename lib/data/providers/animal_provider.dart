// lib/data/providers/animal_provider.dart
import 'package:flutter/foundation.dart';
import 'package:proyectadas_flutter/services/animales_services.dart';
// import '../../data/api_client.dart';

class AnimalProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _animales = [];
  bool _isLoading = false;
  String _error = '';
  String _message = '';

  // Getters
  List<Map<String, dynamic>> get animales => _animales;
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

  // Cargar todos los animales
  Future<void> cargarAnimales() async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await AnimalesService.obtenerAnimales();

      if (response.success) {
        _animales = _processAnimalesResponse(response.data);
        _setMessage('Animales cargados correctamente');
      } else {
        _setError('Error al cargar animales: ${response.message}');
      }
    } catch (e) {
      _setError('Error de conexión: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Crear un nuevo animal
  Future<bool> crearAnimal(Map<String, dynamic> animalData) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await AnimalesService.crearAnimal(animalData);

      if (response.success) {
        _setMessage('Animal creado correctamente');
        await cargarAnimales(); // Recargar la lista
        return true;
      } else {
        _setError('Error al crear animal: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar un animal existente
  Future<bool> actualizarAnimal(
    String id,
    Map<String, dynamic> animalData,
  ) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await AnimalesService.actualizarAnimal(id, animalData);

      if (response.success) {
        _setMessage('Animal actualizado correctamente');
        await cargarAnimales(); // Recargar la lista
        return true;
      } else {
        _setError('Error al actualizar animal: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar un animal
  Future<bool> eliminarAnimal(String id) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await AnimalesService.eliminarAnimal(id);

      if (response.success) {
        _setMessage('Animal eliminado correctamente');
        await cargarAnimales(); // Recargar la lista
        return true;
      } else {
        _setError('Error al eliminar animal: ${response.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtener un animal por ID
  Future<Map<String, dynamic>?> obtenerAnimal(String id) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await AnimalesService.obtenerAnimal(id);

      if (response.success) {
        return response.data;
      } else {
        _setError('Error al obtener animal: ${response.message}');
        return null;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Buscar animales por texto
  List<Map<String, dynamic>> buscarAnimales(String query) {
    if (query.isEmpty) return _animales;

    final queryLower = query.toLowerCase();
    return _animales.where((animal) {
      final codigo = animal['codAnimal']?.toString().toLowerCase() ?? '';
      final descripcion = animal['descripcion']?.toString().toLowerCase() ?? '';
      final raza = animal['codRaza']?.toString().toLowerCase() ?? '';

      return codigo.contains(queryLower) ||
          descripcion.contains(queryLower) ||
          raza.contains(queryLower);
    }).toList();
  }

  // Filtrar animales por sexo
  List<Map<String, dynamic>> filtrarPorSexo(String sexo) {
    return _animales
        .where(
          (animal) =>
              animal['sexo']?.toString().toLowerCase() == sexo.toLowerCase(),
        )
        .toList();
  }

  // Filtrar animales por raza
  List<Map<String, dynamic>> filtrarPorRaza(String codRaza) {
    return _animales
        .where((animal) => animal['codRaza']?.toString() == codRaza)
        .toList();
  }

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

  List<Map<String, dynamic>> _processAnimalesResponse(dynamic data) {
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else if (data is Map && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    } else if (data is Map && data['animales'] is List) {
      return List<Map<String, dynamic>>.from(data['animales']);
    }
    return [];
  }

  // Método para refrescar datos
  Future<void> refresh() async {
    await cargarAnimales();
  }
}
