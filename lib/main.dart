import 'package:flutter/material.dart';
import 'main_tab_screen.dart';

void main() {
  runApp(MealPlannerApp());
}

class MealPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainTabScreen(),
    );
  }
}
