import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The language the app is shown in.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void select(Locale locale) => emit(locale);
}
