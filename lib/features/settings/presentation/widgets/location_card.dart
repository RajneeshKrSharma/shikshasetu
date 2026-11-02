import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../bloc/school_settings_form_bloc.dart';

/// Shows the captured school location and the button that captures it.
class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<SchoolSettingsFormBloc, SchoolSettingsFormState>(
      builder: (context, state) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.hasLocation
                  ? l.locationValue(
                      state.latitude!.toStringAsFixed(5),
                      state.longitude!.toStringAsFixed(5),
                    )
                  : l.locationNotSet,
              style: context.text.titleSmall,
            ),
            if (state.hasLocation) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place_outlined, size: AppSizes.iconBadge),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      state.addressLoading
                          ? l.addressLoading
                          : (state.address ?? l.addressUnavailable),
                      style: context.text.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Text(l.locationHelp, style: context.text.labelSmall),
            if (state.error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                switch (state.error!) {
                  LocationFormError.mocked => l.checkErrMockLocation,
                  LocationFormError.servicesOff => l.checkErrServicesOff,
                  LocationFormError.denied => l.checkErrPermissionDenied,
                  LocationFormError.deniedForever =>
                    l.checkErrPermissionForever,
                  LocationFormError.unavailable => l.checkErrUnavailable,
                  LocationFormError.missing => l.errorLocationRequired,
                },
                style: context.text.bodySmall!.copyWith(
                  color: AppColors.absent,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: state.locating
                  ? null
                  : () => context.read<SchoolSettingsFormBloc>().add(
                      const LocationRequested(),
                    ),
              icon: state.locating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(l.actionUseCurrentLocation),
            ),
          ],
        ),
      ),
    );
  }
}
