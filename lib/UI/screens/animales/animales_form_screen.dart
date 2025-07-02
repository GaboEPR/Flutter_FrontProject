import 'package:flutter/material.dart';
import '../../../models/animal.dart';
import '../../../services/animales_services.dart'; // Importa el servicio de animales
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AnimalesFormScreen extends StatefulWidget {
  final Animal? animal;

  const AnimalesFormScreen({super.key, this.animal});

  @override
  State<AnimalesFormScreen> createState() => _AnimalesFormScreenState();
}

class PickImage extends StatefulWidget {
  final void Function(Uint8List?) onImagePicked;

  const PickImage({super.key, required this.onImagePicked});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Uint8List? _image;

  void _pickImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file == null) return;
    final imageBytes = await File(file.path).readAsBytes();
    setState(() => _image = imageBytes);
    widget.onImagePicked(_image);
    Navigator.of(context).pop();
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage:
              _image != null
                  ? MemoryImage(_image!)
                  : const NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                      )
                      as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _showOptions,
          ),
        ),
      ],
    );
  }
}

class _AnimalesFormScreenState extends State<AnimalesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codAnimalController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _edadController = TextEditingController();
  final _colorPelajeController = TextEditingController();
  final _colorOjosController = TextEditingController();
  late final Uint8List? _pickedImage;

  String _sexoSeleccionado = 'Macho';
  String? _razaSeleccionada;
  List<Raza> _razas = [];
  bool _isLoading = false;
  bool _isLoadingRazas = true;

  bool get _isEditing => widget.animal != null;

  @override
  void initState() {
    super.initState();
    _cargarRazas();
    if (_isEditing) {
      _llenarFormulario();
    }
  }

  void _llenarFormulario() {
    final animal = widget.animal!;
    _codAnimalController.text = animal.codAnimal;
    _descripcionController.text = animal.descripcion;
    _sexoSeleccionado = animal.sexoFormateado;
    _edadController.text = animal.edad.toString();
    _razaSeleccionada = animal.codRaza;
    _colorPelajeController.text = animal.colorPelaje;
    _colorOjosController.text = animal.colorOjos;
    _pickedImage = animal.imagen; // Asigna la imagen del animal
  }

  Future<void> _cargarRazas() async {
    try {
      final razas = await AnimalesService.getRazas();
      setState(() {
        _razas = razas.cast<Raza>();
        _isLoadingRazas = false;

        if (_isEditing && widget.animal!.raza != null) {
          final razaActual = widget.animal!.raza!;
          final existeRaza = _razas.any((r) => r.codRaza == razaActual.codRaza);
          if (!existeRaza) {
            _razas.add(razaActual);
          }
          _razaSeleccionada = razaActual.codRaza;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingRazas = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar razas: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _guardarAnimal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_razaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una raza'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final animal = Animal(
        codAnimal: _codAnimalController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        sexo: _sexoSeleccionado,
        edad: int.parse(_edadController.text.trim()),
        codRaza: _razaSeleccionada!,
        colorPelaje: _colorPelajeController.text.trim(),
        colorOjos: _colorOjosController.text.trim(),
        raza: _razas.firstWhere((r) => r.codRaza == _razaSeleccionada),
      );

      if (_isEditing) {
        await AnimalesService.actualizarAnimal(
          widget.animal!.codAnimal,
          animal.toJson(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Animal actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await AnimalesService.crearAnimal(animal as Map<String, dynamic>);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Animal creado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Animal' : 'Nuevo Animal'),
      ),
      body:
          _isLoadingRazas
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
                          if (value == null || value.trim().isEmpty)
                            return 'El código es requerido';
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
                          if (value == null || value.trim().isEmpty)
                            return 'La descripción es requerida';
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
                        items:
                            ['Macho', 'Hembra']
                                .map(
                                  (sexo) => DropdownMenuItem(
                                    value: sexo,
                                    child: Text(sexo),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => _sexoSeleccionado = value!),
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
                          if (value == null || value.trim().isEmpty)
                            return 'La edad es requerida';
                          final edad = int.tryParse(value.trim());
                          if (edad == null || edad <= 0)
                            return 'Ingresa una edad válida';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _razaSeleccionada,
                        decoration: const InputDecoration(
                          labelText: 'Código de Raza',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.pets),
                        ),
                        items:
                            _razas
                                .map(
                                  (raza) => DropdownMenuItem(
                                    value: raza.codRaza,
                                    child: Text(raza.descripcion),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => _razaSeleccionada = value),
                        validator:
                            (value) =>
                                value == null ? 'Selecciona una raza' : null,
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
                          if (value == null || value.trim().isEmpty)
                            return 'El color del pelaje es requerido';
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
                          if (value == null || value.trim().isEmpty)
                            return 'El color de ojos es requerido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          PickImage(
                            onImagePicked: (image) {
                              setState(() => _pickedImage = image);
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _guardarAnimal,
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        _isEditing ? 'Actualizar' : 'Guardar',
                                      ),
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
