import 'dart:convert';

import 'package:auction/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {

  static SharedPreferences? prefs;
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
  static  saveToken(String token)async {
    await prefs?.setString('access_token', token);
  }
  static  saveUser(UserModel user)async {
    await prefs?.setString('user', jsonEncode(user.toJson()));
  }
  //  void toggleTheme(bool isDark) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   emit(isDark ? ThemeMode.dark : ThemeMode.light);

  //   await prefs.setBool("isDark", isDark);
  // }

  static String? get accessToken {
    return prefs?.getString('access_token');
  }
  static UserModel? get user {
    String? userString = prefs?.getString('user');
    if (userString != null) {
      Map<String, dynamic> userMap = jsonDecode(userString);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

}