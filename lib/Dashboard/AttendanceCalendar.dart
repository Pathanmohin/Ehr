import 'dart:convert';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class AttendanceCalendar extends StatefulWidget {
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  List<AttendHistory> attendHistory = [];
  Map<DateTime, AttendHistory> _attendHistoryMap = {}; // Map to store the data by date
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _firstDateOfMonth;
  bool intime=true;
  bool outtime =true;
  bool holiday=true;
  // String? monthYear; // To store the first date of the month as a string

  @override
  void initState() {
    super.initState();
    onGetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar',style: TextStyle(
                    color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),),
        backgroundColor: Colors.blue,
        leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
      ),
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Update focused day to selected day
              });
                AttendHistory? attendData = _attendHistoryMap[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)];  // Normalize day
            if (attendData != null) {
             
              // Show the pop-up message with attendance information
              _showAttendanceDialog(context, attendData);
            } else {
              // If no data available for the selected day, show a pop-up with a message
              _showNoDataDialog(context);
            }
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                onGetList();
                _firstDateOfMonth =
                    '${DateTime(focusedDay.year, focusedDay.month, 01).day}/${focusedDay.month}/${focusedDay.year}';
              });
            },
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 30),
              weekendTextStyle: TextStyle(fontSize: 30, color: Colors.red),
              selectedTextStyle: TextStyle(fontSize: 20, color: Colors.white),
              cellMargin: EdgeInsets.all(4.0),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 20),
              weekendStyle: TextStyle(fontSize: 20, color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              titleTextStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              formatButtonVisible: false, // Hide the format button
            ),
            daysOfWeekHeight: 40,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                List<Widget> dayWidgets = [];
                dayWidgets.add(Text('${day.day}', style: const TextStyle(fontSize: 20)));
        
                // Check if this date has attendance data
                AttendHistory? attendData = _attendHistoryMap[DateTime(day.year, day.month, day.day)];  // Normalize day
        
                if (attendData != null) {

                             
                  if (attendData.iday == "O"  && attendData.istatus == "P") {
                    dayWidgets.add(const Flexible(child: Text('Present', style: TextStyle(color: Colors.green, fontSize: 10))));
                  } 
                  else if (attendData.iday == "O"  && attendData.istatus == "H") {
                    dayWidgets.add(const Flexible(child: Text('Half Day', style: TextStyle(color: Colors.yellow, fontSize: 10))));
                  } 
                  if (attendData.iday == "O"  && attendData.istatus == "T") {
                    dayWidgets.add(const Flexible(child: Text('Tour ', style: TextStyle(color: Color.fromARGB(255, 118, 59, 255), fontSize: 10))));
                  } 

                   else if (attendData.iday=="O" && attendData.istatus=="A" ){
                    dayWidgets.add(Flexible(child: Text(attendData.idaystatus.toString(), style: const TextStyle(color: Colors.orange, fontSize: 8))));
        
                  }
                  else if (attendData.iday=="W" && attendData.istatus=="A"){
                       dayWidgets.add(const Flexible(child: Text('Absent', style: TextStyle(color: Colors.red, fontSize: 10))));
        
                  }
                   else if (attendData.iday=="W" && attendData.istatus=="P"){
                dayWidgets.add(const Flexible(child: Text('Present', style: TextStyle(color: Colors.green, fontSize: 10))));
        
                  }
                   else if (attendData.iday=="W" && attendData.istatus=="R"){
                dayWidgets.add(const Flexible(child: Text('Requested', style: TextStyle(color: Color.fromARGB(255, 175, 76, 76), fontSize: 10))));
        
                  }
                  else if (attendData.iday=="W"&& attendData.istatus=="H")
                  {
                 dayWidgets.add(const Flexible(child: Text('Half Day', style: TextStyle(color: Colors.yellow, fontSize: 10))));
                  }
                   else if (attendData.iday=="W"&& attendData.istatus=="L")
                  {
                 dayWidgets.add(const Flexible(child: Text('Leave', style: TextStyle(color: Color.fromARGB(255, 165, 175, 76), fontSize: 10))));
                  }
                   else if (attendData.iday=="W"&& attendData.istatus=="T")
                  {
                 dayWidgets.add(const Flexible(child: Text('Tour', style: TextStyle(color:  Color.fromARGB(255, 118, 59, 255), fontSize: 10))));
                  }
                 
                }
        
                // Custom cell styling
                if (isSameDay(day, DateTime.now())) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayWidgets,
                    ),
                  );
                }
        
                if (isSameDay(_selectedDay, day)) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayWidgets,
                    ),
                  );
                }
        
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dayWidgets,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

