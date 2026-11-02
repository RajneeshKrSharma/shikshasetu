import '../../../../core/theme/app_colors.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../bloc/settings_bloc.dart';

/// Choose, change or remove the school logo printed on question papers.
class SchoolLogoScreen extends StatelessWidget {
  const SchoolLogoScreen({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const SchoolLogoScreen()));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<SettingsBloc>();
    final path = context.select((SettingsBloc b) => b.state.settings.logoPath);
    return Scaffold(
      appBar: AppBar(title: Text(l.logoTitle)),
      body: ListView(
        padding: AppSpacing.pageOf(context),
        children: [
          Text(l.logoHelp, style: context.text.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 160,
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.border),
              ),
              child: path == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: AppIconSize.hero,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(l.logoNone, style: context.text.bodySmall),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Image.file(File(path), fit: BoxFit.contain),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => bloc.add(const LogoPickRequested()),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(path == null ? l.logoChoose : l.logoChange),
          ),
          if (path != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => bloc.add(const LogoRemoved()),
              icon: const Icon(Icons.delete_outline),
              label: Text(l.logoRemove),
            ),
          ],
        ],
      ),
    );
  }
}
