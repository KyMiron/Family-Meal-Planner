import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/recipe_list.dart';
import 'screens/calendar.dart';
import 'screens/inventory.dart';
import 'screens/admin_panel.dart';

class MainTabScreen extends StatefulWidget {
  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RecipeListScreen(),
    CalendarScreen(),
    InventoryScreen(),
  ];

  final List<String> _titles = [
    "Upcoming Meals",
    "Recipes",
    "Meal Calendar",
    "Inventory",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.green, // ACTIVE icon/text color
        unselectedItemColor: Colors.grey, // INACTIVE icon/text color
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Meals'),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
