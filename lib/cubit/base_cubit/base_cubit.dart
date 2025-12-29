import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'base_state.dart';

class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(BaseInitial());
  Future<void> load(Future<T> Function() loader) async {
    try {
      emit(BaseLoading());
      final result = await loader();
      if (result == null ||
          (result is List && (result as List).isEmpty) ||
          (result is Map && (result as Map).isEmpty)) {
        emit(BaseEmpty());
        return;
      }
      emit(BaseSuccess(data: result));
    } catch (e) {
      emit(BaseError(e.toString()));
    }
  }

  addData(Future<T> Function() adder) async {
    try {
      emit(BaseLoading());
      final result = await adder();
      emit(BaseSuccess(data: result));
    } catch (e) {
      emit(BaseError(e.toString()));
    }
  }
  

  deleteData(Future<T> Function() deleter) async {
    try {
      emit(BaseLoading());
      final result = await deleter();
      emit(BaseSuccess(data: result));
    } catch (e) {
      emit(BaseError(e.toString()));
    }
  }
}
