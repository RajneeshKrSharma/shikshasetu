import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/utils/context_ext.dart';
import '../../domain/entities/notice.dart';
import '../../domain/usecases/notices_usecases.dart';
import '../bloc/notices_bloc.dart';

Future<void> showComposeNoticeSheet(BuildContext context) async {
  final bloc = context.read<NoticesBloc>();
  final params = await showModalBottomSheet<PostNoticeParams>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _ComposeSheet(),
  );
  if (params != null) bloc.add(NoticePosted(params));
}

class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet();

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final ValueNotifier<NoticeKind> _kind;
  late final GlobalKey<FormState> _key;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _body = TextEditingController();
    _kind = ValueNotifier(NoticeKind.notice);
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _kind.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.noticePost, style: context.text.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder<NoticeKind>(
                valueListenable: _kind,
                builder: (context, kind, _) => SegmentedButton<NoticeKind>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: NoticeKind.notice,
                      label: Text(l.noticeKindNotice),
                    ),
                    ButtonSegment(
                      value: NoticeKind.announcement,
                      label: Text(l.noticeAnnouncement),
                    ),
                  ],
                  selected: {kind},
                  onSelectionChanged: (s) => _kind.value = s.first,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _title,
                maxLength: 150,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l.fieldNoticeTitle),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              TextFormField(
                controller: _body,
                maxLength: 2000,
                minLines: 3,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l.fieldNoticeBody),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.errorRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () {
                  if (!_key.currentState!.validate()) return;
                  Navigator.pop(
                    context,
                    PostNoticeParams(
                      kind: _kind.value,
                      title: _title.text,
                      body: _body.text,
                    ),
                  );
                },
                child: Text(l.noticePost),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
