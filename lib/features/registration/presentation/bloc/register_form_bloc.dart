import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/gender.dart';
import '../../../../core/utils/aadhaar.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../members/domain/usecases/member_crud.dart';
import '../../../students/domain/entities/student.dart';
import '../../../students/domain/usecases/get_vehicle_numbers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/staff_role.dart';
import '../../domain/repository/registration_repository.dart';
import '../../domain/usecases/register_other.dart';
import '../../domain/usecases/register_teacher.dart';

/// Everything typed into the form, handed over on submit.
class RegistrationFields extends Equatable {
  const RegistrationFields({
    required this.name,
    required this.aadhaar,
    required this.phone,
    this.guardian = '',
    this.roleTitle = '',
    this.email = '',
    this.password = '',
    this.address = '',
    this.aadhaarReason = '',
    this.vehicleNumber = '',
  });

  final String name;

  /// The full number, or empty when it is not given; only its masked form is
  /// stored.
  final String aadhaar;
  final String phone;
  final String guardian;
  final String roleTitle;
  final String email;
  final String password;
  final String address;

  /// Why there is no Aadhaar number; only used when [aadhaar] is empty.
  final String aadhaarReason;

  /// A driver's van.
  final String vehicleNumber;

  @override
  List<Object?> get props => [
    name,
    aadhaar,
    phone,
    guardian,
    roleTitle,
    email,
    password,
    address,
    aadhaarReason,
    vehicleNumber,
  ];
}

sealed class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object?> get props => const [];
}

/// The form opened; when it is for changing a student, read them.
final class RegisterFormStarted extends RegisterFormEvent {
  const RegisterFormStarted();
}

/// The van a student travels by; null for none.
final class RegisterVehicleChosen extends RegisterFormEvent {
  const RegisterVehicleChosen(this.vehicleNumber);

  final String? vehicleNumber;

  @override
  List<Object?> get props => [vehicleNumber];
}

final class RegisterClassChosen extends RegisterFormEvent {
  const RegisterClassChosen(this.classSection);

  final String? classSection;

  @override
  List<Object?> get props => [classSection];
}

final class RegisterSubjectChosen extends RegisterFormEvent {
  const RegisterSubjectChosen(this.subject);

  final String? subject;

  @override
  List<Object?> get props => [subject];
}

/// The gender chosen, or read from the Aadhaar card; null clears it.
final class RegisterGenderChosen extends RegisterFormEvent {
  const RegisterGenderChosen(this.gender);

  final Gender? gender;

  @override
  List<Object?> get props => [gender];
}

/// The date of birth picked, or read from the Aadhaar card; null clears it.
final class RegisterDobChosen extends RegisterFormEvent {
  const RegisterDobChosen(this.dateOfBirth);

  final DateTime? dateOfBirth;

  @override
  List<Object?> get props => [dateOfBirth];
}

final class RegisterSubmitted extends RegisterFormEvent {
  const RegisterSubmitted(this.fields);

  final RegistrationFields fields;

  @override
  List<Object?> get props => [fields];
}

class RegisterFormState extends Equatable {
  const RegisterFormState({
    this.type = PersonType.student,
    this.classSection,
    this.subject,
    this.saving = false,
    this.emailTaken = false,
    this.failure,
    this.failureMessage,
    this.done = false,
    this.dateOfBirth,
    this.gender,
    this.editing,
    this.vehicleNumber,
    this.vehicles = const [],
  });

  final PersonType type;
  final String? classSection;
  final String? subject;
  final bool saving;
  final bool emailTaken;

  /// Why creating the teacher's login failed, other than the email being used.
  final AuthFailure? failure;

  /// What the server said about [failure], in its own words.
  final String? failureMessage;

  /// The registration was saved.
  final bool done;
  final DateTime? dateOfBirth;
  final Gender? gender;

  /// The student being changed, once read; null when adding someone.
  final Student? editing;

  /// The van chosen for a student, and the vans to choose from.
  final String? vehicleNumber;
  final List<String> vehicles;

  RegisterFormState copyWith({
    PersonType? type,
    String? classSection,
    bool clearClass = false,
    String? subject,
    bool clearSubject = false,
    bool? saving,
    bool? emailTaken,
    AuthFailure? failure,
    String? failureMessage,
    bool clearFailure = false,
    bool? done,
    DateTime? dateOfBirth,
    bool clearDob = false,
    Gender? gender,
    bool clearGender = false,
    Student? editing,
    String? vehicleNumber,
    bool clearVehicle = false,
    List<String>? vehicles,
  }) => RegisterFormState(
    type: type ?? this.type,
    classSection: clearClass ? null : (classSection ?? this.classSection),
    subject: clearSubject ? null : (subject ?? this.subject),
    saving: saving ?? this.saving,
    emailTaken: emailTaken ?? this.emailTaken,
    failure: clearFailure ? null : (failure ?? this.failure),
    failureMessage: clearFailure
        ? null
        : (failureMessage ?? this.failureMessage),
    done: done ?? this.done,
    dateOfBirth: clearDob ? null : (dateOfBirth ?? this.dateOfBirth),
    gender: clearGender ? null : (gender ?? this.gender),
    editing: editing ?? this.editing,
    vehicleNumber: clearVehicle ? null : (vehicleNumber ?? this.vehicleNumber),
    vehicles: vehicles ?? this.vehicles,
  );

  @override
  List<Object?> get props => [
    type,
    classSection,
    subject,
    saving,
    emailTaken,
    failure,
    failureMessage,
    done,
    dateOfBirth,
    gender,
    editing,
    vehicleNumber,
    vehicles,
  ];
}

/// Which kind of person the form is for, and, when changing a student rather
/// than adding one, who.
class RegisterFormArgs extends Equatable {
  const RegisterFormArgs(this.type, {this.studentId});

