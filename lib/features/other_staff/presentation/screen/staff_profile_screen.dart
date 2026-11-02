import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/feature_tile.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../di/injector.dart';
import '../../../bills/presentation/screen/bills_screen.dart';
import '../../../bills/presentation/screen/staff_payment_screen.dart';
import '../../../registration/presentation/widgets/gender_l10n.dart';
import '../bloc/staff_profile_cubit.dart';

/// One staff member: their role and phone, the van they drive, their payment
/// and bills, and their details.
class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key, required this.staffId});

  final String staffId;

  static Future<void> open(BuildContext context, String staffId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => StaffProfileScreen(staffId: staffId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocProvider(
      create: (_) => sl<StaffProfileCubit>(param1: staffId)..load(),
      child: BlocBuilder<StaffProfileCubit, StaffProfileState>(
        builder: (context, s) {
          final staff = s.staff;
          if (s.loading || staff == null) {
            return Scaffold(
              appBar: AppBar(),
              body: s.loading
                  ? const Center(child: CircularProgressIndicator())
                  : EmptyState(
                      icon: Icons.person_off_outlined,
                      message: l.profileNotFound,
                    ),
            );
          }
          final cubit = context.read<StaffProfileCubit>();
          final pay = s.payable;
          return Scaffold(
            appBar: AppBar(title: Text(staff.name)),
            body: ListView(
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
                      Text(staff.roleTitle, style: context.text.titleSmall),
                      Text(
                        l.staffRoleLine(staff.phone),
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (staff.vehicleNumber != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.fieldVanNumber, style: context.text.bodySmall),
                        Text(
                          staff.vehicleNumber!,
                          style: context.text.titleMedium!.copyWith(
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                FeatureGrid(
                  columns: 2,
                  tiles: [
                    FeatureTile(
                      icon: Icons.payments_outlined,
                      label: l.staffTilePayment,
                      caption: pay == null || pay.payableAmount == 0
                          ? l.staffNoBillsYet
                          : l.staffPayableLine(
                              formatRupees(context, pay.payableAmount),
                            ),
                      onTap: () async {
                        await StaffPaymentScreen.open(
                          context,
                          staffId,
                          staff.name,
                        );
                        await cubit.load();
                      },
                    ),
                    FeatureTile(
                      icon: Icons.receipt_long_outlined,
                      label: l.staffTileBills,
                      caption: pay == null || pay.waitingCount == 0
                          ? null
                          : l.staffBillsWaiting(pay.waitingCount),
                      onTap: () async {
                        await BillsScreen.open(context, staffId: staffId);
                        await cubit.load();
                      },
                    ),
                  ],
                ),
                SectionLabel(l.profileDetails),
                Row(
                  children: [
                    Expanded(
                      child: _Box(
                        label: l.fieldGender,
                        value: staff.gender?.label(l) ?? '–',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _Box(
                        label: l.fieldAadhaar,
                        value: staff.aadhaarMasked.isEmpty
                            ? '–'
                            : staff.aadhaarMasked,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _Box(label: l.fieldAddress, value: staff.address ?? '–'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      borderRadius: AppRadius.mdAll,
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelSmall),
        Text(value, style: context.text.bodyMedium),
      ],
    ),
  );
}
