import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) {
      final isToday = index == 0;
      return Card(
        elevation: isToday ? 6 : 2,
        color: isToday ? Colors.green[100] : null,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(
            isToday ? "Today's Meal" : "Upcoming Meal ${index + 1}",
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text("Meal details go here..."),
        ),
      );
    },
  );
}
