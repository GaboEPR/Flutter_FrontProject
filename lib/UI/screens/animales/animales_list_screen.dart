import 'package:flutter/material.dart';
import 'package:proyectadas_flutter/models/animal.dart';
import 'package:proyectadas_flutter/services/animales_services.dart';
import 'animales_form_screen.dart';

class AnimalesListScreen extends StatefulWidget {
  const AnimalesListScreen({super.key});

  @override
  State<AnimalesListScreen> createState() => _AnimalesListScreenState();
}

class _AnimalesListScreenState extends State<AnimalesListScreen> {
  List<Map<String, dynamic>> _animales = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarAnimales();
  }

  Future<void> _cargarAnimales() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await AnimalesService.obtenerAnimales();

      if (response.success) {
        setState(() {
          if (response.data is Map && response.data['animals'] is List) {
            _animales = List<Map<String, dynamic>>.from(
              response.data['animals'],
            );
          } else {
            _animales = [];
            _error = 'Formato de datos incorrecto';
          }
        });
      } else {
        setState(() {
          _error = response.message;
        });
        _mostrarError('Error al cargar animales: ${response.message}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: $e';
      });
      _mostrarError('Error de conexión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _eliminarAnimal(int index) async {
    final animal = _animales[index];
    final animalId = animal['codAnimal']?.toString();

    if (animalId == null) {
      _mostrarError('No se puede eliminar: ID no encontrado');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar "${animal['descripcion']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await AnimalesService.eliminarAnimal(animalId);

        if (response.success) {
          _mostrarMensaje('Animal eliminado correctamente');
          _cargarAnimales();
        } else {
          _mostrarError('Error al eliminar: ${response.message}');
        }
      } catch (e) {
        _mostrarError('Error de conexión: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _abrirFormulario({
    Map<String, dynamic>? animal,
    int? index,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AnimalesFormScreen(
              animal: animal != null ? Animal.fromJson(animal) : null,
            ),
      ),
    );

    if (result == true || result is Map<String, dynamic>) {
      _cargarAnimales();
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Animales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarAnimales,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty && _animales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los datos',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarAnimales,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_animales.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay animales registrados',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Presiona el botón + para agregar el primer animal',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarAnimales,
      child: ListView.builder(
        itemCount: _animales.length,
        itemBuilder: (_, index) {
          final animal = _animales[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  (animal['descripcion']
                          ?.toString()
                          .substring(0, 1)
                          .toUpperCase()) ??
                      'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                animal['descripcion']?.toString() ?? 'Sin descripción',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${animal['codAnimal'] ?? 'N/A'}'),
                  Text(
                    'Raza: ${animal['codRaza'] ?? 'N/A'} - ${animal['sexo'] ?? 'N/A'}',
                  ),
                  if (animal['edad'] != null)
                    Text('Edad: ${animal['edad']} años'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed:
                        () => _abrirFormulario(animal: animal, index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarAnimal(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
