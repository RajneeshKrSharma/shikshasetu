import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/attendance_record.dart';
import '../bloc/attendance_report_bloc.dart';
import '../widgets/attendance_mark_style.dart';
import '../widgets/teacher_proof_sheet.dart';
import 'staff_marking_screen.dart';

/// One day's attendance of students, teachers and other staff as a plain
/// table with a header, and filters to narrow it down.
class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  /// Opens the report. With [group] it is about that group only: its
  /// statuses are tabs and the group cannot be changed.
  static Future<void> open(BuildContext context, {AttendanceGroup? group}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<AttendanceReportBloc>(param1: group)
                  ..add(const ReportStarted()),
            child: const AttendanceReportScreen(),
          ),
        ),
      );

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickDay(BuildContext context) async {
    final bloc = context.read<AttendanceReportBloc>();
    final today = bloc.today;
    final picked = await showDatePicker(
      context: context,
      initialDate: bloc.state.day,
      firstDate: DateTime(today.year - 3),
      lastDate: today,
      helpText: context.l10n.attReportPickDay,
    );
    if (picked != null) bloc.add(ReportDayChosen(picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocListener<AttendanceReportBloc, AttendanceReportState>(
      // Clearing the filters empties the search box too.
      listenWhen: (a, b) => a.query != b.query && b.query.isEmpty,
      listener: (_, _) => _search.clear(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(switch (context
              .read<AttendanceReportBloc>()
              .state
              .lockedGroup) {
            AttendanceGroup.student => l.attTitleStudents,
            AttendanceGroup.teacher => l.attTitleTeachers,
            AttendanceGroup.other => l.attTitleOthers,
            null => l.attReportTitle,
          }),
        ),
        // The Principal marks other staff's attendance; nobody else does.
        floatingActionButton:
            context.read<AttendanceReportBloc>().state.lockedGroup ==
                AttendanceGroup.other
            ? FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  final bloc = context.read<AttendanceReportBloc>();
                  await StaffMarkingScreen.open(context, bloc.state.day);
                  bloc.add(const ReportStarted());
                },
                icon: const Icon(Icons.edit_note_outlined),
                label: Text(l.attMarkStaff),
              )
            : null,
        body: BlocBuilder<AttendanceReportBloc, AttendanceReportState>(
          builder: (context, s) {
            final rows = s.visible;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _Filters(
                      state: s,
                      search: _search,
                      onPickDay: () => _pickDay(context),
                    ),
                  ),
                ),
                if (s.lockedGroup == null)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TableHeader(
                      labels: [
                        l.attColName,
                        l.attColClassRole,
                        l.attColStatus,
                        l.attColTime,
                      ],
                    ),
                  ),
                if (s.loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (rows.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Text(
                          l.attReportEmpty,
                          textAlign: TextAlign.center,
                          style: context.text.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, i) => s.lockedGroup == null
                        ? _TableRow(record: rows[i], striped: i.isOdd)
                        : _PersonRow(record: rows[i]),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The day, the filters and how many rows pass them.
class _Filters extends StatelessWidget {
  const _Filters({
    required this.state,
    required this.search,
    required this.onPickDay,
  });

  final AttendanceReportState state;
  final TextEditingController search;
  final VoidCallback onPickDay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<AttendanceReportBloc>();
    final isToday = state.day == bloc.today;
    final shown = state.visible;
    final locked = state.lockedGroup;

    Widget chips<T>({
      required List<T> values,
      required T? selected,
      required String Function(T?) label,
      required void Function(T?) onChosen,
    }) => SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final v in <T?>[null, ...values]) ...[
            ChoiceChip(
              label: Text(label(v)),
              selected: selected == v,
              onSelected: (_) => onChosen(v),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => bloc.add(
                ReportDayChosen(
                  DateTime(state.day.year, state.day.month, state.day.day - 1),
                ),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: onPickDay,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(
                  isToday
                      ? '${l.attReportToday} · ${formatLongDate(context, state.day)}'
                      : formatLongDate(context, state.day),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.chevron_right),
              onPressed: isToday
                  ? null
                  : () => bloc.add(
                      ReportDayChosen(
                        DateTime(
                          state.day.year,
                          state.day.month,
                          state.day.day + 1,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (locked == AttendanceGroup.teacher) ...[
          Container(
            width: double.infinity,
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: context.brand.primaryLight,
              borderRadius: AppRadius.lgAll,
              border: Border.all(
                color: context.brand.primary.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              l.attTeachersCheckedIn(
                state.countOfMark(AttendanceMark.present),
                state.countOfMark(null),
              ),
              style: context.text.titleSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (locked == null) ...[
          chips<AttendanceGroup>(
            values: AttendanceGroup.values,
            selected: state.group,
            label: (g) => g == null
                ? '${l.filterAll} (${state.countOf(null)})'
                : '${g.label(l)} (${state.countOf(g)})',
            onChosen: (g) => bloc.add(ReportGroupChosen(g)),
          ),
          const SizedBox(height: AppSpacing.md),
          chips<AttendanceMark>(
            values: state.marks,
            selected: state.mark,
            label: (m) => m == null ? l.filterAll : m.label(l),
            onChosen: (m) => bloc.add(ReportMarkChosen(m)),
          ),
        ] else ...[
          // One tab for each status of this group, each with its count.
          chips<AttendanceMark>(
            values: locked.marks,
            selected: state.mark,
            label: (m) => m == null
                ? l.attTabAll(state.countOfMark(null))
                : l.attTabMark(m.label(l), state.countOfMark(m)),
            onChosen: (m) => bloc.add(ReportMarkChosen(m)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(switch (locked) {
            AttendanceGroup.student => l.attMeaningStudents,
            AttendanceGroup.teacher => l.attMeaningTeachers,
            AttendanceGroup.other => l.attMeaningOthers,
          }, style: context.text.bodySmall),
        ],
        const SizedBox(height: AppSpacing.md),
        if (locked != null &&
            locked != AttendanceGroup.teacher &&
            state.details.isNotEmpty) ...[
          chips<String>(
            values: state.details,
            selected: state.detail,
            label: (d) => d ?? l.filterAll,
            onChosen: (d) => bloc.add(ReportDetailChosen(d)),
          ),
          const SizedBox(height: AppSpacing.md),
        ] else if (locked == null && state.details.isNotEmpty) ...[
          DropdownButtonFormField<String?>(
            // Rebuilt when the group changes, so the old choice goes.
            key: ValueKey((state.group, state.detail)),
            initialValue: state.detail,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: switch (locked) {
                AttendanceGroup.student => l.attFilterClass,
                AttendanceGroup.other => l.attFilterRole,
                _ => l.attFilterDetail,
              },
              prefixIcon: const Icon(Icons.filter_alt_outlined),
            ),
            items: [
              DropdownMenuItem<String?>(value: null, child: Text(l.filterAll)),
              for (final d in state.details)
                DropdownMenuItem<String?>(value: d, child: Text(d)),
            ],
            onChanged: (d) => bloc.add(ReportDetailChosen(d)),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        TextField(
          controller: search,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: l.attSearchName,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (q) => bloc.add(ReportQueryChanged(q)),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                l.attShowing(shown.length, state.countOf(state.group)),
                style: context.text.bodySmall,
              ),
            ),
            if (state.hasFilters)
              TextButton(
                onPressed: () => bloc.add(const ReportFiltersCleared()),
                child: Text(l.attClearFilters),
              ),
          ],
        ),
      ],
    );
  }
}

/// How the four columns share the width.
const _flex = [5, 4, 4, 3];

/// The table's header; it stays at the top while the rows scroll.
class _TableHeader extends SliverPersistentHeaderDelegate {
  const _TableHeader({required this.labels});

  final List<String> labels;

  static const _height = 48.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  bool shouldRebuild(_TableHeader old) => old.labels != labels;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Material(
      color: context.brand.primaryLight,
      elevation: overlaps ? 2 : 0,
      // Fills the header's whole height, as a pinned header must.
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  flex: _flex[i],
                  child: Text(
                    labels[i],
                    style: context.text.labelLarge!.copyWith(
                      color: context.brand.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.record, required this.striped});

  final AttendanceRecord record;
  final bool striped;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = record;
    final proof = r.teacher;
    return InkWell(
      // A teacher who checked in: show where and how.
      onTap: proof != null && proof.isPresent
          ? () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => TeacherProofSheet(record: proof),
            )
          : null,
      child: Container(
        color: striped ? AppColors.pendingLight.withValues(alpha: 0.5) : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: _flex[0],
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Text(r.name, style: context.text.bodyMedium),
              ),
            ),
            Expanded(
              flex: _flex[1],
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Text(
                  r.detail.isEmpty ? '–' : r.detail,
                  style: context.text.bodySmall,
                ),
              ),
            ),
            Expanded(
              flex: _flex[2],
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: r.mark.background,
                    borderRadius: AppRadius.pillAll,
                  ),
                  child: Text(
                    r.mark.label(l),
                    style: context.text.labelSmall!.copyWith(
                      color: r.mark.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: _flex[3],
              child: Text(
                r.checkIn == null ? '–' : formatTime(context, r.checkIn),
                style: context.text.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One person of a group's attendance: who, a line about them, and how they
/// stood that day.
class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = record;
    final proof = r.teacher;
    final times = r.group == AttendanceGroup.teacher && r.checkIn != null
        ? l.timeInOut(
            formatTime(context, r.checkIn),
            formatTime(context, r.checkOut),
          )
        : null;
    return InkWell(
      // A teacher who checked in: show where and how.
      onTap: proof != null && proof.isPresent
          ? () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => TeacherProofSheet(record: proof),
            )
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            InitialsAvatar(r.name, radius: 18),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: context.text.titleSmall),
                  Text(
                    [if (r.detail.isNotEmpty) r.detail, ?times].join(' · '),
                    style: context.text.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            StatusChip(
              label: r.mark.label(l),
              color: r.mark.color,
              background: r.mark.background,
            ),
          ],
        ),
      ),
    );
  }
}
