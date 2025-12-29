import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:flutter/material.dart';

class BaseStateBuilder<T> extends StatelessWidget {
  final BaseState<T> state;

  final Widget Function(T data) onLoaded;

  final Widget? onInitial;
  final Widget? onLoading;

  /// widget يظهر عندما لا يوجد بيانات، استخدمه لو تريد تخصيص واجهة الـ Empty
  final Widget? onEmpty;

  /// دالة إعادة المحاولة
  final void Function()? onRetry;

  /// تخصيص الخطأ
  final Widget Function(String message, void Function()? retry)? onError;

  const BaseStateBuilder({
    super.key,
    required this.state,
    required this.onLoaded,
    this.onInitial,
    this.onLoading,
    this.onEmpty,
    this.onRetry,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================
    // 1. LOADING STATE
    // ==========================
    if (state is BaseLoading) {
      return onLoading ?? const Center(child: CircularProgressIndicator());
    }

    // ==========================
    // 2. ERROR STATE (with Reload)
    // ==========================
    if (state is BaseError) {
      final errorMessage = (state as BaseError).message;

      // If user provided custom error widget
      if (onError != null) {
        return onError!(errorMessage, onRetry);
      }

      // Default error UI with Retry button
      return Center(
        child: IconButton(
          onPressed: onRetry,
          icon: const Icon(
            Icons.refresh,
            size: 35,
          ),
        ),
      );
    }

    // ==========================
    // 3. LOADED STATE
    // ==========================
    if (state is BaseSuccess<T>) {
      return onLoaded((state as BaseSuccess<T>).data as T);
    }

    // ==========================
    // 4. EMPTY STATE (with reload icon)
    // ==========================
    if (state is BaseEmpty) {
      if (onEmpty != null) return onEmpty!;

      return Center(
        child: GestureDetector(
          onTap: onRetry,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.refresh, size: 40),
              SizedBox(height: 8),
              Text("لا توجد بيانات - اضغط للتحديث"),
            ],
          ),
        ),
      );
    }

    // ==========================
    // 5. INITIAL STATE
    // ==========================
    return onInitial ??
        Center(
          child: IconButton(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        );
  }
}
