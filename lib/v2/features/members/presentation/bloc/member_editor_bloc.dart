import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/entities/member.dart';
import '../../domain/usecases/members_usecases.dart';

sealed class MemberEditorEvent extends Equatable {
  const MemberEditorEvent();

  @override
  List<Object?> get props => const [];
}

final class MemberSubmitted extends MemberEditorEvent {
  const MemberSubmitted(this.draft);

  final MemberDraft draft;

  @override
  List<Object?> get props => [draft];
}

class MemberEditorState extends Equatable {
  const MemberEditorState({this.busy = false, this.failure, this.saved});

  final bool busy;
  final ViewFailure? failure;
  final Member? saved;

  @override
  List<Object?> get props => [busy, failure, saved];
}

class MemberEditorBloc extends Bloc<MemberEditorEvent, MemberEditorState> {
  MemberEditorBloc({required SaveMember saveMember})
    : _save = saveMember,
      super(const MemberEditorState()) {
    on<MemberSubmitted>((e, emit) async {
      emit(const MemberEditorState(busy: true));
      try {
        emit(MemberEditorState(saved: await _save(e.draft)));
      } on ServerException catch (error) {
        emit(MemberEditorState(failure: ViewFailure.from(error)));
      }
    });
  }

  final SaveMember _save;
}
