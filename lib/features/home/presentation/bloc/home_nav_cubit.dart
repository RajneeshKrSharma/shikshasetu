import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavState extends Equatable {
  const HomeNavState({this.tabIndex = 0});

  /// Selected bottom-navigation tab.
  final int tabIndex;

  @override
  List<Object?> get props => [tabIndex];
}

class HomeNavCubit extends Cubit<HomeNavState> {
  HomeNavCubit() : super(const HomeNavState());

  void selectTab(int index) => emit(HomeNavState(tabIndex: index));
}
