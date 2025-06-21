import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../data/providers/config_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Animales'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bienvenida
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.pets,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sistema de Gestión de Animales',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Administra animales y razas de forma eficiente',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Opciones principales
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Animales',
                    'Gestionar registros de animales',
                    Icons.pets,
                    Colors.blue,
                    '/animales',
                  ),
                  _buildMenuCard(
                    context,
                    'Razas',
                    'Administrar razas disponibles',
                    Icons.category,
                    Colors.orange,
                    '/razas',
                  ),
                  _buildMenuCard(
                    context,
                    'Configuración',
                    'Ajustes del servidor',
                    Icons.settings,
                    Colors.grey,
                    '/config',
                  ),
                  _buildMenuCard(
                    context,
                    'Estadísticas',
                    'Ver reportes y datos',
                    Icons.bar_chart,
                    Colors.purple,
                    null, // Por implementar
                  ),
                ],
              ),
            ),
            
            // Estado de conexión
            Consumer<ConfigProvider>(
              builder: (context, configProvider, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: configProvider.isConfigured 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: configProvider.isConfigured 
                          ? Colors.green 
                          : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        configProvider.isConfigured 
                            ? Icons.cloud_done 
                            : Icons.cloud_off,
                        color: configProvider.isConfigured 
                            ? Colors.green 
                            : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          configProvider.isConfigured
                              ? 'Conectado: ${configProvider.serverUrl}'
                              : 'Sin configurar servidor',
                          style: TextStyle(
                            color: configProvider.isConfigured 
                                ? Colors.green 
                                : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String? route,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: route != null 
            ? () => Navigator.pushNamed(context, route)
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad en desarrollo'),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          
          // Move CustomDrawer outside of HomeScreen
          class CustomDrawer extends StatelessWidget {
            const CustomDrawer({Key? key}) : super(key: key);
          
            @override
            Widget build(BuildContext context) {
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Text(
                        'Menú',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pets),
                      title: const Text('Animales'),
                      onTap: () {
                        Navigator.pushNamed(context, '/animales');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('Razas'),
                      onTap: () {
                        Navigator.pushNamed(context, '/razas');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Configuración'),
                      onTap: () {
                        Navigator.pushNamed(context, '/config');
                      },
                    ),
                  ],
                ),
              );
            }
          }