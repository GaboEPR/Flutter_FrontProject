import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectadas_flutter/data/providers/razas_provider.dart';
import 'package:proyectadas_flutter/services/animales_services.dart';

class RazaFormScreen extends StatefulWidget {
  final Map<String, String>? raza;

  const RazaFormScreen({super.key, this.raza});

  @override
  State<RazaFormScreen> createState() => _RazaFormScreenState();
}

class _RazaFormScreenState extends State<RazaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codRazaController = TextEditingController();
  final _descripcionController = TextEditingController();

  bool get isEditing => widget.raza != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _codRazaController.text = widget.raza?['codRaza'] ?? '';
      _descripcionController.text = widget.raza?['descripcion'] ?? '';
    }
  }

  @override
  void dispose() {
    _codRazaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final razaProvider = Provider.of<RazaProvider>(context, listen: false);
    razaProvider.clearMessages();

    final data = {
      'cod_raza': _codRazaController.text.trim(),
      'descripcion': _descripcionController.text.trim(),
    };
    await AnimalesService.crearAnimal(data);
    bool success;
    if (isEditing) {
      success = await razaProvider.actualizarRaza(widget.raza!['codRaza']!, data);
    } else {
      success = await razaProvider.crearRaza(data);
    }

    if (mounted) {
      final message = razaProvider.message;
      final error = razaProvider.error;
      final snackBar = SnackBar(
        content: Text(message.isNotEmpty ? message : error),
        backgroundColor: success ? Colors.green : Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<RazaProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Raza' : 'Nueva Raza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codRazaController,
                enabled: !isEditing,
                decoration: const InputDecoration(
                  labelText: 'Código de Raza',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'El código es requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'La descripción es requerida' : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _guardar,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
