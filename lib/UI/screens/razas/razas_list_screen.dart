import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectadas_flutter/data/providers/razas_provider.dart';
import 'razas_form_screen.dart';

class RazasListScreen extends StatefulWidget {
  const RazasListScreen({super.key});

  @override
  State<RazasListScreen> createState() => _RazasListScreenState();
}

class _RazasListScreenState extends State<RazasListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RazaProvider>(context, listen: false).cargarRazas());
  }

  void _abrirFormulario({Map<String, dynamic>? raza, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RazaFormScreen(
          raza: raza?.map((key, value) => MapEntry(key, value?.toString() ?? '')),
        ),
      ),
    );

    if (result != null && mounted) {
      Provider.of<RazaProvider>(context, listen: false).cargarRazas();
    }
  }

  void _eliminarRaza(String codRaza) async {
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
      await Provider.of<RazaProvider>(context, listen: false).eliminarRaza(codRaza);
    }
  }

  @override
  Widget build(BuildContext context) {
    final razaProvider = Provider.of<RazaProvider>(context);
    final razas = razaProvider.razas;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Razas')),
      body: razaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : razas.isEmpty
              ? const Center(child: Text('No hay razas registradas'))
              : ListView.builder(
                  itemCount: razas.length,
                  itemBuilder: (_, index) {
                    final raza = razas[index];
                    return ListTile(
                      title: Text(raza['descripcion'] ?? ''),
                      subtitle: Text('Código: ${raza['codRaza']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _abrirFormulario(raza: raza, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarRaza(raza['codRaza']),
                          ),
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
