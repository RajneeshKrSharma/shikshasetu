import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/features/location/domain/entities/location_reading.dart';
import 'package:shiksha_setu/features/location/domain/repository/address_repository.dart';
import 'package:shiksha_setu/features/location/domain/repository/location_repository.dart';
import 'package:shiksha_setu/features/location/domain/usecases/get_address.dart';
import 'package:shiksha_setu/features/location/domain/usecases/get_current_location.dart';
import 'package:shiksha_setu/features/settings/domain/entities/school_settings.dart';
import 'package:shiksha_setu/features/settings/domain/repository/settings_repository.dart';
import 'package:shiksha_setu/features/settings/domain/usecases/save_school_settings.dart';
import 'package:shiksha_setu/features/settings/presentation/bloc/school_settings_form_bloc.dart';

class _Location implements LocationRepository {
  @override
  Future<LocationReading> current() async =>
      const LocationReading(latitude: 28.6, longitude: 77.2, isMocked: false);
}

class _Address implements AddressRepository {
  _Address(this.result);

  final String? result;

  @override
  Future<String?> addressOf(double latitude, double longitude) async => result;
}

class _Settings implements SettingsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  SchoolSettingsFormBloc build(String? address) => SchoolSettingsFormBloc(
    initial: const SchoolSettings(schoolName: 'S'),
    getCurrentLocation: GetCurrentLocation(_Location()),
    getAddress: GetAddress(_Address(address)),
    saveSchoolSettings: SaveSchoolSettings(_Settings()),
  );

  test('capturing the location also looks up its address', () async {
    final bloc = build('Main Road, Delhi');
    bloc.add(const LocationRequested());
    await bloc.stream.firstWhere((s) => s.address != null);
    expect(bloc.state.address, 'Main Road, Delhi');
    expect(bloc.state.addressLoading, isFalse);
    await bloc.close();
  });

  test('no address found leaves it empty, not loading', () async {
    final bloc = build(null);
    bloc.add(const LocationRequested());
    await bloc.stream.firstWhere(
      (s) => s.hasLocation && !s.addressLoading && !s.locating,
    );
    expect(bloc.state.address, isNull);
    await bloc.close();
  });
}
