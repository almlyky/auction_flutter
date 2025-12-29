import 'package:auction/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static InputDecorationTheme _inputDecorationFor(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final fill = isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03);
    final borderColor = isDark ? Colors.white24 : Colors.black26;
    final hintColor = isDark ? AppColors.darkText.withOpacity(0.65) : AppColors.lightText.withOpacity(0.65);

    OutlineInputBorder outline(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1),
        );

    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: outline(borderColor),
      disabledBorder: outline(borderColor.withOpacity(0.6)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: outline(Colors.red.shade700),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      labelStyle: TextStyle(color: isDark ? AppColors.darkText : AppColors.primary, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIconColor: isDark ? AppColors.darkText : AppColors.secondary,
      suffixIconColor: isDark ? AppColors.darkText : AppColors.secondary,
    );
  }

  static final inputDecorationLight = _inputDecorationFor(Brightness.light);
  static final inputDecorationDark = _inputDecorationFor(Brightness.dark);
  static final lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    primaryColor: AppColors.primary,
    // primaryColorLight: AppColors.lightBackground,
    scaffoldBackgroundColor: AppColors.lightBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.primary,
      ),
    ),
    colorScheme: ColorScheme.light(
      shadow: const Color.fromARGB(70, 0, 0, 0),
      surface: AppColors.lightBackground,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.primary,
    ),
    inputDecorationTheme: inputDecorationLight,
    // InputDecorationTheme(
    //     border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(8),
    //         borderSide: BorderSide(color: Colors.black))),
    //  InputDecoration(
    //     border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(8),
    //         borderSide: BorderSide(color: Colors.black))),

    textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightText, fontSize: 18),
        bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 16),
        bodySmall: TextStyle(color: AppColors.lightText, fontSize: 14),
        headlineLarge: TextStyle(color: AppColors.lightText, fontSize: 16),
        headlineMedium: TextStyle(color: AppColors.lightText, fontSize: 14)),
    // iconTheme: IconThemeData(color: AppColors.secondary)
  );

  static final darkTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.dark,
    fontFamily: 'Cairo',
    primaryColor: AppColors.primary,
    // primaryColorDark: AppColors.darkBackground,
    scaffoldBackgroundColor: AppColors.darkBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.primary,
      ),
    ),

    colorScheme: ColorScheme.dark(
      shadow: Colors.white,
      surface: AppColors.darkBackground,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkText,
    ),
    inputDecorationTheme: inputDecorationDark,
    // textSelectionTheme: textSelectionDark,
    // InputDecorationTheme(
    //   focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(8),
    //       borderSide: BorderSide(color: Colors.white)),
    //     border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(8),
    //         borderSide: BorderSide(color: Colors.white))
            
    //         ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14),
    ),
  );
}
