import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/registration/domain/entities/person.dart';
import 'package:shiksha_setu/features/registration/domain/repository/registration_repository.dart';
import 'package:shiksha_setu/features/registration/domain/usecases/register_other.dart';
import 'package:shiksha_setu/features/registration/domain/usecases/register_teacher.dart';
import 'package:shiksha_setu/features/registration/presentation/bloc/register_form_bloc.dart';
import 'package:shiksha_setu/features/students/domain/entities/student.dart';
import 'package:shiksha_setu/features/students/domain/repository/students_repository.dart';
import 'package:shiksha_setu/features/students/domain/usecases/add_student.dart';

class RecordingStudents implements StudentsRepository {
  Map<String, String>? added;

  @override
  Future<void> add({
    required String name,
    required String classSection,
    required String guardian,
    required String phone,
    required String aadhaarMasked,
  }) async => added = {
    'name': name,
    'class': classSection,
    'phone': phone,
    'aadhaar': aadhaarMasked,
  };

  @override
  Future<List<Student>> getByClass(String classSection) async => const [];
}

class FakeRegistration implements RegistrationRepository {
  FakeRegistration({this.emailTaken = false});

  final bool emailTaken;
  String? teacherPhone;

  @override
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String aadhaarMasked,
    required String password,
  }) async {
    if (emailTaken) {
      throw const RegistrationException(RegistrationFailure.emailTaken);
    }
    teacherPhone = phone;
  }

  @override
  Future<void> registerOther({
    required String name,
    required String roleTitle,
    required String phone,
    required String aadhaarMasked,
  }) async {}

  @override
  Future<List<Person>> getPeople() async => const [];
}

void main() {
  late RecordingStudents students;

  RegisterFormBloc build({bool emailTaken = false}) {
    final registration = FakeRegistration(emailTaken: emailTaken);
    return RegisterFormBloc(
      addStudent: AddStudent(students),
      registerTeacher: RegisterTeacher(registration),
      registerOther: RegisterOther(registration),
    );
  }

  const fields = RegistrationFields(
    name: 'Ravi',
    aadhaar: '2345 6789 0124',
    phone: '9876543210',
    guardian: 'Suresh',
    email: 'ravi@school.test',
    password: 'secret-pass',
  );

  setUp(() => students = RecordingStudents());

  blocTest<RegisterFormBloc, RegisterFormState>(
    'RegisterTypeChanged: switches the form type',
    build: build,
    act: (b) => b.add(const RegisterTypeChanged(PersonType.teacher)),
    verify: (b) => expect(b.state.type, PersonType.teacher),
  );

  blocTest<RegisterFormBloc, RegisterFormState>(
    'RegisterSubmitted (student): stores only the masked Aadhaar and +91 phone',
    build: build,
    act: (b) => b
      ..add(const RegisterClassChosen('6-A'))
      ..add(const RegisterSubmitted(fields)),
    verify: (b) {
      expect(students.added, {
        'name': 'Ravi',
        'class': '6-A',
        'phone': '+91 9876543210',
        'aadhaar': 'XXXX XXXX 0124',
      });
      expect(b.state.done, isTrue);
    },
  );

  blocTest<RegisterFormBloc, RegisterFormState>(
    'RegisterSubmitted (teacher): success marks the form done',
    build: build,
    act: (b) => b
      ..add(const RegisterTypeChanged(PersonType.teacher))
      ..add(const RegisterSubjectChosen('Maths'))
      ..add(const RegisterSubmitted(fields)),
    verify: (b) => expect(b.state.done, isTrue),
  );

  blocTest<RegisterFormBloc, RegisterFormState>(
    'RegisterSubmitted (teacher): email already used → emailTaken, not done',
    build: () => build(emailTaken: true),
    act: (b) => b
      ..add(const RegisterTypeChanged(PersonType.teacher))
      ..add(const RegisterSubjectChosen('Maths'))
      ..add(const RegisterSubmitted(fields)),
    verify: (b) {
      expect(b.state.emailTaken, isTrue);
      expect(b.state.done, isFalse);
      expect(b.state.saving, isFalse);
    },
  );

  blocTest<RegisterFormBloc, RegisterFormState>(
    'RegisterTypeChanged: clears an earlier "email taken" error',
    build: () => build(emailTaken: true),
    act: (b) async {
      b
        ..add(const RegisterTypeChanged(PersonType.teacher))
        ..add(const RegisterSubjectChosen('Maths'))
        ..add(const RegisterSubmitted(fields));
      // Let the failed submission finish before the user changes the type.
      await b.stream.firstWhere((s) => s.emailTaken);
      b.add(const RegisterTypeChanged(PersonType.other));
    },
    verify: (b) => expect(b.state.emailTaken, isFalse),
  );
}
