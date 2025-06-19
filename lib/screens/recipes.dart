import 'package:flutter/material.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text("Your Recipes")),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // TODO: Add recipe creation logic
      },
      child: Icon(Icons.add),
      tooltip: "Add Recipe",
    ),
  );
}
