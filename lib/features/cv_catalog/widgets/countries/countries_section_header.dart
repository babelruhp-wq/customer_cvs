import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountriesSectionHeader extends StatelessWidget {
  const CountriesSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'السير الذاتية المتاحة',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppColors.secondaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'اختر الدولة',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontSize: 29,
                  height: 1.35,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'اختر الدولة لعرض السير الذاتية المتاحة.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// HELP
// ==========================================================
