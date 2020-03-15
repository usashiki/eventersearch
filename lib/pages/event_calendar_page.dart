import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/services/holidays_service.dart';
import 'package:eventernote/widgets/animated_event_tile.dart';
import 'package:eventernote/widgets/fade_indexed_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarPage extends StatefulWidget with NavigationPage {
  String get title => 'イベントカレンダー';
  String get navTitle => 'カレンダー';
  IconData get icon => CommunityMaterialIcons.calendar;

  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  Map<DateTime, List> _holidays;
  Map<DateTime, List> _events;
  DateTime _selectedDate; // used by PagewiseLoadController
  CalendarController _calendarController;
  PagewiseLoadController _pagewiseLoadController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _events = {};
    _populateEvents(
      _selectedDate.subtract(Duration(days: 40)),
      _selectedDate.add(Duration(days: 40)),
    );
    HolidaysService().isHoliday(_selectedDate); // populates holidays
    _holidays = HolidaysService().all;
    _calendarController = CalendarController();
    _pagewiseLoadController = PagewiseLoadController(
      pageSize: EventernoteService.PAGE_SIZE,
      pageFuture: (page) =>
          EventernoteService().getEventsForDate(_selectedDate, page),
    );
  }

  @override
  void dispose() {
    // _pagewiseLoadController.dispose(); // seems to break other pagewise pages?
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildCalendar(),
        SizedBox(height: 8.0),
        Expanded(
          child: Dismissible(
            key: ValueKey(_selectedDate.toIso8601String()),
            resizeDuration: null,
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                _calendarController.setSelectedDay(
                  _selectedDate.subtract(Duration(days: 1)),
                  runCallback: true,
                );
              } else {
                _calendarController.setSelectedDay(
                  _selectedDate.add(Duration(days: 1)),
                  runCallback: true,
                );
              }
            },
            child: PagewiseListView(
              pageLoadController: _pagewiseLoadController,
              itemBuilder: (context, event, i) {
                return Column(
                  children: <Widget>[
                    Divider(height: 0.5),
                    AnimatedEventTile(event),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ja_jp',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: {
        CalendarFormat.month: '月',
        // CalendarFormat.twoWeeks: '2週', // issue #17 + visible day issues
        CalendarFormat.week: '週',
      },
      // calendarStyle: CalendarStyle(
      //   todayColor: Theme.of(context).colorScheme.secondaryVariant,
      //   selectedColor: Theme.of(context).colorScheme.secondary,
      // ),
      headerStyle: HeaderStyle(formatButtonShowsNext: false),
      builders: CalendarBuilders(
        dowWeekendBuilder: (context, str) {
          return Center(
            child: Text(
              str,
              style: TextStyle()
                  .copyWith(color: str == '土' ? Colors.blue : Colors.red),
            ),
          );
        },
        weekendDayBuilder: (context, date, events) {
          return _dayCellBuilder(date);
        },
        outsideWeekendDayBuilder: (context, date, events) {
          return _dayCellBuilder(date, outside: true);
        },
        markersBuilder: (context, date, events, _) {
          return [
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).primaryColor,
                ),
                width: 24.0,
                height: 16.0,
                child: Center(
                  child: FutureBuilder<int>(
                    future: EventernoteService().getNumEventsForDate(date),
                    builder: (context, snapshot) {
                      String text = '?';
                      if (snapshot.hasData) {
                        text = "${snapshot.data}";
                      } else if (snapshot.hasError) {
                        text = '-';
                      }
                      return Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },
      ),
      onDaySelected: (date, _) {
        setState(() => _selectedDate = date);
        _pagewiseLoadController.reset();
      },
      onVisibleDaysChanged: (first, last, _) => setState(() {
        _populateEvents(first, last);
        HolidaysService().isHoliday(first) || HolidaysService().isHoliday(last);
        _holidays = HolidaysService().all;
      }),
    );
  }

  // TableCalendar will not call markersBuilder unless events[date] is populated
  void _populateEvents(DateTime start, DateTime end) {
    DateTime cur = start;
    while (cur.isBefore(end.add(Duration(days: 1)))) {
      if (_events[cur] == null) {
        _events[cur] = [];
      }
      cur = cur.add(Duration(days: 1));
    }
  }

  Widget _dayCellBuilder(DateTime date, {bool outside: false}) {
    Color boxColor;
    TextStyle cellTextStyle = TextStyle(
      color: date.weekday == DateTime.saturday
          ? Colors.blue[outside ? 200 : 500]
          : Colors.red[outside ? 200 : 500],
    );

    if (_calendarController.isSelected(date)) {
      boxColor = Colors.indigo[400];
      cellTextStyle = TextStyle(fontSize: 16.0, color: Colors.grey[50]);
    } else if (_calendarController.isToday(date)) {
      boxColor = Colors.indigo[200];
      cellTextStyle = TextStyle(fontSize: 16.0, color: Colors.grey[50]);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(shape: BoxShape.circle, color: boxColor),
      margin: EdgeInsets.all(6.0),
      alignment: Alignment.center,
      child: Text(
        "${date.day}",
        style: cellTextStyle,
      ),
    );
  }
}
