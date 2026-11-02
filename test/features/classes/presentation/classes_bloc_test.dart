import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/classes/domain/entities/class_summary.dart';
import 'package:shiksha_setu/features/classes/domain/repository/classes_repository.dart';
import 'package:shiksha_setu/features/classes/domain/usecases/add_class.dart';
import 'package:shiksha_setu/features/classes/domain/usecases/delete_class.dart';
import 'package:shiksha_setu/features/classes/domain/usecases/get_classes.dart';
import 'package:shiksha_setu/features/classes/domain/usecases/rename_class.dart';
import 'package:shiksha_setu/features/classes/presentation/bloc/classes_bloc.dart';

class InMemoryClasses implements ClassesRepository {
  final names = <String>['6-A'];

  @override
  Future<List<ClassSummary>> getClasses() async => [
    for (final n in names) ClassSummary(name: n, studentCount: 0),
  ];

  @override
  Future<void> add(String name) async => names.add(name);

  @override
  Future<void> rename(String oldName, String newName) async =>
      names[names.indexOf(oldName)] = newName;

  @override
  Future<void> delete(String name) async => names.remove(name);
}

void main() {
  late InMemoryClasses repo;

  ClassesBloc build() => ClassesBloc(
    getClasses: GetClasses(repo),
    addClass: AddClass(repo),
    renameClass: RenameClass(repo),
    deleteClass: DeleteClass(repo),
  );

  setUp(() => repo = InMemoryClasses());

  blocTest<ClassesBloc, ClassesState>(
    'ClassesLoaded: lists the classes and stops loading',
    build: build,
    act: (b) => b.add(const ClassesLoaded()),
    verify: (b) {
      expect(b.state.loading, isFalse);
      expect(b.state.classes.map((c) => c.name), ['6-A']);
    },
  );

  blocTest<ClassesBloc, ClassesState>(
    'ClassAdded: trims the name and reports an "added" change',
    build: build,
    act: (b) => b.add(const ClassAdded('  7-A ')),
    verify: (b) {
      expect(b.state.classes.map((c) => c.name), ['6-A', '7-A']);
      expect(b.state.change?.kind, ClassChangeKind.added);
    },
  );

  blocTest<ClassesBloc, ClassesState>(
    'ClassRenamed: the class appears under its new name',
    build: build,
    act: (b) => b.add(const ClassRenamed('6-A', '6-B')),
    verify: (b) {
      expect(b.state.classes.map((c) => c.name), ['6-B']);
      expect(b.state.change?.kind, ClassChangeKind.renamed);
    },
  );

  blocTest<ClassesBloc, ClassesState>(
    'ClassDeleted: the class is gone',
    build: build,
    act: (b) => b.add(const ClassDeleted('6-A')),
    verify: (b) {
      expect(b.state.classes, isEmpty);
      expect(b.state.change?.kind, ClassChangeKind.deleted);
    },
  );

  blocTest<ClassesBloc, ClassesState>(
    'each change gets a new id so the UI confirms every one',
    build: build,
    act: (b) => b
      ..add(const ClassAdded('7-A'))
      ..add(const ClassAdded('8-A')),
    verify: (b) => expect(b.state.change?.id, 2),
  );

  test('exists: ignores case and spaces, and the class being edited', () async {
    final bloc = build()..add(const ClassesLoaded());
    await bloc.stream.first;

    expect(bloc.state.exists(' 6-a '), isTrue);
    expect(bloc.state.exists('6-A', except: '6-A'), isFalse);
    expect(bloc.state.exists('9-Z'), isFalse);
  });
}
