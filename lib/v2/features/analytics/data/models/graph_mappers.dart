import '../../../../core/money.dart';
import '../../../../core/server/json.dart';
import '../../domain/entities/analytics.dart';

/// Turns one graph's answer into series to draw. A new graph is a new mapper.
abstract class GraphMapper {
  const GraphMapper();

  GraphData map(Json json);

  static GraphMapper of(GraphKind kind) => switch (kind) {
    GraphKind.studentAttendance => const _StudentAttendanceMapper(),
    GraphKind.fees => const _FeesMapper(),
    GraphKind.exams => const _ExamsMapper(),
    GraphKind.staffAttendance => const _StaffAttendanceMapper(),
    GraphKind.payments => const _PaymentsMapper(),
    GraphKind.fuel => const _FuelMapper(),
    GraphKind.lessons => const _LessonsMapper(),
  };
}

double _number(Object? value) => double.tryParse('${value ?? ''}') ?? 0;

DateTime? _moment(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

class _StudentAttendanceMapper extends GraphMapper {
  const _StudentAttendanceMapper();

  @override
  GraphData map(Json json) => GraphData(
    series: [
      ChartSeries(
        id: SeriesId.attendancePercent,
        shape: SeriesShape.line,
        points: [
          for (final p in json.list('points'))
            if (p['percent'] != null)
              ChartPoint(
                label: p.string('day'),
                at: _moment(p['day']),
                value: _number(p['percent']),
              ),
        ],
      ),
    ],
  );
}

class _FeesMapper extends GraphMapper {
  const _FeesMapper();

  @override
  GraphData map(Json json) => GraphData(
    series: [
      ChartSeries(
        id: SeriesId.feesCollected,
        shape: SeriesShape.bar,
        isMoney: true,
        points: [
          for (final m in json.list('collected'))
            ChartPoint(
              label: m.string('month'),
              at: _moment(m['month']),
              value: _number(m['total']),
            ),
        ],
      ),
      ChartSeries(
        id: SeriesId.feesBalanceByClass,
        shape: SeriesShape.bar,
        isMoney: true,
        points: [
          for (final c in json.list('by_class'))
            ChartPoint(
              label: c.string('class_name'),
              value: _number(c['balance']),
            ),
        ],
      ),
    ],
    summary: [
      SummaryItem(
        SummaryId.collected,
        Money.fromServer(json['collected_total']),
      ),
      SummaryItem(SummaryId.balance, Money.fromServer(json['balance_total'])),
    ],
  );
}

class _ExamsMapper extends GraphMapper {
  const _ExamsMapper();

  @override
  GraphData map(Json json) => GraphData(
    series: [
      ChartSeries(
        id: SeriesId.examAverage,
        shape: SeriesShape.bar,
        points: [
          for (final p in json.list('points'))
            if (p['average_percent'] != null)
              ChartPoint(
                label: p.string('subject'),
                value: _number(p['average_percent']),
              ),
        ],
      ),
    ],
  );
}

class _StaffAttendanceMapper extends GraphMapper {
  const _StaffAttendanceMapper();

  @override
  GraphData map(Json json) {
    final days = [
      for (final p in json.list('points'))
        if (!p.flag('is_holiday')) p,
    ];
    return GraphData(
      series: [
        ChartSeries(
          id: SeriesId.staffPresent,
          shape: SeriesShape.line,
          points: [
            for (final p in days)
              ChartPoint(
                label: p.string('day'),
                at: _moment(p['day']),
                value: (p.integer('present') + p.integer('late')).toDouble(),
              ),
          ],
        ),
        ChartSeries(
          id: SeriesId.staffAbsent,
          shape: SeriesShape.line,
          points: [
            for (final p in days)
              ChartPoint(
                label: p.string('day'),
                at: _moment(p['day']),
                value: (p.integer('absent') + p.integer('leave')).toDouble(),
              ),
          ],
        ),
      ],
    );
  }
}

class _PaymentsMapper extends GraphMapper {
  const _PaymentsMapper();

  @override
  GraphData map(Json json) => GraphData(
    series: [
      ChartSeries(
        id: SeriesId.paidOut,
        shape: SeriesShape.bar,
        isMoney: true,
        points: [
          for (final m in json.list('paid'))
            ChartPoint(
              label: m.string('month'),
              at: _moment(m['month']),
              value: _number(m['total']),
            ),
        ],
      ),
    ],
    summary: [
      SummaryItem(SummaryId.paid, Money.fromServer(json['paid_total'])),
      SummaryItem(SummaryId.owed, Money.fromServer(json['owed_total'])),
    ],
  );
}

class _FuelMapper extends GraphMapper {
  const _FuelMapper();

  @override
  GraphData map(Json json) {
    final points = json.list('points');
    return GraphData(
      series: [
        ChartSeries(
          id: SeriesId.fuelAmount,
          shape: SeriesShape.bar,
          isMoney: true,
          points: [
            for (final p in points)
              ChartPoint(
                label:
                    '${p.string('van_name')} ${p.string('month').substring(0, 7)}',
                value: _number(p['amount']),
              ),
          ],
        ),
        ChartSeries(
          id: SeriesId.fuelMileage,
          shape: SeriesShape.bar,
          points: [
            for (final p in points)
              if (p['km_per_litre'] != null)
                ChartPoint(
                  label:
                      '${p.string('van_name')} ${p.string('month').substring(0, 7)}',
                  value: _number(p['km_per_litre']),
                ),
          ],
        ),
      ],
    );
  }
}

class _LessonsMapper extends GraphMapper {
  const _LessonsMapper();

  @override
  GraphData map(Json json) => GraphData(
    series: [
      ChartSeries(
        id: SeriesId.lessonsPercent,
        shape: SeriesShape.line,
        points: [
          for (final p in json.list('points'))
            if (p['percent'] != null)
              ChartPoint(
                label: p.string('day'),
                at: _moment(p['day']),
                value: _number(p['percent']),
              ),
        ],
      ),
    ],
  );
}
