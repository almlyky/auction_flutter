part of 'counter_cubit.dart';

sealed class CounterState extends Equatable {
  const CounterState(this.counter, this.counterA);
  final int counter;
  final int counterA;

  @override
  List<Object> get props => [counter,counterA];
}

final class CounterInitial extends CounterState {
 const CounterInitial(super.counter, super.counterA);
}

class EncrementCounterstate extends CounterState {
  const EncrementCounterstate(super.counter, super.counterA);
}

class DecrementCounterstate extends CounterState {
  const DecrementCounterstate(super.counter, super.counterA);
}
