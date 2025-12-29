part of 'base_cubit.dart';

class BaseState<T> extends Equatable {
  const BaseState();
  T? get data {
    if (this is BaseSuccess<T>) {
      return (this as BaseSuccess<T>).data;
    }
    return null;
  }

  @override
  List<Object> get props => [];
}

final class BaseInitial<T> extends BaseState<T> {}

final class BaseLoading<T> extends BaseState<T> {}

final class BaseEmpty<T> extends BaseState<T> {}

final class BaseSuccess<T> extends BaseState<T> {
  final T? data;
  const BaseSuccess({this.data});
  @override
  List<Object> get props => [data ?? []];
}

final class BaseError<T> extends BaseState<T> {
  final String message;

  const BaseError(this.message);

  @override
  List<Object> get props => [message];
}
