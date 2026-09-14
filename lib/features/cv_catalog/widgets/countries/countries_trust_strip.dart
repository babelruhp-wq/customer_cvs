import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountriesTrustStrip extends StatelessWidget {
  const CountriesTrustStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: const Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 30,
            runSpacing: 22,
            children: [
              _TrustItem(
                icon: Icons.verified_user_outlined,
                title: 'بيانات واضحة',
                subtitle: 'المعلومات الأساسية أمامك',
              ),
              _TrustItem(
                icon: Icons.tune_rounded,
                title: 'اختيار أسهل',
                subtitle: 'فلترة حسب احتياجك',
              ),
              _TrustItem(
                icon: Icons.support_agent_rounded,
                title: 'تواصل مباشر',
                subtitle: 'فريقنا جاهز لخدمتك',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.secondarySoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: .13),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.secondaryDark, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// FOOTER
// ==========================================================
