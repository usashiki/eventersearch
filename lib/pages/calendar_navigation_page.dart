import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/services/holidays_service.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarNavigationPage extends StatefulWidget {
  @override
  _CalendarNavigationPageState createState() => _CalendarNavigationPageState();
}

class _CalendarNavigationPageState extends State<CalendarNavigationPage> {
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
    return Scaffold(
      // empty appbar
      appBar: PreferredSize(preferredSize: Size(0, 0), child: Container()),
      body: Column(
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
                      EventTile(event, animated: true),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
        // CalendarFormat.twoWeeks: '2週', // TODO: issue #17 + visible day issues
        CalendarFormat.week: '週',
      },
      // calendarStyle: CalendarStyle(
      //   todayColor: Theme.of(context).colorScheme.secondaryVariant,
      //   selectedColor: Theme.of(context).colorScheme.secondary,
      // ),
      headerStyle: HeaderStyle(formatButtonShowsNext: false),
      onHeaderTapped: (current) {
        showDatePicker(
          context: context,
          initialDate: current,
          firstDate: DateTime(1980),
          lastDate: DateTime.now().add(Duration(days: 365 * 2)),
          locale: Localizations.localeOf(context), // TODO: set app locale to jp
        ).then((selected) {
          if (selected != null) {
            _calendarController.setSelectedDay(selected, runCallback: true);
          }
        });
      },
      onHeaderLongPressed: (_) {
        _calendarController.setSelectedDay(DateTime.now(), runCallback: true);
      },
      builders: CalendarBuilders(
        dowWeekendBuilder: (context, dow) => _DowWeekendBuilder(dow),
        // dayBuilder: (context, date, _) => _dayCellBuilder(date),
        weekendDayBuilder: (context, date, _) => _WeekendDateCell(
          date,
          selected: _calendarController.isSelected(date),
          today: _calendarController.isToday(date),
        ),
        outsideWeekendDayBuilder: (context, date, _) => _WeekendDateCell(
          date,
          selected: _calendarController.isSelected(date),
          today: _calendarController.isToday(date),
          outside: true,
        ),
        markersBuilder: (context, date, _, __) => [_EventCountMarker(date)],
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
    var cur = start;
    while (cur.isBefore(end.add(Duration(days: 1)))) {
      if (_events[cur] == null) {
        _events[cur] = [];
      }
      cur = cur.add(Duration(days: 1));
    }
  }
}

class _DowWeekendBuilder extends StatelessWidget {
  final String dayOfWeek;

  const _DowWeekendBuilder(this.dayOfWeek, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        dayOfWeek,
        style: TextStyle()
            .copyWith(color: dayOfWeek == '土' ? Colors.blue : Colors.red),
      ),
    );
  }
}

// TODO: create custom DateCells
class _WeekendDateCell extends StatelessWidget {
  final DateTime date;
  final bool outside, selected, today;

  const _WeekendDateCell(
    this.date, {
    @required this.selected,
    @required this.today,
    this.outside = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color boxColor;
    var cellTextStyle = TextStyle(
      color: date.weekday == DateTime.saturday
          ? Colors.blue[outside ? 200 : 500]
          : Colors.red[outside ? 200 : 500],
    );

    if (selected) {
      boxColor = Colors.indigo[400];
      cellTextStyle = TextStyle(fontSize: 16.0, color: Colors.grey[50]);
    } else if (today) {
      boxColor = Colors.indigo[200];
      cellTextStyle = TextStyle(fontSize: 16.0, color: Colors.grey[50]);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(shape: BoxShape.circle, color: boxColor),
      margin: EdgeInsets.all(6.0),
      alignment: Alignment.center,
      child: Text("${date.day}", style: cellTextStyle),
    );
  }
}

class _EventCountMarker extends StatelessWidget {
  final DateTime date;

  const _EventCountMarker(this.date, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor,
        ),
        width: 26.0,
        height: 18.0,
        child: Center(
          child: FutureBuilder<int>(
            future: EventernoteService().getNumEventsForDate(date),
            builder: (context, snapshot) {
              var text = '?';
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
    );
  }
}
