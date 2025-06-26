import 'package:flutter/material.dart';

class AnimalesFormScreen extends StatefulWidget {
  final Map<String, dynamic>? animal;

  const AnimalesFormScreen({super.key, this.animal});

  @override
  State<AnimalesFormScreen> createState() => _AnimalesFormScreenState();
}

class _AnimalesFormScreenState extends State<AnimalesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codAnimalController;
  late TextEditingController _descripcionController;
  late TextEditingController _sexoController;
  late TextEditingController _edadController;
  late TextEditingController _codRazaController;
  late TextEditingController _colorPelajeController;
  late TextEditingController _colorOjosController;

  @override
  void initState() {
    super.initState();
    _codAnimalController = TextEditingController(text: widget.animal?['codAnimal']);
    _descripcionController = TextEditingController(text: widget.animal?['descripcion']);
    _sexoController = TextEditingController(text: widget.animal?['sexo']);
    _edadController = TextEditingController(text: widget.animal?['edad']?.toString());
    _codRazaController = TextEditingController(text: widget.animal?['codRaza']);
    _colorPelajeController = TextEditingController(text: widget.animal?['colorPelaje']);
    _colorOjosController = TextEditingController(text: widget.animal?['colorOjos']);
  }

  @override
  void dispose() {
    _codAnimalController.dispose();
    _descripcionController.dispose();
    _sexoController.dispose();
    _edadController.dispose();
    _codRazaController.dispose();
    _colorPelajeController.dispose();
    _colorOjosController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'codAnimal': _codAnimalController.text,
        'descripcion': _descripcionController.text,
        'sexo': _sexoController.text,
        'edad': int.tryParse(_edadController.text) ?? 0,
        'codRaza': _codRazaController.text,
        'colorPelaje': _colorPelajeController.text,
        'colorOjos': _colorOjosController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.animal != null ? 'Editar Animal' : 'Nuevo Animal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _codAnimalController, decoration: const InputDecoration(labelText: 'Código'), validator: _required),
              TextFormField(controller: _descripcionController, decoration: const InputDecoration(labelText: 'Descripción'), validator: _required),
              TextFormField(controller: _sexoController, decoration: const InputDecoration(labelText: 'Sexo'), validator: _required),
              TextFormField(controller: _edadController, decoration: const InputDecoration(labelText: 'Edad'), keyboardType: TextInputType.number, validator: _required),
              TextFormField(controller: _codRazaController, decoration: const InputDecoration(labelText: 'Código de Raza'), validator: _required),
              TextFormField(controller: _colorPelajeController, decoration: const InputDecoration(labelText: 'Color del Pelaje'), validator: _required),
              TextFormField(controller: _colorOjosController, decoration: const InputDecoration(labelText: 'Color de Ojos'), validator: _required),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => (value == null || value.isEmpty) ? 'Campo requerido' : null;
}