void _showAttendanceDialog(BuildContext context, AttendHistory attendData) {
if (attendData.Intime==null && attendData.outtime==null && attendData.iday=="W" ){
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.lightBlue[50], // Set background color
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: intime,
              child: const Text(
                'In Time:  ',
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
            Visibility(
              visible: outtime,
              child: const Text(
                'Out Time: ',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            Flexible(
              child: Visibility(
                visible: holiday,
                child: const Text(
                  'Shift Time: ',
                  style: TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ),
            ),
           
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Add background color to button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
else if (attendData.Intime==null&& attendData.outtime==null&& attendData.iday=="O")
{
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.lightBlue[50], // Set background color
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: intime,
              child: const Text(
                'In Time:  ',
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
            Visibility(
              visible: outtime,
              child: const Text(
                'Out Time: ',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Add background color to button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
} 
else if (attendData.Intime!=null && attendData.outtime!=null &&attendData.idaystatus!=null) { 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.lightBlue[50], // Set background color
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: intime,
              child: Text(
                'In Time: ${attendData.Intime}',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
            Visibility(
              visible: outtime,
              child: Text(
                'Out Time: ${attendData.outtime}',
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            Flexible(
              child: Visibility(
                visible: holiday,
                child: Text(
                  'General Shift: ${attendData.idaystatus}',
                  style: const TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ),
            ),
           
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Add background color to button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
else if (attendData.Intime!=null && attendData.outtime!=null ) { 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.lightBlue[50], // Set background color
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: intime,
              child: Text(
                'In Time: ${attendData.Intime}',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
            Visibility(
              visible: outtime,
              child: Text(
                'Out Time: ${attendData.outtime}',
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            Flexible(
              child: Visibility(
                visible: holiday,
                child: const Text(
                  'General Shift: ',
                  style: TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ),
            ),
           
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Add background color to button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
}

// Function to show a dialog when no data is available
void _showNoDataDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.amber[50], // Set background color
        title: const Text(
          'No Attendance Data',
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'No attendance data is available for the selected date.',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent, // Add background color to button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}



  Future<void> onGetList() async {
    try {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();
      if(_firstDateOfMonth==null)
      {
         DateTime now = DateTime.now();
      String  monthYear = "01/"+"${now.month}/${now.year}";
_firstDateOfMonth=monthYear;
      }
      
    //  monthYear = _firstDateOfMonth ?? dateFormat.format(DateTime(now.year, now.month, 1));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();
      

     
      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=Calendarwiseholiday&EmpKid=$empKid&date=$_firstDateOfMonth';
      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        attendHistory = data.map((json) => AttendHistory.fromJson(json)).toList();

        // Map the AttendHistory data to their respective dates
        for (var item in attendHistory) {
          try {
            // Parse showDate_ to DateTime using the correct format
            DateTime date = dateFormat.parse(item.showDate_);
            DateTime normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date
            _attendHistoryMap[normalizedDate] = item; // Store the data in the map
          } catch (e) {
            print('Error parsing date: $e'); // Log any date parsing errors
          }
        }

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}




class AttendHistory {
  final String showDate_;
  final String istatus;
  final String iday;
  final String Hoiliday;
  final String? idaystatus;
  final String? Intime;
  final String? outtime;

  AttendHistory({
    required this.showDate_,
    required this.istatus,
    required this.iday,
    required this.Hoiliday,
    this.idaystatus,
    this.Intime,
    this.outtime,
  });

  factory AttendHistory.fromJson(Map<String, dynamic> json) {
    return AttendHistory(
      showDate_: json['showDate_'],
      istatus: json['istatus'],
      iday: json['iday'],
      Hoiliday: json['Hoiliday'],
     idaystatus: json['idaystatus'],
     Intime:json['Intime'],
     outtime:json['outtime'],

    );
  }
}
