import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ==========================================================
/// BABEL AL RIYADH - CENTRAL DESIGN SYSTEM
/// ==========================================================
///
/// كل ألوان وتصميمات المشروع موجودة هنا.
/// أي تغيير في الهوية مستقبلاً يتم من هذا الملف فقط.
/// ==========================================================

class AppColors {
  const AppColors._();

  // ==========================================================
  // BRAND - NAVY
  // ==========================================================

  static const primary = Color(0xFF062A5A);
  static const primaryDark = Color(0xFF041F44);
  static const primaryDeep = Color(0xFF02162F);

  static const primarySoft = Color(0xFFEAF0F7);
  static const primaryFaint = Color(0xFFF5F8FC);

  // ==========================================================
// BABEL LIGHT BRAND BACKGROUNDS
// ==========================================================

  static const heroBackground = Color(0xFFFFFCF6);
  static const heroBackgroundSoft = Color(0xFFF7F9FC);

  static const goldGlow = Color(0xFFFFF1C7);
  static const navyGlow = Color(0xFFEAF0F8);

  static const heroTextDark = Color(0xFF092B5B);
  static const heroTextMuted = Color(0xFF657487);

  // ==========================================================
  // BRAND - GOLD
  // ==========================================================

  static const secondary = Color(0xFFF5A900);
  static const secondaryDark = Color(0xFFD99000);
  static const secondarySoft = Color(0xFFFFF4D9);
  static const secondaryFaint = Color(0xFFFFFAF0);

  // ==========================================================
  // SUCCESS / AVAILABLE
  // ==========================================================

  static const accent = Color(0xFF19A966);
  static const accentDark = Color(0xFF12834F);
  static const accentSoft = Color(0xFFE9F8F0);

  static const success = accent;

  // ==========================================================
  // BACKGROUNDS
  // ==========================================================

  static const canvas = Color(0xFFF6F8FB);

  /// Alias للاستخدام في الصفحات.
  static const background = canvas;

  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF9FAFC);
  static const surfaceStrong = Color(0xFFF0F3F7);

  // ==========================================================
  // BORDERS
  // ==========================================================

  static const border = Color(0xFFE3E8EF);
  static const borderStrong = Color(0xFFD2DAE4);

  // ==========================================================
  // TEXT
  // ==========================================================

  static const textPrimary = Color(0xFF112840);
  static const textSecondary = Color(0xFF66788B);
  static const textMuted = Color(0xFF8A98A8);

  static const textOnPrimary = Color(0xFFFFFFFF);

  static const textOnSecondary = Color(0xFF3B2900);

  static const textOnAccent = Color(0xFFFFFFFF);

  // ==========================================================
  // HERO
  // ==========================================================

  static const heroTextSoft = Color(0xFFD7E1ED);

  // ==========================================================
  // ICONS
  // ==========================================================

  static const iconSoft = Color(0xFF7890A6);

  // ==========================================================
  // SHADOWS
  // ==========================================================

  static const shadow = Color(0x19062A5A);
  static const shadowStrong = Color(0x2A041F44);

  // ==========================================================
  // OVERLAY
  // ==========================================================

  static const overlay = Color(0x6002162F);
  static const overlayStrong = Color(0xA002162F);

  static const transparent = Color(0x00000000);

  // ==========================================================
  // ERROR
  // ==========================================================

  static const error = Color(0xFFC43B4D);
  static const errorSoft = Color(0xFFFFEEF1);
}

// ==========================================================
// RADIUS
// ==========================================================

class AppRadius {
  const AppRadius._();

  static const double xs = 8;
  static const double sm = 11;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 22;
  static const double xxl = 28;

  static const double pill = 999;
}

// ==========================================================
// SPACING
// ==========================================================

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double section = 64;
}

// ==========================================================
// LAYOUT
// ==========================================================

class AppLayout {
  const AppLayout._();

  static const double maxContentWidth = 1320;

  static const double headerHeight = 72;

  static const double desktopBreakpoint = 900;
  static const double tabletBreakpoint = 680;

  static const double heroHeight = 380;
}

// ==========================================================
// SHADOWS
// ==========================================================

class AppShadows {
  const AppShadows._();

  static const card = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: AppColors.shadowStrong,
      blurRadius: 36,
      offset: Offset(0, 15),
    ),
  ];
}

// ==========================================================
// GRADIENTS
// ==========================================================

class AppGradients {
  const AppGradients._();
  static const heroLight = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.heroBackground,
      AppColors.surface,
      AppColors.heroBackgroundSoft,
    ],
  );
  /// Hero الرئيسي.
  static const hero = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );

  /// Hero أغمق - مناسب للفوتر والخلفيات القوية.
  static const heroDeep = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.primaryDark,
      AppColors.primaryDeep,
    ],
  );

  /// Background خفيف للكروت.
  static const softPanel = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.primarySoft,
      AppColors.surface,
    ],
  );

  /// Placeholder.
  static const photoPlaceholder = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.primarySoft,
      AppColors.primaryFaint,
    ],
  );

  /// لمسات ذهبية خفيفة.
  static const goldSoft = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      AppColors.secondarySoft,
      AppColors.surface,
    ],
  );
}

// ==========================================================
// DECORATIONS
// ==========================================================

class AppDecorations {
  const AppDecorations._();

