import 'package:flutter/material.dart';
import 'animales_form_screen.dart';

class AnimalesListScreen extends StatefulWidget {
  const AnimalesListScreen({super.key});

  @override
  State<AnimalesListScreen> createState() => _AnimalesListScreenState();
}

class _AnimalesListScreenState extends State<AnimalesListScreen> {
  final List<Map<String, dynamic>> _animales = [
    {
      'codAnimal': 'A001',
      'descripcion': 'Conejo Blanco',
      'sexo': 'Macho',
      'edad': 3,
      'codRaza': 'RAZ001',
      'colorPelaje': 'Blanco',
      'colorOjos': 'Rojos',
    },
  ];

  void _eliminarAnimal(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este animal?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _animales.removeAt(index);
      });
    }
  }

  void _abrirFormulario({Map<String, dynamic>? animal, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalesFormScreen(animal: animal),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _animales[index] = result;
        } else {
          _animales.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Animales')),
      body: ListView.builder(
        itemCount: _animales.length,
        itemBuilder: (_, index) {
          final animal = _animales[index];
          return ListTile(
            title: Text(animal['descripcion']),
            subtitle: Text('Código: ${animal['codAnimal']} - Raza: ${animal['codRaza']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirFormulario(animal: animal, index: index)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminarAnimal(index)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
