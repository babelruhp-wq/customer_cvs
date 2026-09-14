import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';

class CvEmptyState extends StatelessWidget {
  final bool hasPassportSearch;

  const CvEmptyState({
    required this.hasPassportSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:
        const BoxConstraints(
          maxWidth: 430,
        ),
        margin:
        const EdgeInsets.all(
          20,
        ),
        padding:
        const EdgeInsets.all(
          28,
        ),
        decoration:
        AppDecorations.sectionCard,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration:
              BoxDecoration(
                color: AppColors
                    .primarySoft,
                borderRadius:
                BorderRadius.circular(
                  AppRadius.lg,
                ),
              ),
              alignment:
              Alignment.center,
              child: const Icon(
                Icons.search_off_rounded,
                size: 31,
                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              hasPassportSearch
                  ? 'لا توجد سيرة بهذا الرقم'
                  : 'لا توجد سير مطابقة',
              style: GoogleFonts.cairo(
                color:
                AppColors.textPrimary,
                fontWeight:
                FontWeight.w900,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              hasPassportSearch
                  ? 'تأكد من رقم الجواز أو جرّب تغيير الفلاتر.'
                  : 'جرّب تغيير الديانة أو الخبرة لعرض نتائج أخرى.',
              textAlign:
              TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors
                    .textSecondary,
                fontSize: 12.5,
                height: 1.7,
                fontWeight:
                FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            OutlinedButton.icon(
              onPressed: context
                  .read<CvCatalogCubit>()
                  .resetFilters,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                'إعادة ضبط الفلاتر',
                style:
                GoogleFonts.cairo(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ERROR
// ==========================================================

class CvErrorState extends StatelessWidget {
  final String message;

  const CvErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:
        const BoxConstraints(
          maxWidth: 420,
        ),
        margin:
        const EdgeInsets.all(
          20,
        ),
        padding:
        const EdgeInsets.all(
          28,
        ),
        decoration:
        AppDecorations.sectionCard,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .error_outline_rounded,
              size: 52,
              color:
              AppColors.textMuted,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,
              textAlign:
              TextAlign.center,
              style:
              GoogleFonts.cairo(
                color:
                AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight:
                FontWeight.w600,
                height: 1.6,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            FilledButton.icon(
              onPressed: () => context
                  .read<
                  CvCatalogCubit>()
                  .loadCvs(
                refresh: true,
              ),
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                'إعادة المحاولة',
                style:
                GoogleFonts.cairo(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// NO COUNTRY
// ==========================================================

class NoCountrySelected
    extends StatelessWidget {
  final VoidCallback onBack;

  const NoCountrySelected({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          const Icon(
            Icons.public_off_rounded,
            size: 48,
            color:
            AppColors.textMuted,
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            'لم يتم اختيار دولة',
            style:
            GoogleFonts.cairo(
              color:
              AppColors.textPrimary,
              fontSize: 15,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(
              Icons
                  .arrow_forward_rounded,
            ),
            label: Text(
              'رجوع',
              style:
              GoogleFonts.cairo(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// UPPERCASE FORMATTER
// ==========================================================
