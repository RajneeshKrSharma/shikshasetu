import 'package:equatable/equatable.dart';

import 'day_time.dart';

enum SlotKind { period, breakTime }

/// One period or break of the school's day.
class BellSlot extends Equatable {
  const BellSlot({
    required this.id,
    required this.position,
    required this.kind,
    required this.start,
    required this.end,
    this.label = '',
  });

  final String id;

  /// Its place in the day, from 0.
  final int position;
  final SlotKind kind;

  /// A name, such as "Lunch". A period with none is called by its number.
  final String label;
  final DayTime start;
  final DayTime end;

  bool get isPeriod => kind == SlotKind.period;

  int get minutes => end.minutes - start.minutes;

  @override
  List<Object?> get props => [id, position, kind, label, start, end];
}
