import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class RestrictedCalendar extends StatefulWidget {
  final String startDate;
  final String endDate;

  const RestrictedCalendar({
    required this.startDate,
    required this.endDate,
    Key? key,
  }) : super(key: key);

  @override
  _RestrictedCalendarState createState() => _RestrictedCalendarState();
}

class _RestrictedCalendarState extends State<RestrictedCalendar> {
  late DateTime _startDate;
  late DateTime _endDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Parse startDate and endDate from the API
    _startDate = DateTime.parse(widget.startDate); // Format: yyyy-MM-dd
    _endDate = DateTime.parse(widget.endDate); // Format: yyyy-MM-dd
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restricted Calendar"),
      ),
      body: TableCalendar(
        firstDay: DateTime(2000), // Arbitrary start limit
        lastDay: DateTime(2100), // Arbitrary end limit
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          // Allow selection only within the range
          if (selectedDay
                  .isAfter(_startDate.subtract(const Duration(days: 1))) &&
              selectedDay.isBefore(_endDate.add(const Duration(days: 1)))) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay =
                  focusedDay; // Update focused day to the selected day
            });
          } else {
            // Show a message if the date is out of range
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please select a date within the allowed range."),
              ),
            );
          }
        },
        calendarBuilders: CalendarBuilders(
          // Disable dates outside the range
          defaultBuilder: (context, day, focusedDay) {
            if (day.isBefore(_startDate) || day.isAfter(_endDate)) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.grey), // Grey out the dates
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
