import 'package:flutter/material.dart';

class RazaFormScreen extends StatefulWidget {
  final Map<String, String>? raza;

  const RazaFormScreen({super.key, this.raza});

  @override
  State<RazaFormScreen> createState() => _RazaFormScreenState();
}

class _RazaFormScreenState extends State<RazaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codRazaController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _codRazaController = TextEditingController(text: widget.raza?['codRaza']);
    _descripcionController = TextEditingController(text: widget.raza?['descripcion']);
  }

  @override
  void dispose() {
    _codRazaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'codRaza': _codRazaController.text,
        'descripcion': _descripcionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.raza != null ? 'Editar Raza' : 'Nueva Raza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codRazaController,
                decoration: const InputDecoration(labelText: 'Código de Raza'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
