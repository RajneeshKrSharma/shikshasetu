import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/paper_details.dart';
import '../bloc/paper_scan_bloc.dart';

/// School name, logo and the lines printed under them.
class DetailsForm extends StatefulWidget {
  const DetailsForm({
    super.key,
    required this.initial,
    required this.schoolName,
  });

  final PaperDetails initial;
  final String schoolName;

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  late final TextEditingController _school;
  late final TextEditingController _exam;
  late final TextEditingController _class;
  late final TextEditingController _subject;
  late final TextEditingController _date;
  late final TextEditingController _duration;

  @override
  void initState() {
    super.initState();
    final d = widget.initial;
    _school = TextEditingController(text: widget.schoolName);
    _exam = TextEditingController(text: d.examName);
    _class = TextEditingController(text: d.classSection);
    _subject = TextEditingController(text: d.subject);
    _date = TextEditingController(text: d.examDate);
    _duration = TextEditingController(text: d.duration);
  }

  @override
  void dispose() {
    for (final c in [_school, _exam, _class, _subject, _date, _duration]) {
      c.dispose();
    }
    super.dispose();
  }

  void _changed() => context.read<PaperScanBloc>().add(
    DetailsChanged(
      PaperDetails(
        examName: _exam.text,
        classSection: _class.text,
        subject: _subject.text,
        examDate: _date.text,
        duration: _duration.text,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    Widget field(TextEditingController c, String label) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextField(
        controller: c,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => _changed(),
      ),
    );
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.paperScanHeaderTitle, style: context.text.titleSmall),
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<PaperScanBloc, PaperScanState>(
            buildWhen: (a, b) => a.identity.logoPath != b.identity.logoPath,
            builder: (context, s) {
              final logo = s.identity.logoPath;
              return Row(
                children: [
                  if (logo != null) ...[
                    Image.file(
                      File(logo),
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                      cacheWidth: 168,
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Flexible(
                    child: OutlinedButton.icon(
                      onPressed: () => bloc.add(const LogoRequested()),
                      icon: const Icon(Icons.image_outlined),
                      label: Text(
                        logo == null
                            ? l.paperScanChooseLogo
                            : l.paperScanChangeLogo,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: TextField(
              controller: _school,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.fieldSchoolName),
              onChanged: (v) => bloc.add(SchoolNameChanged(v)),
            ),
          ),
          field(_exam, l.paperScanExamName),
          field(_class, l.fieldClass),
          field(_subject, l.fieldSubject),
          field(_date, l.fieldDate),
          field(_duration, l.printTimeAllowed),
        ],
      ),
    );
  }
}
