import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/async_body.dart';
import '../../../../core/widgets/failure_toast.dart';
import '../../../../di/v2_injector.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entities/school.dart';
import '../bloc/holidays_bloc.dart';
import '../widgets/holiday_dialog.dart';

/// The days the school is closed, from this month on.
class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<HolidaysBloc>(param1: account)..add(const HolidaysStarted()),
      child: const _HolidaysView(),
    );
  }
}

class _HolidaysView extends StatelessWidget {
  const _HolidaysView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<HolidaysBloc, HolidaysState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<HolidaysBloc, HolidaysState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l.schoolHolidays)),
          floatingActionButton: state.canEdit
              ? FloatingActionButton.extended(
                  onPressed: state.busy
                      ? null
                      : () => showHolidayDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.holidayAdd),
                )
              : null,
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () =>
                context.read<HolidaysBloc>().add(const HolidaysStarted()),
            isEmpty: state.holidays.isEmpty,
            emptyText: l.holidaysEmpty,
            emptyIcon: Icons.beach_access_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.pageOf(context, fab: state.canEdit),
              children: [
                for (final h in state.holidays)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: state.canEdit
                          ? () => showHolidayDialog(context, existing: h)
                          : null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.beach_access_outlined,
                            color: context.brand.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(h.name, style: context.text.titleSmall),
                                Text(
                                  _dates(context, h),
                                  style: context.text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dates(BuildContext context, Holiday h) => h.isOneDay
      ? formatShortDate(context, h.startsOn)
      : '${formatShortDate(context, h.startsOn)} – ${formatShortDate(context, h.endsOn)}';
}
