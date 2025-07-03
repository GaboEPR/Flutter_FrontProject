import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectadas_flutter/Models/raza.dart';
import 'package:proyectadas_flutter/data/providers/razas_provider.dart';

import '../../../Models/animal.dart';
import '../../../services/animales_services.dart';

class AnimalesFormScreen extends StatefulWidget {
  final Animal? animal;

  const AnimalesFormScreen({super.key, this.animal});

  @override
  State<AnimalesFormScreen> createState() => _AnimalesFormScreenState();
}

class _AnimalesFormScreenState extends State<AnimalesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codAnimalController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _edadController = TextEditingController();
  final _colorPelajeController = TextEditingController();
  final _colorOjosController = TextEditingController();

  String _sexoSeleccionado = 'Macho';
  String? _razaSeleccionada;
  bool _isLoading = false;

  bool get _isEditing => widget.animal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _llenarFormulario();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RazaProvider>(context, listen: false);
      if (provider.isEmpty) provider.cargarRazas();
    });
  }

  void _llenarFormulario() {
    final animal = widget.animal!;
    _codAnimalController.text = animal.codAnimal;
    _descripcionController.text = animal.descripcion;
    _sexoSeleccionado = animal.sexo;
    _edadController.text = animal.edad.toString();
    _razaSeleccionada = animal.codRaza;
    _colorPelajeController.text = animal.colorPelaje;
    _colorOjosController.text = animal.colorOjos;
  }

  Future<void> _guardarAnimal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_razaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una raza'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final razaProvider = Provider.of<RazaProvider>(context, listen: false);
      final raza = razaProvider.obtenerRazaPorCodigo(_razaSeleccionada!);

      final animal = Animal(
        codAnimal: _codAnimalController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        sexo: _sexoSeleccionado,
        edad: int.parse(_edadController.text.trim()),
        codRaza: _razaSeleccionada!,
        colorPelaje: _colorPelajeController.text.trim(),
        colorOjos: _colorOjosController.text.trim(),
        raza: Raza.fromMap(raza!), // asegúrate de tener fromMap en tu modelo
      );

      if (_isEditing) {
        await AnimalesService.updateAnimal(widget.animal!.codAnimal, animal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Animal actualizado correctamente'), backgroundColor: Colors.green),
          );
        }
      } else {
        await AnimalesService.crearAnimal(animal.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Animal creado correctamente'), backgroundColor: Colors.green),
          );
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _codAnimalController.dispose();
    _descripcionController.dispose();
    _edadController.dispose();
    _colorPelajeController.dispose();
    _colorOjosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final razaProvider = Provider.of<RazaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Animal' : 'Nuevo Animal')),
      body: razaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _codAnimalController,
                      decoration: const InputDecoration(
                        labelText: 'Código del Animal',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tag),
                      ),
                      enabled: !_isEditing,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'El código es requerido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'La descripción es requerida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _sexoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: ['Macho', 'Hembra']
                          .map((sexo) => DropdownMenuItem(value: sexo, child: Text(sexo)))
                          .toList(),
                      onChanged: (value) => setState(() => _sexoSeleccionado = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _edadController,
                      decoration: const InputDecoration(
                        labelText: 'Edad (años)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'La edad es requerida';
                        final edad = int.tryParse(value.trim());
                        if (edad == null || edad <= 0) return 'Ingresa una edad válida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _razaSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Raza',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pets),
                      ),
                      items: razaProvider.dropdownItems,
                      onChanged: (value) => setState(() => _razaSeleccionada = value),
                      validator: (value) => value == null ? 'Selecciona una raza' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorPelajeController,
                      decoration: const InputDecoration(
                        labelText: 'Color del Pelaje',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.color_lens),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'El color del pelaje es requerido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorOjosController,
                      decoration: const InputDecoration(
                        labelText: 'Color de Ojos',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.remove_red_eye),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'El color de ojos es requerido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _guardarAnimal,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(_isEditing ? 'Actualizar' : 'Guardar'),
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
