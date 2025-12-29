part of 'bottom_app_bar_cubit.dart';

sealed class BottomAppBarState extends Equatable {
  const BottomAppBarState();

  @override
  List<Object> get props => [];
}

final class BottomAppBarInitial extends BottomAppBarState {}

final class SelectIndexState extends BottomAppBarState {
  final int selectedIndex;
 const SelectIndexState(this.selectedIndex);
 @override
  List<Object> get props => [selectedIndex];
}
