import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/widget/button.dart';

class DatetimePickerWidget extends StatefulWidget {
  DateTime? dateTime;
  int? taskID;

  DatetimePickerWidget({super.key, this.dateTime, this.taskID});
  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String getText() {
    if (widget.dateTime == null) {
      return 'Select DateTime';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(widget.dateTime!);
    }
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'Set deadline',
        text: getText(),
        onClicked: () => pickDateTime(context),
      );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      widget.dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    await _dbHelper.updateDeadline(widget.taskID!, widget.dateTime!.toString());
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: widget.dateTime != null
          ? TimeOfDay(
              hour: widget.dateTime!.hour, minute: widget.dateTime!.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }
}
