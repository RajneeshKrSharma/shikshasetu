import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../core/widgets/time_format.dart';
import '../bloc/my_attendance_bloc.dart';

/// A person's own check-in and check-out, and their last days.
class MyAttendanceTab extends StatelessWidget {
  const MyAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<MyAttendanceBloc, MyAttendanceState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<MyAttendanceBloc, MyAttendanceState>(
        builder: (context, state) => AsyncBody(
          status: state.status,
          failure: state.failure,
          onRetry: () =>
              context.read<MyAttendanceBloc>().add(const MyAttendanceStarted()),
          builder: (context) => ListView(
            padding: AppSpacing.page,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.canCheckIn && !state.busy
                          ? () => context.read<MyAttendanceBloc>().add(
                              const CheckedIn(),
                            )
                          : null,
                      icon: const Icon(Icons.login),
                      label: Text(l.attCheckIn),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.canCheckOut && !state.busy
                          ? () => context.read<MyAttendanceBloc>().add(
                              const CheckedOut(),
                            )
                          : null,
                      icon: const Icon(Icons.logout),
                      label: Text(l.attCheckOut),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.records.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l.attMineEmpty, textAlign: TextAlign.center),
                ),
              for (final r in state.records)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatShortDate(context, r.day),
                            style: context.text.titleSmall,
                          ),
                        ),
                        Text(
                          [
                            l.attCheckedInAt(r.checkedInAt.clock(context)),
                            if (r.checkedOutAt != null)
                              l.attCheckedOutAt(r.checkedOutAt!.clock(context)),
                          ].join(' · '),
                          style: context.text.bodySmall,
                        ),
                      ],
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
