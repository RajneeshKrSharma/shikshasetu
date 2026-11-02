import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../members/domain/entities/member_kind.dart';
import '../../../members/domain/entities/member_summary.dart';
import '../../../members/domain/usecases/get_member_summaries.dart';
import '../../../members/presentation/widgets/summary_part_l10n.dart';

/// Reads the active other staff, for choosing whose bill it is.
class StaffChoiceCubit extends Cubit<List<MemberSummary>?> {
  StaffChoiceCubit(this._get) : super(null);

  final GetMemberSummaries _get;

  Future<void> load() async => emit([
    for (final m in await _get(MemberKind.other))
      if (m.active) m,
  ]);
}

/// Asks whose bill it is. Closes with the staff member's id, or nothing.
class StaffChoiceSheet extends StatelessWidget {
  const StaffChoiceSheet({super.key});

  static Future<String?> show(BuildContext context) =>
      showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => BlocProvider(
          create: (_) => StaffChoiceCubit(sl())..load(),
          child: const StaffChoiceSheet(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: BlocBuilder<StaffChoiceCubit, List<MemberSummary>?>(
        builder: (context, staff) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(l.billChooseStaff, style: context.text.titleMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (staff == null)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final m in staff)
                      ListTile(
                        leading: InitialsAvatar(m.name, radius: 18),
                        title: Text(m.name),
                        subtitle: Text(m.subtitle(l)),
                        onTap: () => Navigator.of(context).pop(m.id),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
