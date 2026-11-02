import 'package:equatable/equatable.dart';

/// A time of day, kept as minutes since midnight.
class DayTime extends Equatable implements Comparable<DayTime> {
  const DayTime(this.minutes);

  const DayTime.hm(int hour, int minute) : minutes = hour * 60 + minute;

  final int minutes;

  int get hour => minutes ~/ 60;
  int get minute => minutes % 60;

  @override
  int compareTo(DayTime other) => minutes.compareTo(other.minutes);

  bool isBefore(DayTime other) => minutes < other.minutes;

  @override
  List<Object?> get props => [minutes];
}
