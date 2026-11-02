import 'package:flutter/material.dart';

/// Minutes since midnight, drawn and picked as a time of day.
extension MinuteOfDay on int {
  TimeOfDay get timeOfDay => TimeOfDay(hour: this ~/ 60, minute: this % 60);

  String clock(BuildContext context) => timeOfDay.format(context);
}

extension PickedTime on TimeOfDay {
  int get minuteOfDay => hour * 60 + minute;
}

/// Asks for a time; null when cancelled.
Future<int?> pickMinute(BuildContext context, {int? initial}) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: initial?.timeOfDay ?? const TimeOfDay(hour: 8, minute: 0),
  );
  return picked?.minuteOfDay;
}
