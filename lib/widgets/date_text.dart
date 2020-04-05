import 'package:eventersearch/services/holidays_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime date;
  final TextStyle style;

  /// A simple widget which, given a [date], returns a [RichText] in [style] for
  /// [date] in the form 'yyyy-MM-dd (E)' with E colored red if it is a Sunday
  /// (日) or holiday and blue if it is a Saturday (土),
  const DateText(this.date, {this.style, Key key}) : super(key: key);

  /// Returns just the [InlineSpan]s instead of the whole [RichText].
  List<InlineSpan> get spans {
    Color c;
    if (date.weekday == DateTime.sunday || HolidaysService().isHoliday(date)) {
      c = Colors.red;
    } else if (date.weekday == DateTime.saturday) {
      c = Colors.blue;
    }

    return [
      TextSpan(text: DateFormat('yyyy-MM-dd', 'ja_jp').format(date)),
      const TextSpan(text: ' ('),
      TextSpan(
        text: DateFormat('E', 'ja_jp').format(date),
        style: TextStyle(color: c),
      ),
      const TextSpan(text: ')'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}
