import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palestra/core/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  // ---------------------------------------------------------------------------
  // Dark theme — primary, matches the original PWA
  // ---------------------------------------------------------------------------

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      // Primary — orange
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimary,
      primaryContainer: Color(0xFF3A1F10), // deep orange-tinted dark
      onPrimaryContainer: AppColors.primaryLight,
      // Secondary — teal
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundBase,
      secondaryContainer: Color(0xFF003D30),
      onSecondaryContainer: AppColors.secondary,
      // Tertiary — accent yellow
      tertiary: AppColors.accent,
      onTertiary: AppColors.backgroundBase,
      tertiaryContainer: Color(0xFF3A3000),
      onTertiaryContainer: AppColors.accent,
      // Error
      error: AppColors.danger,
      onError: AppColors.textPrimary,
      errorContainer: Color(0xFF3A0A0A),
      onErrorContainer: Color(0xFFFF8A8A),
      // Surfaces
      surface: AppColors.backgroundCard,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.backgroundCardHover,
      onSurfaceVariant: AppColors.textSecondary,
      // Outline
      outline: AppColors.border,
      outlineVariant: AppColors.borderLight,
      // Inverse
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.backgroundBase,
      inversePrimary: AppColors.primaryDark,
      // Scrim / shadow
      scrim: AppColors.backgroundDeepest,
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundBase,

      // -----------------------------------------------------------------------
      // App bar
      // -----------------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundBase,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.backgroundBase,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.textSecondary),
        actionsIconTheme: IconThemeData(color: AppColors.textSecondary),
      ),

      // -----------------------------------------------------------------------
      // Cards
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // -----------------------------------------------------------------------
      // Filled button (primary CTA)
      // -----------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.backgroundCardHover,
          disabledForegroundColor: AppColors.textMuted,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Elevated button
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Outlined button
      // -----------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Text button
      // -----------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // -----------------------------------------------------------------------
      // Input fields
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
      ),

      // -----------------------------------------------------------------------
      // Navigation bar — pill-shaped floating island look
      // -----------------------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        elevation: 8,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 64,
      ),

      // -----------------------------------------------------------------------
      // Divider
      // -----------------------------------------------------------------------
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: 1,
      ),

      // -----------------------------------------------------------------------
      // Chip
      // -----------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundCardHover,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),

      // -----------------------------------------------------------------------
      // SnackBar
      // -----------------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundCardHover,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: AppColors.primary,
      ),

      // -----------------------------------------------------------------------
      // Dialog
      // -----------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // -----------------------------------------------------------------------
      // List tile
      // -----------------------------------------------------------------------
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textSecondary,
        tileColor: Colors.transparent,
      ),

      // -----------------------------------------------------------------------
      // Switch
      // -----------------------------------------------------------------------
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.3);
          }
          return AppColors.backgroundCardHover;
        }),
      ),

      // -----------------------------------------------------------------------
      // Icon
      // -----------------------------------------------------------------------
      iconTheme: const IconThemeData(color: AppColors.textSecondary),

      // -----------------------------------------------------------------------
      // Progress indicator
      // -----------------------------------------------------------------------
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // -----------------------------------------------------------------------
      // Segmented button
      // -----------------------------------------------------------------------
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.backgroundInput,
          foregroundColor: AppColors.textSecondary,
          selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
          selectedForegroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Text theme — weights matching PWA Inter-like feel
      // -----------------------------------------------------------------------
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        bodySmall: TextStyle(color: AppColors.textMuted),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(color: AppColors.textSecondary),
        labelSmall: TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Light theme — minimal, not the primary use-case
  // ---------------------------------------------------------------------------

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
