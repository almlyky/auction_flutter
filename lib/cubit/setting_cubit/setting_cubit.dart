import 'package:auction/core/service/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial()) {
    if (Services.prefs?.getBool("isDark") != null) {
      bool isDark = Services.prefs?.getBool("isDark") ?? false;
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeChanged(themeMode));
    }
  }

  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() async {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await Services.prefs?.setBool("isDark", themeMode == ThemeMode.dark);
    emit(ThemeChanged(themeMode));
  }
  //  void toggleTheme(bool isDark) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   emit(isDark ? ThemeMode.dark : ThemeMode.light);

  //   await prefs.setBool("isDark", isDark);
  // }
}
