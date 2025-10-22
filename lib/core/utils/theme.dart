import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.mainBG,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.success,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textSecondary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: "EurostileExtendedBlack",
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: "EurostileExtendedBlack",
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
