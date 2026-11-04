import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../exams/domain/entities/exams.dart';
import '../../../exams/domain/usecases/exams_usecases.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/timetable.dart';
import '../../domain/usecases/timetable_usecases.dart';

sealed class TimetableEvent extends Equatable {
  const TimetableEvent();

  @override
  List<Object?> get props => const [];
}

final class TimetableStarted extends TimetableEvent {
  const TimetableStarted();
}

final class TimetableClassChosen extends TimetableEvent {
  const TimetableClassChosen(this.classId);

  final String classId;

  @override
  List<Object?> get props => [classId];
}

final class TimetableTypeChosen extends TimetableEvent {
  const TimetableTypeChosen(this.type);

  final ExamType type;

  @override
  List<Object?> get props => [type];
}

final class TimetableRowChanged extends TimetableEvent {
  const TimetableRowChanged(this.index, this.row);

  final int index;
  final TimetableRow row;

  @override
  List<Object?> get props => [index, row];
}

final class TimetableSubjectAdded extends TimetableEvent {
  const TimetableSubjectAdded(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class TimetablePaperEdited extends TimetableEvent {
  const TimetablePaperEdited(this.draft);

  final ExamDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class TimetableSubmitted extends TimetableEvent {
  const TimetableSubmitted();
}

final class TimetableSettingsChanged extends TimetableEvent {
  const TimetableSettingsChanged(this.settings);

  final TimetableSettings settings;

  @override
  List<Object?> get props => [settings];
}

final class TimetableExamRemoved extends TimetableEvent {
  const TimetableExamRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class TimetableState extends Equatable {
  const TimetableState({
    this.status = ViewStatus.loading,
    this.failure,
    this.settings,
    this.classes = const [],
    this.classId,
    this.type = ExamType.midTerm,
    this.rows = const [],
    this.exams = const [],
    this.warnings = const [],
    this.busy = false,
    this.savedCount = 0,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final TimetableSettings? settings;
  final List<SchoolClass> classes;
  final String? classId;
  final ExamType type;

  /// The subjects of the chosen class, each waiting for a date.
  final List<TimetableRow> rows;

  /// Every exam already scheduled for the chosen class.
  final List<Exam> exams;

  /// What the server asked the Principal to note after the last save.
  final List<String> warnings;
  final bool busy;

  /// Goes up by one each time a timetable is saved, so the screen can say so.
  final int savedCount;

  /// A class is chosen and this exam has papers saved to print.
  bool get canPrint => classId != null && savedOfType.isNotEmpty;

  bool get canSave => !busy && rows.any((r) => r.isScheduled);

  /// The saved papers of the chosen exam, soonest first.
  List<Exam> get savedOfType => [
    for (final e in exams)
      if (e.type == type) e,
  ];

  TimetableState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    TimetableSettings? settings,
    List<SchoolClass>? classes,
    String? classId,
    ExamType? type,
    List<TimetableRow>? rows,
    List<Exam>? exams,
    List<String>? warnings,
    bool? busy,
    int? savedCount,
  }) => TimetableState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    settings: settings ?? this.settings,
    classes: classes ?? this.classes,
    classId: classId ?? this.classId,
    type: type ?? this.type,
    rows: rows ?? this.rows,
    exams: exams ?? this.exams,
    warnings: warnings ?? this.warnings,
    busy: busy ?? this.busy,
    savedCount: savedCount ?? this.savedCount,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    settings,
    classes,
    classId,
    type,
    rows,
    exams,
    warnings,
    busy,
    savedCount,
  ];
}

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableBloc({
    required GetTimetableSettings getSettings,
    required GetClasses getClasses,
    required GetClassSubjects getSubjects,
    required GetExams getExams,
    required SaveTimetable saveTimetable,
    required RemoveExam removeExam,
    required SaveExam saveExam,
  }) : _getSettings = getSettings,
       _getClasses = getClasses,
       _getSubjects = getSubjects,
       _getExams = getExams,
       _save = saveTimetable,
       _remove = removeExam,
       _saveExam = saveExam,
       super(const TimetableState()) {
    on<TimetableStarted>(_onStarted);
    on<TimetableClassChosen>(_onClassChosen);
    on<TimetableTypeChosen>(
      (e, emit) => emit(state.copyWith(type: e.type, warnings: const [])),
    );
    on<TimetableRowChanged>(_onRowChanged);
    on<TimetableSubjectAdded>(_onSubjectAdded);
    on<TimetablePaperEdited>(_onPaperEdited);
    on<TimetableSubmitted>(_onSubmitted);
    on<TimetableSettingsChanged>(
      (e, emit) => emit(state.copyWith(settings: e.settings)),
    );
    on<TimetableExamRemoved>(_onRemoved);
  }

  final GetTimetableSettings _getSettings;
  final GetClasses _getClasses;
  final GetClassSubjects _getSubjects;
  final GetExams _getExams;
  final SaveTimetable _save;
  final RemoveExam _remove;
  final SaveExam _saveExam;

  Future<void> _onStarted(
    TimetableStarted e,
    Emitter<TimetableState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      final settings = await _getSettings(const NoParams());
      final classes = await _getClasses(const NoParams());
      emit(
        state.copyWith(
          status: ViewStatus.ready,
          settings: settings,
          classes: classes,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _onClassChosen(
    TimetableClassChosen e,
    Emitter<TimetableState> emit,
  ) async {
    emit(
      state.copyWith(
        classId: e.classId,
        busy: true,
        warnings: const [],
        rows: const [],
        exams: const [],
        clearFailure: true,
      ),
    );
    await _reload(emit, e.classId);
  }

  void _onRowChanged(TimetableRowChanged e, Emitter<TimetableState> emit) {
    final rows = [...state.rows];
    if (e.index < 0 || e.index >= rows.length) return;
    rows[e.index] = e.row;
    emit(state.copyWith(rows: rows));
  }

  void _onSubjectAdded(TimetableSubjectAdded e, Emitter<TimetableState> emit) {
    final name = e.name.trim();
    if (name.isEmpty) return;
    final exists = state.rows.any(
      (r) => r.subject.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;
    emit(
      state.copyWith(
        rows: [
          ...state.rows,
          TimetableRow(subject: name),
        ],
      ),
    );
  }

  Future<void> _onSubmitted(
    TimetableSubmitted e,
    Emitter<TimetableState> emit,
  ) async {
    final classId = state.classId;
    if (classId == null || !state.canSave) return;
    emit(state.copyWith(busy: true, clearFailure: true, warnings: const []));
    try {
      final warnings = await _save(
        TimetableDraft(type: state.type, classId: classId, rows: state.rows),
      );
      emit(
        state.copyWith(warnings: warnings, savedCount: state.savedCount + 1),
      );
      await _reload(emit, classId);
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onPaperEdited(
    TimetablePaperEdited e,
    Emitter<TimetableState> emit,
  ) async {
    final classId = state.classId;
    if (classId == null) return;
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _saveExam(e.draft);
      emit(state.copyWith(savedCount: state.savedCount + 1));
      await _reload(emit, classId);
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  Future<void> _onRemoved(
    TimetableExamRemoved e,
    Emitter<TimetableState> emit,
  ) async {
    final classId = state.classId;
    if (classId == null) return;
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await _remove(e.id);
      await _reload(emit, classId);
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }

  /// Fresh subject lines and the exams already saved for [classId].
  Future<void> _reload(Emitter<TimetableState> emit, String classId) async {
    try {
      final rows = await _getSubjects(classId);
      final exams = await _getExams(classId);
      emit(state.copyWith(busy: false, rows: rows, exams: exams));
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
