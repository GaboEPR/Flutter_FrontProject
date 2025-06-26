import 'package:flutter/material.dart';
import 'razas_form_screen.dart';

class RazasListScreen extends StatefulWidget {
  const RazasListScreen({super.key});

  @override
  State<RazasListScreen> createState() => _RazasListScreenState();
}

class _RazasListScreenState extends State<RazasListScreen> {
  final List<Map<String, String>> _razas = [
    {'codRaza': 'RAZ001', 'descripcion': 'Labrador'},
    {'codRaza': 'RAZ002', 'descripcion': 'Pastor Alemán'},
  ];

  void _eliminarRaza(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta raza?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _razas.removeAt(index);
      });
    }
  }

  void _abrirFormulario({Map<String, String>? raza, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RazaFormScreen(raza: raza),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _razas[index] = result;
        } else {
          _razas.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Razas')),
      body: ListView.builder(
        itemCount: _razas.length,
        itemBuilder: (_, index) {
          final raza = _razas[index];
          return ListTile(
            title: Text(raza['descripcion'] ?? ''),
            subtitle: Text('Código: ${raza['codRaza']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirFormulario(raza: raza, index: index)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminarRaza(index)),
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
