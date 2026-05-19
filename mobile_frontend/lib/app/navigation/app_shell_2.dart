import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/circuit/circuit_dashboard_screen.dart';
import 'package:mobile_frontend/feature/routine/routine_list_screen.dart';

class AppShell2 extends StatefulWidget {
  const AppShell2({super.key});

  @override
  State<AppShell2> createState() => _AppShell2State();
}

class _AppShell2State extends State<AppShell2> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [RoutineListScreen(), CircuitDashboardScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Routines',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.loop), label: 'Circuits'),
        ],
      ),
    );
  }
}
