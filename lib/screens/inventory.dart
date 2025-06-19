import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      ListTile(title: Text("Pantry Item 1")),
      ListTile(title: Text("Pantry Item 2")),
    ],
  );
}
