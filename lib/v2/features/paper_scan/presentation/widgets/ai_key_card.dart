import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../bloc/paper_scan_bloc.dart';

/// Where the teacher pastes the AI key once. Afterwards it only says the key
/// is saved, with a way to remove it.
class AiKeyCard extends StatefulWidget {
  const AiKeyCard({super.key});

  @override
  State<AiKeyCard> createState() => _AiKeyCardState();
}

class _AiKeyCardState extends State<AiKeyCard> {
  late final TextEditingController _key;

  @override
  void initState() {
    super.initState();
    _key = TextEditingController();
  }

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  void _save() {
    context.read<PaperScanBloc>().add(AiKeySaved(_key.text.trim()));
    _key.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bloc = context.read<PaperScanBloc>();
    return BlocBuilder<PaperScanBloc, PaperScanState>(
      buildWhen: (a, b) => a.hasAiKey != b.hasAiKey,
      builder: (context, s) => Container(
        padding: AppSpacing.card,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: s.hasAiKey
            ? Row(
                children: [
                  const Icon(Icons.verified_outlined, color: AppColors.present),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(l.paperScanKeySaved)),
                  TextButton(
                    onPressed: () => bloc.add(const AiKeyCleared()),
                    child: Text(l.paperScanKeyRemove),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.paperScanKeyTitle, style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l.paperScanKeyHint, style: context.text.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _key,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSubmitted: (_) => _save(),
                    decoration: InputDecoration(
                      labelText: l.paperScanKeyField,
                      prefixIcon: const Icon(Icons.key_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: _save,
                    child: Text(l.paperScanKeySave),
                  ),
                ],
              ),
      ),
    );
  }
}
