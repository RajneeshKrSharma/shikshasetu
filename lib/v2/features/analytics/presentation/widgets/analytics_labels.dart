import '../../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/analytics.dart';

extension GraphKindLabel on GraphKind {
  String label(AppLocalizations l) => switch (this) {
    GraphKind.studentAttendance => l.anaStudentAttendance,
    GraphKind.fees => l.anaFees,
    GraphKind.exams => l.anaExams,
    GraphKind.staffAttendance => l.anaStaffAttendance,
    GraphKind.payments => l.anaPayments,
    GraphKind.fuel => l.anaFuel,
    GraphKind.lessons => l.anaLessons,
  };
}

extension SeriesIdLabel on SeriesId {
  String label(AppLocalizations l) => switch (this) {
    SeriesId.attendancePercent => l.anaSeriesAttendance,
    SeriesId.feesCollected => l.anaSeriesFeesCollected,
    SeriesId.feesBalanceByClass => l.anaSeriesFeesBalance,
    SeriesId.examAverage => l.anaSeriesExamAverage,
    SeriesId.staffPresent => l.anaSeriesStaffPresent,
    SeriesId.staffAbsent => l.anaSeriesStaffAbsent,
    SeriesId.paidOut => l.anaSeriesPaidOut,
    SeriesId.fuelAmount => l.anaSeriesFuelAmount,
    SeriesId.fuelMileage => l.anaSeriesFuelMileage,
    SeriesId.lessonsPercent => l.anaSeriesLessons,
  };
}

extension SummaryIdLabel on SummaryId {
  String label(AppLocalizations l) => switch (this) {
    SummaryId.collected => l.anaSumCollected,
    SummaryId.balance => l.anaSumBalance,
    SummaryId.owed => l.anaSumOwed,
    SummaryId.paid => l.anaSumPaid,
  };
}
