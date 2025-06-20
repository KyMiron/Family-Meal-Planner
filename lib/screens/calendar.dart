import 'package:flutter/material.dart';
import 'package:meal_planner/models/meal_plan.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/database_helper.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  final _db = DatabaseHelper();

  Map<DateTime, List<String>> _mealsByDate = {}; // date -> [recipeTitle]

  Future<void> _loadMealPlans() async {
    final db = _db;
    final mealPlanMaps = await db.getAllMealPlans();
    final recipeMaps = await db.getAllRecipes();

    final recipes = {for (var r in recipeMaps) r.id: r.title};

    final map = <DateTime, List<String>>{};
    for (var plan in mealPlanMaps) {
      final date = DateTime.parse(plan.date).toLocal();
      final recipeTitle = recipes[plan.recipeId] ?? 'Unknown';
      map.update(
        date,
        (existing) => [...existing, recipeTitle],
        ifAbsent: () => [recipeTitle],
      );
    }

    setState(() {
      _mealsByDate = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadMealPlans();
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2030),
          focusedDay: _focusedDay,
          eventLoader: (day) {
            return _mealsByDate[DateTime(day.year, day.month, day.day)] ?? [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return null;
              return Column(
                children: events
                    .map(
                      (title) => Text(
                        title.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          onDaySelected: _onDaySelected,
        ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _focusedDay = focusedDay;
    });

    final db = _db;
    final recipes = await db.getAllRecipes();

    final selected = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(
          "Select Recipe for ${selectedDay.toLocal().toString().split(' ')[0]}",
        ),
        children: recipes.map((recipe) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, recipe.id),
            child: Text(recipe.title),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      final dateKey = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );
      final existing = await db.getMealPlanByDate(dateKey.toIso8601String());

      if (existing != null) {
        db.updateMealPlan(
          MealPlan(id: existing.id, date: existing.date, recipeId: selected),
        );
      } else {
        db.saveMealPlan(dateKey.toIso8601String(), selected);
      }

      _loadMealPlans(); // reload calendar display
    }
  }
}
