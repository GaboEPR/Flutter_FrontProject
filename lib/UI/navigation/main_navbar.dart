import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/config/config_screen.dart';
import '../screens/animales/animales_list_screen.dart';
import '../screens/razas/razas_list_screen.dart';

class MainNavbar extends StatefulWidget {
  const MainNavbar({super.key});

  static _MainNavbarState? of(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainNavbarState>();
    return state;
  }

  @override
  State<MainNavbar> createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnimalesListScreen(),
    RazasListScreen(),
    ConfigScreen(),
  ];

  void changeTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => changeTab(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.green[200],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Razas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