  final PersonType type;
  final String? studentId;

  @override
  List<Object?> get props => [type, studentId];
}

/// State and submission of the "New registration" form.
class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  RegisterFormBloc({
    required RegisterFormArgs args,
    required GetMember<Student> getStudent,
    required GetVehicleNumbers getVehicles,
    required AddMember<Student> addStudent,
    required UpdateMember<Student> updateStudent,
    required RegisterTeacher registerTeacher,
    required RegisterOther registerOther,
  }) : _studentId = args.studentId,
       _getStudent = getStudent,
       _getVehicles = getVehicles,
       _addStudent = addStudent,
       _updateStudent = updateStudent,
       _registerTeacher = registerTeacher,
       _registerOther = registerOther,
       super(RegisterFormState(type: args.type)) {
    on<RegisterFormStarted>(_onStarted);
    on<RegisterVehicleChosen>(
      (e, emit) => emit(
        e.vehicleNumber == null
            ? state.copyWith(clearVehicle: true)
            : state.copyWith(vehicleNumber: e.vehicleNumber),
      ),
    );
    on<RegisterClassChosen>(
      (e, emit) => emit(
        e.classSection == null
            ? state.copyWith(clearClass: true)
            : state.copyWith(classSection: e.classSection),
      ),
    );
    on<RegisterSubjectChosen>(
      (e, emit) => emit(
        e.subject == null
            ? state.copyWith(clearSubject: true)
            : state.copyWith(subject: e.subject),
      ),
    );
    on<RegisterDobChosen>(
      (e, emit) => emit(
        e.dateOfBirth == null
            ? state.copyWith(clearDob: true)
            : state.copyWith(dateOfBirth: e.dateOfBirth),
      ),
    );
    on<RegisterGenderChosen>(
      (e, emit) => emit(
        e.gender == null
            ? state.copyWith(clearGender: true)
            : state.copyWith(gender: e.gender),
      ),
    );
    on<RegisterSubmitted>(_onSubmitted);
  }

  final String? _studentId;
  final GetMember<Student> _getStudent;
  final GetVehicleNumbers _getVehicles;
  final AddMember<Student> _addStudent;
  final UpdateMember<Student> _updateStudent;
  final RegisterTeacher _registerTeacher;
  final RegisterOther _registerOther;
  Future<void> _onStarted(
    RegisterFormStarted e,
    Emitter<RegisterFormState> emit,
  ) async {
    if (state.type == PersonType.student) {
      emit(state.copyWith(vehicles: await _getVehicles(const NoParams())));
    }
    final id = _studentId;
    if (id == null) return;
    final student = await _getStudent(id);
    if (student == null) return;
    emit(
      state.copyWith(
        editing: student,
        vehicleNumber: student.vehicleNumber,
        classSection: student.classSection,
        gender: student.gender,
        dateOfBirth: student.dateOfBirth,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted e,
    Emitter<RegisterFormState> emit,
  ) async {
    emit(state.copyWith(saving: true, emailTaken: false, clearFailure: true));
    final f = e.fields;
    final hasAadhaar = Aadhaar.digitsOnly(f.aadhaar).isNotEmpty;
    final masked = hasAadhaar ? Aadhaar.mask(f.aadhaar) : null;
    final reason = hasAadhaar ? null : f.aadhaarReason.trim();
    final phone = '+91 ${f.phone.trim()}';
    try {
      switch (state.type) {
        case PersonType.student:
          final address = f.address.trim().isEmpty ? null : f.address.trim();
          final editing = state.editing;
          if (editing != null) {
            await _updateStudent(
              editing.edited(
                name: f.name,
                classSection: state.classSection!,
                guardian: f.guardian,
                phone: phone,
                vehicleNumber: state.vehicleNumber,
                gender: state.gender,
                dateOfBirth: state.dateOfBirth,
                address: address,
              ),
            );
          } else {
            await _addStudent(
              Student.draft(
                name: f.name,
                classSection: state.classSection!,
                guardian: f.guardian,
                phone: phone,
                vehicleNumber: state.vehicleNumber,
                aadhaarMasked: masked ?? '',
                aadhaarReason: reason,
                dateOfBirth: state.dateOfBirth,
                gender: state.gender,
                address: address,
              ),
            );
          }
        case PersonType.teacher:
          await _registerTeacher(
            RegisterTeacherParams(
              name: f.name,
              email: f.email,
              phone: phone,
              subject: state.subject!,
              aadhaarMasked: masked,
              aadhaarReason: reason,
              password: f.password,
              dateOfBirth: state.dateOfBirth,
              gender: state.gender,
              address: f.address.trim().isEmpty ? null : f.address.trim(),
            ),
          );
        case PersonType.other:
          await _registerOther(
            RegisterOtherParams(
              name: f.name,
              roleTitle: f.roleTitle,
              phone: phone,
              aadhaarMasked: masked,
              aadhaarReason: reason,
              dateOfBirth: state.dateOfBirth,
              gender: state.gender,
              address: f.address.trim().isEmpty ? null : f.address.trim(),
              vehicleNumber: StaffRole.drivesVehicle(f.roleTitle)
                  ? f.vehicleNumber.trim().toUpperCase()
                  : null,
            ),
          );
      }
      emit(state.copyWith(saving: false, done: true));
    } on RegistrationException {
      emit(state.copyWith(saving: false, emailTaken: true));
    } on AuthException catch (e) {
      emit(
        e.failure == AuthFailure.emailTaken
            ? state.copyWith(saving: false, emailTaken: true)
            : state.copyWith(
                saving: false,
                failure: e.failure,
                failureMessage: e.message,
              ),
      );
    }
  }
}
