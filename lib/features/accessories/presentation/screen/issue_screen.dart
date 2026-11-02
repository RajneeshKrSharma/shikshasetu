import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/utils/context_ext.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../l10n/class_label.dart';
import '../../../../di/injector.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../proofs/presentation/bloc/proof_cubit.dart';
import '../../../proofs/presentation/widgets/proof_photo_field.dart';
import '../../../proofs/presentation/widgets/signature_pad.dart';
import '../../domain/entities/accessory_kind.dart';
import '../bloc/issue_bloc.dart';
import '../widgets/accessory_labels.dart';

/// Hands dress or books to one student. The receiver signs, an optional photo
/// can be taken, and a numbered receipt is kept.
class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key, required this.args});

  final IssueArgs args;

  static Future<void> open(BuildContext context, IssueArgs args) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<IssueBloc>(param1: args)),
              BlocProvider(
                create: (_) => sl<ProofCubit>(param1: 'accessories'),
              ),
            ],
            child: IssueScreen(args: args),
          ),
        ),
      );

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  late final TextEditingController _receiver;
  late final TextEditingController _size;

  @override
  void initState() {
    super.initState();
    _receiver = TextEditingController(text: widget.args.row.guardian);
    _size = TextEditingController(text: widget.args.row.size ?? '');
  }

  @override
  void dispose() {
    _receiver.dispose();
    _size.dispose();
    super.dispose();
  }

  void _submit() {
    final proof = context.read<ProofCubit>().state;
    context.read<IssueBloc>().add(
      IssueSubmitted(
        receivedBy: _receiver.text,
        issuedBy: context.read<AuthBloc>().state.user?.name ?? '',
        size: _size.text,
        signaturePath: proof.signaturePath,
        photoPath: proof.photoPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = widget.args;
    final dress = a.kind == AccessoryKind.dress;
    final me = context.select((AuthBloc b) => b.state.user?.name ?? '');
    return BlocListener<IssueBloc, IssueState>(
      listenWhen: (x, y) => x.issued == null && y.issued != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.accIssuedSaved(state.issued!.receiptNo))),
        );
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(a.kind.issueTitle(l))),
        body: a.itemNames.isEmpty
            ? EmptyState(
                icon: Icons.checklist_outlined,
                message: l.accNoItemsSetup,
              )
            : ListView(
                padding: AppSpacing.pageOf(context),
                children: [
                  AppCard(
                    child: Row(
                      children: [
                        InitialsAvatar(a.row.name, radius: 20),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.row.name, style: context.text.titleSmall),
                              Text(
                                '${l.classLabel(a.className)} · '
                                '${l.feeRollNo(a.row.rollNo)}',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l.accItemsGiven, style: context.text.labelLarge),
                  BlocBuilder<IssueBloc, IssueState>(
                    buildWhen: (x, y) => x.selected != y.selected,
                    builder: (context, s) => Column(
                      children: [
                        for (final name in a.itemNames)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(name),
                            subtitle: a.row.given.contains(name)
                                ? Text(l.accIssuedTag)
                                : null,
                            value: s.selected.contains(name),
                            onChanged: (_) => context.read<IssueBloc>().add(
                              IssueItemToggled(name),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (dress) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _size,
                            decoration: InputDecoration(
                              labelText: l.accSizesField,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        BlocBuilder<IssueBloc, IssueState>(
                          buildWhen: (x, y) => x.quantity != y.quantity,
                          builder: (context, s) => Row(
                            children: [
                              Text(l.accSets),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => context.read<IssueBloc>().add(
                                  IssueQuantityChanged(s.quantity - 1),
                                ),
                              ),
                              Text('${s.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => context.read<IssueBloc>().add(
                                  IssueQuantityChanged(s.quantity + 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _receiver,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.accReceivedBy),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SignaturePad(label: l.accSignTitle),
                  const SizedBox(height: AppSpacing.md),
                  ProofPhotoField(label: l.accPhotoOptional),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${l.accIssuedBy(me)} · '
                    '${formatShortDate(context, DateTime.now())}',
                    style: context.text.bodySmall,
                  ),
                  BlocBuilder<IssueBloc, IssueState>(
                    buildWhen: (x, y) => x.problem != y.problem,
                    builder: (context, s) => s.problem == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Text(
                              s.problem!.message(l),
                              style: context.text.bodySmall!.copyWith(
                                color: AppColors.absent,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<IssueBloc, IssueState>(
                    buildWhen: (x, y) => x.saving != y.saving,
                    builder: (context, s) => FilledButton(
                      onPressed: s.saving ? null : _submit,
                      child: Text(l.accIssueAndSave),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
