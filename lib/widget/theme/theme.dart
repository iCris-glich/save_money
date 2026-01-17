import 'package:flutter/material.dart';
import 'package:save_money/widget/theme/app_colors.dart';

class AppTheme {
  static ThemeData get ligth => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      // ignore: deprecated_member_use
      background: AppColors.background,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textPrimary, fontFamily: 'PTSans'),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'PTSans',
      ),
    ),

    useMaterial3: true,
  );
}
