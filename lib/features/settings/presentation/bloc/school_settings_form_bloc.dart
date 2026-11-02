import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../location/domain/entities/location_reading.dart';
import '../../../location/domain/usecases/get_address.dart';
import '../../../location/domain/usecases/get_current_location.dart';
import '../../domain/entities/school_settings.dart';
import '../../domain/usecases/save_school_settings.dart';

enum LocationFormError {
  mocked,
  servicesOff,
  denied,
  deniedForever,
  unavailable,
  missing,
}

sealed class SchoolSettingsFormEvent extends Equatable {
  const SchoolSettingsFormEvent();

  @override
  List<Object?> get props => const [];
}

final class LocationRequested extends SchoolSettingsFormEvent {
  const LocationRequested();
}

/// Looks up the address of the captured location.
final class AddressRequested extends SchoolSettingsFormEvent {
  const AddressRequested();
}

final class SettingsSubmitted extends SchoolSettingsFormEvent {
  const SettingsSubmitted({required this.schoolName, required this.radius});

  final String schoolName;
  final int radius;

  @override
  List<Object?> get props => [schoolName, radius];
}

class SchoolSettingsFormState extends Equatable {
  const SchoolSettingsFormState({
    this.latitude,
    this.longitude,
    this.locating = false,
    this.saving = false,
    this.saved = false,
    this.error,
    this.address,
    this.addressLoading = false,
  });

  final double? latitude;
  final double? longitude;
  final bool locating;
  final bool saving;
  final bool saved;
  final LocationFormError? error;

  /// Readable address of the location; null when unknown or not found.
  final String? address;
  final bool addressLoading;

  bool get hasLocation => latitude != null && longitude != null;

  SchoolSettingsFormState copyWith({
    double? latitude,
    double? longitude,
    bool? locating,
    bool? saving,
    bool? saved,
    LocationFormError? error,
    bool clearError = false,
    String? address,
    bool clearAddress = false,
    bool? addressLoading,
  }) => SchoolSettingsFormState(
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    locating: locating ?? this.locating,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
    error: clearError ? null : (error ?? this.error),
    address: clearAddress ? null : (address ?? this.address),
    addressLoading: addressLoading ?? this.addressLoading,
  );

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    locating,
    saving,
    saved,
    error,
    address,
    addressLoading,
  ];
}

/// State of the "School settings" form: captured location and saving.
class SchoolSettingsFormBloc
    extends Bloc<SchoolSettingsFormEvent, SchoolSettingsFormState> {
  SchoolSettingsFormBloc({
    required SchoolSettings initial,
    required GetCurrentLocation getCurrentLocation,
    required GetAddress getAddress,
    required SaveSchoolSettings saveSchoolSettings,
  }) : _getLocation = getCurrentLocation,
       _getAddress = getAddress,
       _save = saveSchoolSettings,
       super(
         SchoolSettingsFormState(
           latitude: initial.latitude,
           longitude: initial.longitude,
         ),
       ) {
    on<LocationRequested>(_onLocation);
    on<AddressRequested>(_onAddress);
    on<SettingsSubmitted>(_onSubmitted);
  }

  final GetCurrentLocation _getLocation;
  final GetAddress _getAddress;
  final SaveSchoolSettings _save;

  Future<void> _onLocation(
    LocationRequested e,
    Emitter<SchoolSettingsFormState> emit,
  ) async {
    emit(state.copyWith(locating: true, clearError: true));
    try {
      final reading = await _getLocation(const NoParams());
      if (reading.isMocked) {
        emit(state.copyWith(locating: false, error: LocationFormError.mocked));
      } else {
        emit(
          state.copyWith(
            locating: false,
            latitude: reading.latitude,
            longitude: reading.longitude,
            clearAddress: true,
          ),
        );
        add(const AddressRequested());
      }
    } on LocationException catch (ex) {
      emit(
        state.copyWith(
          locating: false,
          error: switch (ex.problem) {
            LocationProblem.servicesOff => LocationFormError.servicesOff,
            LocationProblem.denied => LocationFormError.denied,
            LocationProblem.deniedForever => LocationFormError.deniedForever,
            LocationProblem.unavailable => LocationFormError.unavailable,
          },
        ),
      );
    }
  }

  Future<void> _onAddress(
    AddressRequested e,
    Emitter<SchoolSettingsFormState> emit,
  ) async {
    if (!state.hasLocation) return;
    emit(state.copyWith(addressLoading: true));
    final address = await _getAddress(
      AddressQuery(latitude: state.latitude!, longitude: state.longitude!),
    );
    emit(
      state.copyWith(
        addressLoading: false,
        address: address,
        clearAddress: address == null,
      ),
    );
  }

  Future<void> _onSubmitted(
    SettingsSubmitted e,
    Emitter<SchoolSettingsFormState> emit,
  ) async {
    if (!state.hasLocation) {
      emit(state.copyWith(error: LocationFormError.missing));
      return;
    }
    emit(state.copyWith(saving: true, clearError: true));
    await _save(
      SaveSchoolSettingsParams(
        schoolName: e.schoolName,
        latitude: state.latitude!,
        longitude: state.longitude!,
        radiusMeters: e.radius,
      ),
    );
    emit(state.copyWith(saving: false, saved: true));
  }
}
