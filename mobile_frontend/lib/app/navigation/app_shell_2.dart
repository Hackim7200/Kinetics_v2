import 'package:flutter/material.dart';

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

  final List<Widget> _pages = [
  
    Center(child: Text('Home')),
    Center(child: Text('Settings')),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
