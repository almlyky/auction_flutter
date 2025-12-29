import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitial(0,0));
  void increment() {
    emit(EncrementCounterstate(state.counter + 1,state.counterA));
  }
  void incrementA() {
    emit(EncrementCounterstate(state.counter,state.counterA + 1));
  }

  void decrement() {
    emit(DecrementCounterstate(state.counter - 1,state.counterA));
  }
    void decrementA() {
    emit(DecrementCounterstate(state.counter,state.counterA - 1));
  }
}
