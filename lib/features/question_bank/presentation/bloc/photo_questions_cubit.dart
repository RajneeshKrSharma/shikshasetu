import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exams/domain/entities/exam_paper.dart';
import '../../../exams/domain/entities/scanned_question.dart';
import '../../../exams/domain/usecases/pick_photo.dart';
import '../../../exams/domain/usecases/scan_questions.dart';
import '../../../exams/presentation/bloc/question_draft.dart';
import '../../../exams/presentation/widgets/question_edit_handler.dart';
import '../../domain/entities/bank_scope.dart';
import '../../domain/entities/bank_unit.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/bank_usecases.dart';

enum PhotoStep { setup, review, fix, saved }

enum ReviewFilter { all, needAnswer, check }

/// One question found in the photos, as the teacher is reviewing it.
class ReviewItem extends Equatable {
  const ReviewItem({
    required this.draft,
    required this.flag,
    required this.included,
    this.checked = false,
  });

  final QuestionDraft draft;
  final ReviewFlag flag;
  final bool included;

  /// The teacher has opened and looked at it.
  final bool checked;

  ReviewItem copyWith({
    QuestionDraft? draft,
    ReviewFlag? flag,
    bool? included,
    bool? checked,
  }) => ReviewItem(
    draft: draft ?? this.draft,
    flag: flag ?? this.flag,
    included: included ?? this.included,
    checked: checked ?? this.checked,
  );

  @override
  List<Object?> get props => [draft, flag, included, checked];
}

class PhotoQuestionsState extends Equatable {
  const PhotoQuestionsState({
    this.units = const [],
    this.unitId,
    this.script = ScanScript.latin,
    this.pages = const [],
    this.reading = false,
    this.step = PhotoStep.setup,
    this.items = const [],
    this.filter = ReviewFilter.all,
    this.fixIndex,
    this.saving = false,
    this.nothingFound = false,
    this.unitMissing = false,
    this.savedCount = 0,
    this.unitBefore = 0,
    this.unitNow = 0,
  });

  final List<BankUnit> units;
  final String? unitId;
  final ScanScript script;
  final List<String> pages;
  final bool reading;
  final PhotoStep step;
  final List<ReviewItem> items;
  final ReviewFilter filter;
  final int? fixIndex;
  final bool saving;
  final bool nothingFound;
  final bool unitMissing;
  final int savedCount;
  final int unitBefore;
  final int unitNow;

  BankUnit? get unit {
    for (final u in units) {
      if (u.id == unitId) return u;
    }
    return null;
  }

  int get includedCount => items.where((i) => i.included).length;
  int countOf(ReviewFlag f) => items.where((i) => i.flag == f).length;

  /// The items on show for the chosen filter, with their place in [items].
  List<(int, ReviewItem)> get visible => [
    for (var i = 0; i < items.length; i++)
      if (switch (filter) {
        ReviewFilter.all => true,
        ReviewFilter.needAnswer => items[i].flag == ReviewFlag.answerMissing,
        ReviewFilter.check => items[i].flag == ReviewFlag.checkPairs,
      })
        (i, items[i]),
  ];

  PhotoQuestionsState copyWith({
    List<BankUnit>? units,
    String? unitId,
    ScanScript? script,
    List<String>? pages,
    bool? reading,
    PhotoStep? step,
    List<ReviewItem>? items,
    ReviewFilter? filter,
    int? fixIndex,
    bool clearFix = false,
    bool? saving,
    bool? nothingFound,
    bool? unitMissing,
    int? savedCount,
    int? unitBefore,
    int? unitNow,
  }) => PhotoQuestionsState(
    units: units ?? this.units,
    unitId: unitId ?? this.unitId,
    script: script ?? this.script,
    pages: pages ?? this.pages,
    reading: reading ?? this.reading,
    step: step ?? this.step,
    items: items ?? this.items,
    filter: filter ?? this.filter,
    fixIndex: clearFix ? null : (fixIndex ?? this.fixIndex),
    saving: saving ?? this.saving,
    nothingFound: nothingFound ?? this.nothingFound,
    unitMissing: unitMissing ?? this.unitMissing,
    savedCount: savedCount ?? this.savedCount,
    unitBefore: unitBefore ?? this.unitBefore,
    unitNow: unitNow ?? this.unitNow,
  );

  @override
  List<Object?> get props => [
    units,
    unitId,
    script,
    pages,
    reading,
    step,
    items,
    filter,
    fixIndex,
    saving,
    nothingFound,
    unitMissing,
    savedCount,
    unitBefore,
    unitNow,
  ];
}

