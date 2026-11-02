import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/accessory_issue.dart';
import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/issue_draft.dart';
import '../../domain/entities/student_accessory_row.dart';
import '../../domain/usecases/accessories_usecases.dart';

/// What an [IssueBloc] needs to start.
class IssueArgs extends Equatable {
  const IssueArgs({
    required this.kind,
    required this.row,
    required this.className,
    required this.itemNames,
  });

  final AccessoryKind kind;
  final StudentAccessoryRow row;
  final String className;

  /// The pieces of the class's set, in order.
  final List<String> itemNames;

  @override
  List<Object?> get props => [kind, row, className, itemNames];
}

sealed class IssueEvent extends Equatable {
  const IssueEvent();

  @override
  List<Object?> get props => const [];
}

final class IssueItemToggled extends IssueEvent {
  const IssueItemToggled(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class IssueQuantityChanged extends IssueEvent {
  const IssueQuantityChanged(this.quantity);

  final int quantity;

  @override
  List<Object?> get props => [quantity];
}

final class IssueSubmitted extends IssueEvent {
  const IssueSubmitted({
    required this.receivedBy,
    required this.issuedBy,
    this.size,
    this.signaturePath,
    this.photoPath,
  });

  final String receivedBy;
  final String issuedBy;
  final String? size;
  final String? signaturePath;
  final String? photoPath;

  @override
  List<Object?> get props => [
    receivedBy,
    issuedBy,
    size,
    signaturePath,
    photoPath,
  ];
}

class IssueState extends Equatable {
  const IssueState({
    required this.selected,
    this.quantity = 1,
    this.saving = false,
    this.problem,
    this.issued,
  });

  final Set<String> selected;
  final int quantity;
  final bool saving;
  final IssueProblem? problem;
  final AccessoryIssue? issued;

  IssueState copyWith({
    Set<String>? selected,
    int? quantity,
    bool? saving,
    IssueProblem? problem,
    bool clearProblem = false,
    AccessoryIssue? issued,
  }) => IssueState(
    selected: selected ?? this.selected,
    quantity: quantity ?? this.quantity,
    saving: saving ?? this.saving,
    problem: clearProblem ? null : (problem ?? this.problem),
    issued: issued ?? this.issued,
  );

  @override
  List<Object?> get props => [selected, quantity, saving, problem, issued];
}

/// Handing dress or books to one student.
class IssueBloc extends Bloc<IssueEvent, IssueState> {
  IssueBloc({
    required this.args,
    required IssueAccessories issue,
    DateTime Function()? now,
  }) : _issue = issue,
       _now = now ?? DateTime.now,
       super(
         IssueState(
           // Pieces not given yet start ticked.
           selected: {
             for (final n in args.itemNames)
               if (!args.row.given.contains(n)) n,
           },
         ),
       ) {
    on<IssueItemToggled>((e, emit) {
      final next = {...state.selected};
      if (!next.remove(e.name)) next.add(e.name);
      emit(state.copyWith(selected: next, clearProblem: true));
    });
    on<IssueQuantityChanged>(
      (e, emit) =>
          emit(state.copyWith(quantity: e.quantity < 1 ? 1 : e.quantity)),
    );
    on<IssueSubmitted>(_onSubmitted);
  }

  final IssueArgs args;
  final IssueAccessories _issue;
  final DateTime Function() _now;

  Future<void> _onSubmitted(IssueSubmitted e, Emitter<IssueState> emit) async {
    emit(state.copyWith(saving: true, clearProblem: true));
    try {
      final issued = await _issue(
        IssueAccessoriesParams(
          studentId: args.row.studentId,
          draft: IssueDraft(
            kind: args.kind,
            // In the order of the set.
            items: [
              for (final n in args.itemNames)
                if (state.selected.contains(n)) n,
            ],
            receivedBy: e.receivedBy,
            size: e.size,
            signaturePath: e.signaturePath,
          ),
          issuedBy: e.issuedBy,
          at: _now(),
          quantity: state.quantity,
          photoPath: e.photoPath,
        ),
      );
      emit(state.copyWith(saving: false, issued: issued));
    } on IssueException catch (x) {
      emit(state.copyWith(saving: false, problem: x.problem));
    }
  }
}
