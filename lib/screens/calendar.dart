import 'package:flutter/material.dart';
import 'package:meal_planner/dialogues/date_selected.dart';
import 'package:meal_planner/dialogues/meal_plan_editor.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/database_helper.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  final _db = DatabaseHelper();

  Map<DateTime, List<Map<String, dynamic>>> _mealsByDate = {};

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  Future<void> _loadMealPlans() async {
    final db = _db;
    final mealPlanMaps = await db.getAllMealPlans();
    final recipeMaps = await db.getAllRecipes();
    final recipes = {for (var r in recipeMaps) r.id: r.title};

    final map = <DateTime, List<Map<String, dynamic>>>{};
    for (var plan in mealPlanMaps) {
      final fullDate = DateTime.parse(plan.date);
      final date = DateTime(fullDate.year, fullDate.month, fullDate.day);
      final recipeTitle = recipes[plan.recipeId] ?? 'Unknown';
      final mealType = plan.mealType;

      map.update(
        date,
        (existing) => [
          ...existing,
          {'title': recipeTitle, 'type': mealType},
        ],
        ifAbsent: () => [
          {'title': recipeTitle, 'type': mealType},
        ],
      );
    }

    setState(() {
      _mealsByDate = map;
    });
  }

  Color _colorForMealType(String type) {
    switch (type) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.blue;
      case 'dinner':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return null;
              return Wrap(
                spacing: 2,
                children: events.map((event) {
                  final e = event as Map<String, dynamic>;
                  final title = e['title'] ?? 'Meal';
                  final type = e['type'] ?? 'dinner';
                  final color = _colorForMealType(type);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                      overflow: TextOverflow.visible,
                    ),
                  );
                }).toList(),
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

    final mealId = await showDialog<String>(
      context: context,
      builder: (context) =>
          MealSelectDialog(selectedDate: selectedDay.toIso8601String()),
    );
    if (mealId != 'cancel') {
      await showDialog<String>(
        context: context,
        builder: (context) => MealPlanEditor(
          selectedDate: selectedDay.toIso8601String(),
          mealPlanId: mealId,
        ),
      );
    }

    _loadMealPlans(); // reload calendar display
  }
}
