import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/services/holidays_service.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _cc;
  PagewiseLoadController _plc;

  /// List of holidays from [HolidaysService.all].
  Map<DateTime, List> _holidays;

  /// TableCalendar will not call markersBuilder unless events is populated for
  /// said date, so whenever new dates are shown [_populateEvents] is called.
  Map<DateTime, List> _events;

  /// The selected date, used mainly by PagewiseLoadController [_plc]
  /// (for whatever reason PagewiseLoadController doesn't like
  /// CalendarController.selectedDate).
  DateTime _selected;

  /// The difference in x (horizontal axis). Used to animate the swipe animation
  /// of the event list when switching days.
  double _dx;

  @override
  void initState() {
    super.initState();
    _selected = DateTime.now();
    _events = {};
    _populateEvents(
      _selected.subtract(Duration(days: 40)),
      _selected.add(Duration(days: 40)),
    );
    HolidaysService().isHoliday(_selected); // populates holidays
    _holidays = HolidaysService().all;
    _cc = CalendarController();
    _plc = PagewiseLoadController(
      pageSize: EventernoteService.PAGE_SIZE,
      pageFuture: (page) =>
          EventernoteService().getEventsForDate(_cc.selectedDay, page),
    );
    _dx = 0;
  }

  @override
  void dispose() {
    // _pagewiseLoadController.dispose(); // seems to break other pagewise pages?
    _cc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildCalendar(),
          SizedBox(height: 8.0),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.decelerate,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  child: child,
                  position:
                      Tween<Offset>(begin: Offset(_dx, 0), end: Offset(0, 0))
                          .animate(animation),
                );
              },
              layoutBuilder: (currentChild, _) => currentChild,
              child: Dismissible(
                key: ValueKey(_selected.toIso8601String()),
                resizeDuration: null,
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    _cc.setSelectedDay(
                      _selected.subtract(Duration(days: 1)),
                      runCallback: true,
                    );
                  } else {
                    _cc.setSelectedDay(
                      _selected.add(Duration(days: 1)),
                      runCallback: true,
                    );
                  }
                },
                child: PagewiseListView(
                  pageLoadController: _plc,
                  itemBuilder: (context, event, i) {
                    return Column(
                      children: <Widget>[
                        Divider(height: 0.5),
                        EventTile(event, animated: true, showDate: false),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // these are unnecessary reimplementations
  bool _isOutside(date) => date.month != _cc.focusedDay.month;
  bool _isHoliday(date) => HolidaysService().isHoliday(date);

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ja_jp',
      calendarController: _cc,
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
            _cc.setSelectedDay(selected, runCallback: true);
          }
        });
      },
      onHeaderLongPressed: (_) {
        _cc.setSelectedDay(DateTime.now(), runCallback: true);
      },
      builders: CalendarBuilders(
        dowWeekendBuilder: (context, dow) => _DowWeekendBuilder(dow),
        markersBuilder: (context, date, _, __) => [_EventCountMarker(date)],
        dayBuilder: (context, date, _) => _DayCell(
          date,
          holiday: _isHoliday(date),
          outside: _isOutside(date),
          selected: _cc.isSelected(date),
          today: _cc.isToday(date),
        ),
      ),
      onDaySelected: (date, _) {
        setState(() {
          _dx = date.isBefore(_selected) ? -1 : 1;
          _selected = date;
        });
        _plc.reset();
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

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool outside, holiday, selected, today;

  const _DayCell(
    this.date, {
    this.holiday = false,
    this.outside = false,
    this.selected = false,
    this.today = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (selected) {
      textColor = Colors.white;
    } else if (holiday || date.weekday == DateTime.sunday) {
      textColor = Colors.red[outside ? 200 : 500];
    } else if (date.weekday == DateTime.saturday) {
      textColor = Colors.blue[outside ? 200 : 500];
    } else {
      final textTheme = Theme.of(context).textTheme;
      textColor = outside ? textTheme.caption.color : textTheme.bodyText2.color;
    }
    var fontSize = Theme.of(context).textTheme.bodyText2.fontSize;
    if (selected) {
      fontSize += 2;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Color(0x80000000) : null,
        border: Border.all(
          width: 2,
          color: today
              ? Theme.of(context).textTheme.caption.color
              : Colors.transparent,
        ),
      ),
      margin: EdgeInsets.all(6.0),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
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
          borderRadius: BorderRadius.circular(6),
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
                text = '${snapshot.data}';
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
