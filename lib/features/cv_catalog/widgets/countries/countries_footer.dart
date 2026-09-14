import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountriesFooter extends StatelessWidget {
  const CountriesFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF102E5E), Color(0xFF071A36)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 40,
                runSpacing: 22,
                children: [
                  SizedBox(
                    width: 420,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بابل الرياض للاستقدام',
                          style: GoogleFonts.cairo(
                            color: AppColors.textOnPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'نسهّل عليك استعراض السير الذاتية واختيار المناسب لك.',
                          style: GoogleFonts.cairo(
                            color: AppColors.heroTextSoft,
                            fontSize: 12.5,
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 270,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تواصل معنا',
                          style: GoogleFonts.cairo(
                            color: AppColors.textOnPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const _FooterContact(
                          icon: Icons.call_rounded,
                          text: '920005077',
                          ltr: true,
                        ),

                        const _FooterContact(
                          icon: Icons.location_on_outlined,
                          text: 'الرياض - المملكة العربية السعودية',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Divider(color: AppColors.surface.withValues(alpha: .12)),

              const SizedBox(height: 15),

              Text(
                '© بابل الرياض للاستقدام - جميع الحقوق محفوظة',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppColors.heroTextSoft,
                  fontSize: 11,
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
// FOOTER CONTACT
// ==========================================================

class _FooterContact extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool ltr;

  const _FooterContact({
    required this.icon,
    required this.text,
    this.ltr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 16),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
              textAlign: ltr ? TextAlign.right : TextAlign.start,
              style: GoogleFonts.cairo(
                color: AppColors.heroTextSoft,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// ERROR
// ==========================================================
