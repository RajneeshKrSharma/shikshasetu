import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Which place along the bottom bar is open, and which have been opened.
class ShellNavState extends Equatable {
  const ShellNavState({this.index = 0, this.visited = const {0}});

  final int index;

  /// A place is built the first time it is opened, then kept.
  final Set<int> visited;

  @override
  List<Object?> get props => [index, visited];
}

class ShellNavCubit extends Cubit<ShellNavState> {
  ShellNavCubit() : super(const ShellNavState());

  void select(int index) =>
      emit(ShellNavState(index: index, visited: {...state.visited, index}));
}
