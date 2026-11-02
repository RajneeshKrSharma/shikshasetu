import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/usecases/add_class.dart';
import '../../domain/usecases/delete_class.dart';
import '../../domain/usecases/get_classes.dart';
import '../../domain/usecases/rename_class.dart';

sealed class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object?> get props => const [];
}

final class ClassesLoaded extends ClassesEvent {
  const ClassesLoaded();
}

final class ClassAdded extends ClassesEvent {
  const ClassAdded(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class ClassRenamed extends ClassesEvent {
  const ClassRenamed(this.oldName, this.newName);

  final String oldName;
  final String newName;

  @override
  List<Object?> get props => [oldName, newName];
}

final class ClassDeleted extends ClassesEvent {
  const ClassDeleted(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

enum ClassChangeKind { added, renamed, deleted }

/// A change that just happened, so the UI can confirm it once ([id] makes
/// each one distinct).
class ClassChange extends Equatable {
  const ClassChange(this.kind, this.id);

  final ClassChangeKind kind;
  final int id;

  @override
  List<Object?> get props => [kind, id];
}

class ClassesState extends Equatable {
  const ClassesState({
    this.loading = true,
    this.classes = const [],
    this.change,
  });

  final bool loading;
  final List<ClassSummary> classes;
  final ClassChange? change;

  /// True if a class with [name] exists (ignoring case), other than [except].
  bool exists(String name, {String? except}) => classes.any(
    (c) =>
        c.name.toLowerCase() == name.trim().toLowerCase() && c.name != except,
  );

  ClassesState copyWith({
    bool? loading,
    List<ClassSummary>? classes,
    ClassChange? change,
  }) => ClassesState(
    loading: loading ?? this.loading,
    classes: classes ?? this.classes,
    change: change ?? this.change,
  );

  @override
  List<Object?> get props => [loading, classes, change];
}

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  ClassesBloc({
    required GetClasses getClasses,
    required AddClass addClass,
    required RenameClass renameClass,
    required DeleteClass deleteClass,
  }) : _getClasses = getClasses,
       _addClass = addClass,
       _renameClass = renameClass,
       _deleteClass = deleteClass,
       super(const ClassesState()) {
    on<ClassesLoaded>(_onLoaded);
    on<ClassAdded>(
      (e, emit) =>
          _mutate(emit, ClassChangeKind.added, () => _addClass(e.name)),
    );
    on<ClassRenamed>(
      (e, emit) => _mutate(
        emit,
        ClassChangeKind.renamed,
        () => _renameClass(RenameClassParams(e.oldName, e.newName)),
      ),
    );
    on<ClassDeleted>(
      (e, emit) =>
          _mutate(emit, ClassChangeKind.deleted, () => _deleteClass(e.name)),
    );
  }

  final GetClasses _getClasses;
  final AddClass _addClass;
  final RenameClass _renameClass;
  final DeleteClass _deleteClass;

  int _changeId = 0;

  Future<void> _onLoaded(ClassesLoaded e, Emitter<ClassesState> emit) async {
    emit(
      state.copyWith(
        loading: false,
        classes: await _getClasses(const NoParams()),
      ),
    );
  }

  Future<void> _mutate(
    Emitter<ClassesState> emit,
    ClassChangeKind kind,
    Future<void> Function() action,
  ) async {
    await action();
    emit(
      state.copyWith(
        loading: false,
        classes: await _getClasses(const NoParams()),
        change: ClassChange(kind, ++_changeId),
      ),
    );
  }
}
