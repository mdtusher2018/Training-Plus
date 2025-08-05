import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';

ThemeData appTheme(){
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
          background: AppColors.mainBG,
          onBackground: AppColors.textPrimary,
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
          fillColor: MaterialStateProperty.all(AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );
}