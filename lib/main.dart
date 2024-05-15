import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop> {
  final CalendarController _calendarController = CalendarController();

  final List<Schedule> _items = [
    Schedule.defaultData(),
    Schedule.defaultData(),
    Schedule.defaultData(),
  ];
  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              children: [
                FilledButton(
                    onPressed: () {
                      _calendarController.view = CalendarView.month;
                    },
                    child: const Text('Month')),
                FilledButton(
                    onPressed: () {
                      _calendarController.view = CalendarView.week;
                    },
                    child: const Text('Week')),
                FilledButton(
                    onPressed: () {
                      _calendarController.view = CalendarView.day;
                    },
                    child: const Text('Day')),
              ],
            ),
            Expanded(
              child: SfCalendar(
                controller: _calendarController,
                view: CalendarView.month,
                dataSource: ScheduleDataSource(_items),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayCount: 3,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                selectionDecoration:
                    const BoxDecoration(color: Colors.transparent),
                allowDragAndDrop: true,
                onDragEnd: _onDragEnd,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onDragEnd(appointmentDragEndDetails) {
    final dragedItem = appointmentDragEndDetails.appointment as Schedule;
    final originItem =
        _items.firstWhere((element) => element.id == dragedItem.id);
    Duration diff = originItem.endDate.difference(originItem.startDate);
    dragedItem.startDate = appointmentDragEndDetails.droppingTime!;
    dragedItem.endDate = appointmentDragEndDetails.droppingTime!.add(diff);
    setState(() {});
  }
}

class ScheduleDataSource extends CalendarDataSource<Schedule> {
  List<Schedule> source;

  ScheduleDataSource(this.source);

  @override
  List<dynamic> get appointments => source;

  @override
  Object? getId(int index) {
    return source[index].id;
  }

  @override
  DateTime getStartTime(int index) {
    return source[index].startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endDate;
  }

  @override
  String getSubject(int index) {
    return source[index].name;
  }

  @override
  Color getColor(int index) {
    return source[index].color;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  Schedule? convertAppointmentToObject(
      Schedule? customData, Appointment appointment) {
    return customData;
  }
}

class Schedule {
  int id;
  String name;
  Color color;
  DateTime startDate, endDate;
  bool isAllDay;

  Schedule({
    required this.id,
    required this.name,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
  });

  factory Schedule.defaultData() => Schedule(
      id: 0,
      name: 'name',
      color: Colors.blue,
      startDate: DateTime.now(),
      endDate: DateTime.now().subtract(const Duration(hours: 1)),
      isAllDay: false);
}