  static BoxDecoration get sectionCard {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(
        AppRadius.xl,
      ),
      border: Border.all(
        color: AppColors.border,
      ),
      boxShadow: AppShadows.card,
    );
  }

  static BoxDecoration get softCard {
    return BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(
        AppRadius.lg,
      ),
      border: Border.all(
        color: AppColors.border,
      ),
    );
  }

  static BoxDecoration get primaryGlass {
    return BoxDecoration(
      color: AppColors.surface.withValues(
        alpha: .10,
      ),
      borderRadius: BorderRadius.circular(
        AppRadius.lg,
      ),
      border: Border.all(
        color: AppColors.surface.withValues(
          alpha: .18,
        ),
      ),
    );
  }

  static BoxDecoration get goldCard {
    return BoxDecoration(
      color: AppColors.secondaryFaint,
      borderRadius: BorderRadius.circular(
        AppRadius.lg,
      ),
      border: Border.all(
        color: AppColors.secondary.withValues(
          alpha: .22,
        ),
      ),
    );
  }
}

// ==========================================================
// BUTTON STYLES
// ==========================================================

class AppButtonStyles {
  const AppButtonStyles._();

  /// حالات مثل:
  /// متاحة / تواصل / نجاح.
  static final success = FilledButton.styleFrom(
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.textOnAccent,
    disabledBackgroundColor: AppColors.borderStrong,
    disabledForegroundColor: AppColors.textMuted,
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
    ),
  );

  /// زر ذهبي خاص.
  static final gold = FilledButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.textOnSecondary,
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w900,
    ),
  );

  static final onDarkOutlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.textOnPrimary,
    side: BorderSide(
      color: AppColors.surface.withValues(
        alpha: .38,
      ),
    ),
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
    ),
  );

  static final compact = FilledButton.styleFrom(
    minimumSize: const Size(0, 40),
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
    ),
  );

  static final paginationSelected = FilledButton.styleFrom(
    disabledBackgroundColor: AppColors.primary,
    disabledForegroundColor: AppColors.textOnPrimary,
    padding: EdgeInsets.zero,
    minimumSize: const Size(40, 40),
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
    ),
  );

  static final paginationNormal = OutlinedButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: const Size(40, 40),
    textStyle: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
    ),
  );
}

// ==========================================================
// APP THEME
// ==========================================================

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final cairo = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ======================================================
      // CAIRO GLOBAL
      // ======================================================

      fontFamily: GoogleFonts.cairo().fontFamily,

      textTheme: cairo.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      primaryTextTheme: cairo.apply(
        bodyColor: AppColors.textOnPrimary,
        displayColor: AppColors.textOnPrimary,
      ),

      // ======================================================
      // BACKGROUND
      // ======================================================

      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,

      // ======================================================
      // COLOR SCHEME
      // ======================================================

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,

        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,

        error: AppColors.error,
        onError: AppColors.textOnPrimary,

        outline: AppColors.border,
      ),

      // ======================================================
      // ICON
      // ======================================================

      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
      ),

      // ======================================================
      // DIVIDER
      // ======================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ======================================================
      // CARDS
      // ======================================================

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      // ======================================================
      // FILLED BUTTON
      // ======================================================

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,

          disabledBackgroundColor: AppColors.borderStrong,
          disabledForegroundColor: AppColors.textMuted,

          minimumSize: const Size(0, 48),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.sm,
            ),
          ),

          textStyle: GoogleFonts.cairo(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ======================================================
      // OUTLINED BUTTON
      // ======================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,

          minimumSize: const Size(0, 48),

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),

          side: const BorderSide(
            color: AppColors.borderStrong,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.sm,
            ),
          ),

          textStyle: GoogleFonts.cairo(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ======================================================
      // TEXT BUTTON
      // ======================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,

          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.w800,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.sm,
            ),
          ),
        ),
      ),

      // ======================================================
      // ICON BUTTON
      // ======================================================

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.sm,
            ),
          ),
        ),
      ),

      // ======================================================
      // INPUTS
      // ======================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,

        hintStyle: GoogleFonts.cairo(
          color: AppColors.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),

        labelStyle: GoogleFonts.cairo(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),

        floatingLabelStyle: GoogleFonts.cairo(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),

        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.sm,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.sm,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.sm,
          ),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.sm,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.sm,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ======================================================
      // DROPDOWN
      // ======================================================

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.sm,
            ),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
      ),

      // ======================================================
      // CHIP
      // ======================================================

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySoft,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surfaceStrong,

        side: const BorderSide(
          color: AppColors.border,
        ),

        labelStyle: GoogleFonts.cairo(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),

        secondaryLabelStyle: GoogleFonts.cairo(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w700,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.pill,
          ),
        ),
      ),

      // ======================================================
      // DIALOG
      // ======================================================

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,

        titleTextStyle: GoogleFonts.cairo(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),

        contentTextStyle: GoogleFonts.cairo(
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.6,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
        ),
      ),

      // ======================================================
      // PROGRESS
      // ======================================================

      progressIndicatorTheme:
      const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // ======================================================
      // TOOLTIP
      // ======================================================

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(
            AppRadius.xs,
          ),
        ),

        textStyle: GoogleFonts.cairo(
          color: AppColors.textOnPrimary,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}