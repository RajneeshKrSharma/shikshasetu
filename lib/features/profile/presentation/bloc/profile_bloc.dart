import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../auth/domain/usecases/change_password.dart';
import '../../../auth/domain/usecases/request_email_change.dart';
import '../../../auth/domain/usecases/update_profile.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => const [];
}

final class ProfileEdited extends ProfileEvent {
  const ProfileEdited({
    required this.userId,
    required this.name,
    required this.phone,
  });

  final String userId;
  final String name;
  final String phone;

  @override
  List<Object?> get props => [userId, name, phone];
}

final class PasswordChangeSubmitted extends ProfileEvent {
  const PasswordChangeSubmitted({
    required this.userId,
    required this.current,
    required this.next,
  });

  final String userId;
  final String current;
  final String next;

  @override
  List<Object?> get props => [userId, current, next];
}

final class EmailChangeSubmitted extends ProfileEvent {
  const EmailChangeSubmitted({required this.password, required this.newEmail});

  final String password;
  final String newEmail;

  @override
  List<Object?> get props => [password, newEmail];
}

enum ProfileOutcomeKind {
  emailChangeRequested,
  emailChangeFailed,
  profileUpdated,
  passwordChanged,
  wrongPassword,
  passwordFailed,
}

/// What just happened; [id] makes each one distinct.
class ProfileOutcome extends Equatable {
  const ProfileOutcome(this.kind, this.id, [this.user, this.failure]);

  final ProfileOutcomeKind kind;
  final int id;

  /// Why the password change failed, for [ProfileOutcomeKind.passwordFailed].
  final AuthFailure? failure;

  /// The updated user, for [ProfileOutcomeKind.profileUpdated].
  final AppUser? user;

  @override
  List<Object?> get props => [kind, id, user, failure];
}

class ProfileState extends Equatable {
  const ProfileState({this.busy = false, this.outcome});

  final bool busy;
  final ProfileOutcome? outcome;

  @override
  List<Object?> get props => [busy, outcome];
}

/// Edit profile and change password for the signed-in user.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UpdateProfile updateProfile,
    required ChangePassword changePassword,
    required RequestEmailChange requestEmailChange,
  }) : _update = updateProfile,
       _changePassword = changePassword,
       _requestEmailChange = requestEmailChange,
       super(const ProfileState()) {
    on<ProfileEdited>(_onEdited);
    on<PasswordChangeSubmitted>(_onPassword);
    on<EmailChangeSubmitted>(_onEmailChange);
  }

  final UpdateProfile _update;
  final ChangePassword _changePassword;
  final RequestEmailChange _requestEmailChange;

  int _id = 0;

  Future<void> _onEdited(ProfileEdited e, Emitter<ProfileState> emit) async {
    emit(const ProfileState(busy: true));
    final user = await _update(
      UpdateProfileParams(userId: e.userId, name: e.name, phone: e.phone),
    );
    emit(
      ProfileState(
        outcome: ProfileOutcome(ProfileOutcomeKind.profileUpdated, ++_id, user),
      ),
    );
  }

  Future<void> _onEmailChange(
    EmailChangeSubmitted e,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState(busy: true));
    try {
      await _requestEmailChange(
        RequestEmailChangeParams(password: e.password, newEmail: e.newEmail),
      );
      emit(
        ProfileState(
          outcome: ProfileOutcome(
            ProfileOutcomeKind.emailChangeRequested,
            ++_id,
          ),
        ),
      );
    } on AuthException catch (err) {
      emit(
        ProfileState(
          outcome: ProfileOutcome(
            ProfileOutcomeKind.emailChangeFailed,
            ++_id,
            null,
            err.failure,
          ),
        ),
      );
    }
  }

  Future<void> _onPassword(
    PasswordChangeSubmitted e,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState(busy: true));
    try {
      await _changePassword(
        ChangePasswordParams(
          userId: e.userId,
          current: e.current,
          next: e.next,
        ),
      );
      emit(
        ProfileState(
          outcome: ProfileOutcome(ProfileOutcomeKind.passwordChanged, ++_id),
        ),
      );
    } on AuthException catch (e) {
      final wrong = e.failure == AuthFailure.wrongCurrentPassword;
      emit(
        ProfileState(
          outcome: ProfileOutcome(
            wrong
                ? ProfileOutcomeKind.wrongPassword
                : ProfileOutcomeKind.passwordFailed,
            ++_id,
            null,
            wrong ? null : e.failure,
          ),
        ),
      );
    }
  }
}