/// The photo flow: choose the unit, take the pages, read, review, save. It is
/// also the handler of the editor while one question is being fixed.
class PhotoQuestionsCubit extends Cubit<PhotoQuestionsState>
    implements QuestionEditHandler {
  PhotoQuestionsCubit({
    required this.scope,
    required GetBankOverview getOverview,
    required AddBankUnit addUnit,
    required SaveBankQuestions save,
    required PickPhoto pickPhoto,
    required ScanQuestions scan,
    required ReviewScanned review,
    required CheckQuestion check,
    String? unitId,
  }) : _getOverview = getOverview,
       _addUnit = addUnit,
       _save = save,
       _pickPhoto = pickPhoto,
       _scan = scan,
       _review = review,
       _check = check,
       super(PhotoQuestionsState(unitId: unitId));

  final BankScope scope;
  final GetBankOverview _getOverview;
  final AddBankUnit _addUnit;
  final SaveBankQuestions _save;
  final PickPhoto _pickPhoto;
  final ScanQuestions _scan;
  final ReviewScanned _review;
  final CheckQuestion _check;

  Future<void> load() async {
    final overview = await _getOverview(scope);
    if (isClosed) return;
    emit(state.copyWith(units: [for (final u in overview.units) u.unit]));
  }

  void unitChosen(String id) =>
      emit(state.copyWith(unitId: id, unitMissing: false));

  Future<void> unitAdded(String name) async {
    final unit = await _addUnit(AddUnitParams(scope, name));
    if (isClosed) return;
    emit(
      state.copyWith(
        units: [...state.units, unit],
        unitId: unit.id,
        unitMissing: false,
      ),
    );
  }

  void scriptChosen(ScanScript s) => emit(state.copyWith(script: s));

  Future<void> takePhoto(PhotoSource source) async {
    final path = await _pickPhoto(source);
    if (path == null || isClosed) return;
    emit(state.copyWith(pages: [...state.pages, path], nothingFound: false));
  }

  void pageRemoved(int index) =>
      emit(state.copyWith(pages: [...state.pages]..removeAt(index)));

  Future<void> read() async {
    if (state.unitId == null) {
      emit(state.copyWith(unitMissing: true));
      return;
    }
    emit(state.copyWith(reading: true, nothingFound: false));
    final found = <ScannedQuestion>[];
    for (final path in state.pages) {
      found.addAll(await _scan(ScanQuestionsParams(path, state.script)));
    }
    final reviewed = await _review(found);
    if (isClosed) return;
    if (reviewed.isEmpty) {
      emit(state.copyWith(reading: false, nothingFound: true));
      return;
    }
    emit(
      state.copyWith(
        reading: false,
        step: PhotoStep.review,
        filter: ReviewFilter.all,
        items: [
          for (var i = 0; i < reviewed.length; i++)
            ReviewItem(
              draft: QuestionDraft.fromScanned(i, reviewed[i].question),
              flag: reviewed[i].flag,
              included: reviewed[i].included,
            ),
        ],
      ),
    );
  }

  void filterChanged(ReviewFilter f) => emit(state.copyWith(filter: f));

  void toggled(int index) => emit(
    state.copyWith(
      items: [
        for (var i = 0; i < state.items.length; i++)
          i == index
              ? state.items[i].copyWith(included: !state.items[i].included)
              : state.items[i],
      ],
    ),
  );

  void backToPhotos() => emit(state.copyWith(step: PhotoStep.setup));

  void fixOpened(int index) =>
      emit(state.copyWith(step: PhotoStep.fix, fixIndex: index));

  /// Leaves the question being fixed, going on by [by] places (0 to go back
  /// to the list). It is then counted as looked at.
  Future<void> fixFinished({int by = 0}) async {
    final index = state.fixIndex;
    if (index == null) return;
    final item = state.items[index];
    final flag = await _check(
      CheckParams(item.draft.toQuestion(), checked: true),
    );
    if (isClosed) return;
    final items = [...state.items]
      ..[index] = item.copyWith(
        draft: item.draft.copyWith(needsReview: false),
        flag: flag,
        checked: true,
        included: item.flag == ReviewFlag.leftOut ? true : item.included,
      );
    final next = index + by;
    final moves = by != 0 && next >= 0 && next < items.length;
    emit(
      state.copyWith(
        items: items,
        step: moves ? PhotoStep.fix : PhotoStep.review,
        fixIndex: moves ? next : null,
        clearFix: !moves,
      ),
    );
  }

  Future<void> save() async {
    final unitId = state.unitId!;
    emit(state.copyWith(saving: true));
    final chosen = [
      for (final i in state.items)
        if (i.included) i.draft.toQuestion(),
    ];
    final overviewBefore = await _getOverview(scope);
    final was = overviewBefore.units
        .firstWhere((u) => u.unit.id == unitId)
        .total;
    await _save(SaveQuestionsParams(scope, unitId, chosen));
    if (isClosed) return;
    emit(
      state.copyWith(
        saving: false,
        step: PhotoStep.saved,
        savedCount: chosen.length,
        unitBefore: was,
        unitNow: was + chosen.length,
      ),
    );
  }

  /// Back to the first step for another photo, keeping the unit.
  void another() => emit(
    PhotoQuestionsState(
      units: state.units,
      unitId: state.unitId,
      script: state.script,
    ),
  );

  void _edit(QuestionDraft Function(QuestionDraft) change) {
    final index = state.fixIndex;
    if (index == null) return;
    emit(
      state.copyWith(
        items: [
          for (var i = 0; i < state.items.length; i++)
            i == index
                ? state.items[i].copyWith(draft: change(state.items[i].draft))
                : state.items[i],
        ],
      ),
    );
  }

  @override
  void text(String value) => _edit((d) => d.copyWith(text: value));
  @override
  void marks(String value) => _edit((d) => d.copyWith(marks: value));
  @override
  void answer(String value) => _edit((d) => d.copyWith(answer: value));
  @override
  void type(QuestionType type) => _edit((d) => d.withType(type));
  @override
  void optionEdited(int index, String value) =>
      _edit((d) => d.withOptionEdited(index, value));
  @override
  void optionAdded() => _edit((d) => d.withOptionAdded());
  @override
  void optionRemoved(int index) => _edit((d) => d.withOptionRemoved(index));
  @override
  void correct(int? index) => _edit((d) => d.withCorrect(index));
  @override
  void pairEdited(int index, {String? left, String? right}) =>
      _edit((d) => d.withPairEdited(index, left: left, right: right));
  @override
  void pairAdded() => _edit((d) => d.withPairAdded());
  @override
  void pairRemoved(int index) => _edit((d) => d.withPairRemoved(index));
}
