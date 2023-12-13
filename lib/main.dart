import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar App'),
      ),
      body: MyCalendarWidget(),
    );
  }
}

class MyCalendarWidget extends StatefulWidget {
  @override
  _MyCalendarWidgetState createState() => _MyCalendarWidgetState();
}

class _MyCalendarWidgetState extends State<MyCalendarWidget> {
  int _selectedYear = DateTime.now().year;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  IconData _getSeasonIcon(DateTime date) {
    int month = date.month;
    switch (month) {
      case 12:
      case 1:
      case 2:
        return Icons.ac_unit; // Снежинка для зимы
      case 3:
      case 4:
      case 5:
        return Icons.local_florist; // Цветок для весны
      case 6:
      case 7:
      case 8:
        return Icons.wb_sunny; // Солнце для лета
      case 9:
      case 10:
      case 11:
        return Icons.umbrella; // Зонт для осени
      default:
        return Icons.error; // Иконка ошибки
    }
  }

  bool isSameMonth(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
    TableCalendar(
    firstDay: DateTime.utc(2010, 10, 16),
    lastDay: DateTime.utc(2030, 3, 14),
    focusedDay: _focusedDay,
    calendarFormat: CalendarFormat.month,
    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
    onDaySelected: (selectedDay, focusedDay) {
    setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    });
    },
    onPageChanged: (focusedDay) {
    setState(() {
    _focusedDay = focusedDay;
    });
    },
    headerStyle: HeaderStyle(
    titleCentered: true,
    formatButtonVisible: false,
    leftChevronIcon: Icon(Icons.chevron_left),
    rightChevronIcon: Icon(Icons.chevron_right),
    titleTextStyle: TextStyle(fontSize: 16),
    decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(4.0),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    DropdownButton<int>(
    value: _selectedYear,
    items: List.generate(21, (index) {
    // Список из 21 года (10 лет вперед и 10 лет назад)
    int year = DateTime.now().year - 10 + index;
    return DropdownMenuItem<int>(
    value: year,
    child: Text('$year'),
    );
    }),
    onChanged: (int? value) {
    if (value != null) {
    setState(() {
    _selectedYear = value;
    _focusedDay = DateTime(_selectedYear, _focusedDay.month, 1);
    });
    }
    },
    ),
    SizedBox(width: 8),
    Icon(_getSeasonIcon(_focusedDay)),
    SizedBox(width: 8),
    Text(DateFormat.yMMMM().format(_focusedDay)),
    ],
    ),
    ),
    if (!isSameMonth(_focusedDay, DateTime.now())) // Показывать кнопку только если выбран не текущий месяц
    ElevatedButton(
    child: Text('Вернуться к текущему месяцу'),onPressed: () {
      setState(() {
        _focusedDay = DateTime.now();
      });
    },
    ),

        ],
    );
  }
}