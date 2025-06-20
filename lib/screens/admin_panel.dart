import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String _output = '';
  final _db = DatabaseHelper();
  Future<void> _resetDatabase() async {
    final db = _db;
    await db.resetDatabase();
    setState(() {
      _output = 'All tables cleared.';
    });
  }

  Future<void> _seedSampleData() async {
    final db = _db;
    db.seedDatabase();

    setState(() {
      _output = 'Database is seeded';
    });
  }

  Future<void> _showTable(String table) async {
    final db = _db;
    final rows = await db.getTable(table);
    setState(() {
      _output = '$table:\n${rows.map((e) => e.toString()).join('\n')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: _resetDatabase,
            child: const Text('Wipe Database'),
          ),
          ElevatedButton(
            onPressed: _seedSampleData,
            child: const Text('Seed Sample Data'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showTable('recipes'),
            child: const Text('View Recipes'),
          ),
          ElevatedButton(
            onPressed: () => _showTable('ingredients'),
            child: const Text('View Ingredients'),
          ),
          ElevatedButton(
            onPressed: () => _showTable('mealplans'),
            child: const Text('View Meal Plans'),
          ),
          const SizedBox(height: 20),
          Text(_output),
        ],
      ),
    );
  }
}
