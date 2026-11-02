import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../di/injector.dart';
import '../../../../l10n/class_label.dart';
import '../bloc/dress_sizes_bloc.dart';

/// Notes each student's dress size, one class at a time, and shows how many
/// of each size to order.
class DressSizesScreen extends StatelessWidget {
  const DressSizesScreen({super.key, required this.className});

  final String className;

  static Future<void> open(BuildContext context, String className) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<DressSizesBloc>(param1: className)
                  ..add(const DressSizesStarted()),
            child: DressSizesScreen(className: className),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<DressSizesBloc, DressSizesState>(
      listenWhen: (a, b) => !a.saved && b.saved,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.accSizesSaved)));
        Navigator.of(context).pop();
      },
      builder: (context, state) {
        final view = state.view;
        return Scaffold(
          appBar: AppBar(
            title: Text('${l.accSizesTitle} · ${l.classLabel(className)}'),
          ),
          body: state.loading || view == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: AppSpacing.pageOf(context),
                  children: [
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l.accSizesOrder} · '
                            '${l.accSizesNoted(state.notedCount, view.rows.length)}',
                            style: context.text.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            [
                              for (final e in state.counts.entries)
                                '${e.key} ×${e.value}',
                              if (view.rows.length - state.notedCount > 0)
                                l.accSizesNotNoted(
                                  view.rows.length - state.notedCount,
                                ),
                            ].join(' · '),
                            style: context.text.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final r in view.rows) ...[
                      _SizeRow(
                        roll: r.rollNo,
                        name: r.name,
                        size: state.sizes[r.studentId] ?? '',
                        onChanged: (v) => context.read<DressSizesBloc>().add(
                          DressSizeChanged(r.studentId, v),
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  ],
                ),
          bottomNavigationBar: view == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: AppSpacing.pageOf(context),
                    child: FilledButton(
                      onPressed: state.saving
                          ? null
                          : () => context.read<DressSizesBloc>().add(
                              const DressSizesSaveRequested(),
                            ),
                      child: Text(l.accSizesSave),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// The sizes a dress usually comes in, to choose from.
const _sizes = ['22', '24', '26', '28', '30', '32', '34', '36'];

/// One student with the sizes to pick from. A size noted by hand that is not
/// in the list is shown too. Tapping the chosen size clears it.
class _SizeRow extends StatelessWidget {
  const _SizeRow({
    required this.roll,
    required this.name,
    required this.size,
    required this.onChanged,
  });

  final int roll;
  final String name;
  final String size;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      ..._sizes,
      if (size.isNotEmpty && !_sizes.contains(size)) size,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 28,
                child: Text('$roll', style: context.text.bodySmall),
              ),
              Expanded(child: Text(name, style: context.text.titleSmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final o in options) ...[
                  ChoiceChip(
                    label: Text(o),
                    selected: size == o,
                    onSelected: (_) => onChanged(size == o ? '' : o),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
