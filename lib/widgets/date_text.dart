import 'package:eventernote/services/holidays_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime date;
  final TextStyle style;

  const DateText(this.date, {this.style, Key key}) : super(key: key);

  List<InlineSpan> get spans {
    Color c;
    if (date.weekday == DateTime.saturday) {
      c = Colors.blue;
    } else if (date.weekday == DateTime.sunday ||
        HolidaysService().isHoliday(date)) {
      c = Colors.red;
    }

    return [
      TextSpan(text: DateFormat('yyyy-MM-dd', 'ja_jp').format(date)),
      TextSpan(text: ' ('),
      TextSpan(
        text: DateFormat('E', 'ja_jp').format(date),
        style: TextStyle(color: c),
      ),
      TextSpan(text: ')'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}
