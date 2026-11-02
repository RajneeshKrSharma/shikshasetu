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
import '../../domain/usecases/teaching_usecases.dart';
import '../bloc/my_lessons_bloc.dart';
import '../widgets/topic_dialog.dart';

/// A teacher's own classes, where today's lesson is recorded, and the
/// lessons from the last month.
class MyLessonsScreen extends StatelessWidget {
  const MyLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<SessionBloc>().state.account!;
    return BlocProvider(
      create: (_) =>
          sl<MyLessonsBloc>(param1: account)..add(const MyLessonsStarted()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FailureToast<MyLessonsBloc, MyLessonsState>(
      failureOf: (s) => s.failure,
      child: BlocBuilder<MyLessonsBloc, MyLessonsState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(l.navLessons)),
          body: AsyncBody(
            status: state.status,
            failure: state.failure,
            onRetry: () =>
                context.read<MyLessonsBloc>().add(const MyLessonsStarted()),
            isEmpty: state.allotments.isEmpty,
            emptyText: l.tchAllotmentsEmpty,
            emptyIcon: Icons.menu_book_outlined,
            builder: (context) => ListView(
              padding: AppSpacing.page,
              children: [
                SectionTitle(l.tchMyClasses),
                for (final a in state.allotments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.tchClassSubject(a.className, a.subject),
                              style: context.text.titleSmall,
                            ),
                          ),
                          if (state.canRecord)
                            FilledButton.tonal(
                              style: FilledButton.styleFrom(
                                minimumSize: AppSizes.dialogButton,
                              ),
                              onPressed: state.busy
                                  ? null
                                  : () async {
                                      final bloc = context
                                          .read<MyLessonsBloc>();
                                      final topic = await showTopicDialog(
                                        context,
                                        title: l.tchRecordLesson,
                                      );
                                      if (topic != null) {
                                        bloc.add(
                                          LessonSubmitted(
                                            RecordLessonParams(
                                              allotmentId: a.id,
                                              topic: topic,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              child: Text(l.tchRecordLesson),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                SectionTitle(l.tchRecentLessons),
                if (state.lessons.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(l.tchLessonsEmpty),
                  ),
                for (final lesson in state.lessons)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lesson.topic),
                    subtitle: Text(
                      '${l.tchClassSubject(lesson.className, lesson.subject)} · '
                      '${formatShortDate(context, lesson.takenOn)}',
                    ),
                    trailing: state.canRecord
                        ? IconButton(
                            tooltip: l.tchEditLesson,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final bloc = context.read<MyLessonsBloc>();
                              final topic = await showTopicDialog(
                                context,
                                title: l.tchEditLesson,
                                initial: lesson.topic,
                              );
                              if (topic != null) {
                                bloc.add(
                                  LessonSubmitted(
                                    RecordLessonParams(
                                      lessonId: lesson.id,
                                      topic: topic,
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
