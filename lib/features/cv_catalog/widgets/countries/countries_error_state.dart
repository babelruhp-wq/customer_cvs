import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountriesErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const CountriesErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 58,
              color: AppColors.textMuted,
            ),

            const SizedBox(height: 14),

            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'إعادة المحاولة',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
