import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/config_provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _dbController;
  late TextEditingController _userController;
  late TextEditingController _passwordController;

  String _selectedDbEngine = 'PostgreSQL';

  @override
  void initState() {
    super.initState();
    final config = Provider.of<ConfigProvider>(context, listen: false);

    _selectedDbEngine = config.dbEngine ?? 'PostgreSQL';
    _hostController = TextEditingController(text: config.dbHost ?? '');
    _portController = TextEditingController(text: config.dbPort ?? '');
    _dbController = TextEditingController(text: config.dbName ?? '');
    _userController = TextEditingController(text: config.dbUser ?? '');
    _passwordController = TextEditingController(text: config.dbPassword ?? '');
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _dbController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveConfiguration() {
    if (_formKey.currentState!.validate()) {
      final config = Provider.of<ConfigProvider>(context, listen: false);
      config.setDatabaseConfig(
        engine: _selectedDbEngine,
        host: _hostController.text.trim(),
        port: _portController.text.trim(),
        dbName: _dbController.text.trim(),
        user: _userController.text.trim(),
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final engines = ['PostgreSQL', 'MySQL', 'MSSQL'];

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Base de Datos')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDbEngine,
                decoration: const InputDecoration(labelText: 'Motor de Base de Datos'),
                items: engines
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedDbEngine = value!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Host'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Puerto'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dbController,
                decoration: const InputDecoration(labelText: 'Nombre de la Base de Datos'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveConfiguration,
                icon: const Icon(Icons.save),
                label: const Text('Guardar configuración'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
