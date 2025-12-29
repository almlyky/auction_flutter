import 'package:auction/view/screen/favorites.dart';
import 'package:auction/view/screen/home/home.dart';
import 'package:auction/view/screen/notifications.dart';
import 'package:auction/view/screen/settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bottom_app_bar_state.dart';

class BottomAppBarCubit extends Cubit<BottomAppBarState> {
  BottomAppBarCubit() : super(BottomAppBarInitial());

  List screans = [Home(), Notifications(), Favorites(), Settings()];
  final List<NavItem> items = [
    NavItem(Icons.home, 'الرئيسية'),
    NavItem(Icons.notifications, 'الاشعارات'),
    NavItem(Icons.favorite, 'المفضلة'),
    NavItem(Icons.settings, 'الإعدادات '),
  ];
  int selectedIndex = 0;
  void selectIndex(int index) {
    selectedIndex = index;
    emit(SelectIndexState(selectedIndex));
  }

  final List<String> titleAppBar = [
    'الصفحة الرئيسية',
    'الاشعارات',
    'المفضلة',
    'الإعدادات'
  ];
}

class NavItem {
  final IconData icon;
  final String label;
  NavItem(this.icon, this.label);
}
