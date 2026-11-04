import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../di/v2_injector.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../domain/entities/timetable_sheet.dart';
import '../../domain/usecases/timetable_usecases.dart';
import '../bloc/timetable_print_cubit.dart';

/// Shows the printable timetable of a class and lets the Principal print or
/// share it. The preview carries its own Print and Share buttons.
class TimetablePrintScreen extends StatelessWidget {
  const TimetablePrintScreen({
    super.key,
    required this.classId,
    required this.type,
  });

  final String classId;
  final ExamType type;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final params = BuildTimetablePdfParams(
      classId: classId,
      type: type,
      labels: TimetablePrintLabels(
        localeCode: Localizations.localeOf(context).languageCode,
        title: l.ttbPrintHeading,
        classWord: l.ttbClassWord,
        dateColumn: l.ttbDate,
        dayColumn: l.ttbColDay,
        subjectColumn: l.ttbColSubject,
        examWord: l.ttbExamWord,
        sessionWord: l.ttbSession,
      ),
    );
    return BlocProvider(
      create: (_) => sl<TimetablePrintCubit>()..load(params),
      child: Scaffold(
        appBar: AppBar(title: Text(l.ttbPrintTitle)),
        body: BlocBuilder<TimetablePrintCubit, TimetablePrintState>(
          builder: (context, s) => AsyncBody(
            status: s.status,
            failure: s.failure,
            onRetry: () => context.read<TimetablePrintCubit>().load(params),
            builder: (_) => PdfPreview(
              build: (_) async => s.pdf!,
              pdfFileName: 'exam-timetable.pdf',
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
            ),
          ),
        ),
      ),
    );
  }
}
