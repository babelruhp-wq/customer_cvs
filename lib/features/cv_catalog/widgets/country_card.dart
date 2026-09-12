import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../models/country_model.dart';

class CountryCard extends StatefulWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _hovered = false;

  String _formatPrice(num value) {
    final number = value.toDouble();

    final text = number == number.roundToDouble()
        ? number.toInt().toString()
        : number.toStringAsFixed(2);

    return '$text ريال';
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;
    final hasCvs = country.cVsCount > 0;

    return MouseRegion(
      cursor: hasCvs
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!hasCvs) return;

        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        if (!_hovered) return;

        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: hasCvs ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0,
            hasCvs && _hovered ? -4 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppRadius.xl,
            ),
            border: Border.all(
              color: hasCvs && _hovered
                  ? AppColors.primary.withValues(
                alpha: .28,
              )
                  : AppColors.border,
            ),
            boxShadow: hasCvs && _hovered
                ? AppShadows.floating
                : AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  24,
                  18,
                  18,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // =====================================
                    // FLAG
                    // =====================================

                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 92,
                        height: 68,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius:
                          BorderRadius.circular(
                            AppRadius.lg,
                          ),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                            AppRadius.sm,
                          ),
                          child:
                          CountryFlag.fromCountryCode(
                            country.flagCode,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // =====================================
                    // COUNTRY NAME
                    // =====================================

                    Text(
                      country.countryName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        color: AppColors.textPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // =====================================
                    // CVS COUNT
                    // =====================================

                    Center(
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: hasCvs
                              ? AppColors.primary.withValues(
                            alpha: .07,
                          )
                              : AppColors.surfaceMuted,
                          borderRadius:
                          BorderRadius.circular(30),
                          border: Border.all(
                            color: hasCvs
                                ? AppColors.primary.withValues(
                              alpha: .12,
                            )
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 15,
                              color: hasCvs
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              '${country.cVsCount} سيرة متوفرة',
                              style: GoogleFonts.cairo(
                                color: hasCvs
                                    ? AppColors.primary
                                    : AppColors
                                    .textSecondary,
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =====================================
                    // AVAILABILITY STATUS
                    // مساحة ثابتة حتى تظل كل الكروت متساوية
                    // =====================================

                    SizedBox(
                      height: 18,
                      child: Center(
                        child: hasCvs
                            ? const SizedBox.shrink()
                            : Text(
                          'في انتظار إضافة سير ذاتية',
                          textAlign:
                          TextAlign.center,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: AppColors
                                .textSecondary,
                            fontSize: 10.5,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =====================================
                    // PRICE
                    // =====================================

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                        AppColors.secondaryFaint,
                        borderRadius:
                        BorderRadius.circular(
                          AppRadius.md,
                        ),
                        border: Border.all(
                          color: AppColors.secondary
                              .withValues(
                            alpha: .16,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors
                                  .secondarySoft,
                              borderRadius:
                              BorderRadius.circular(
                                AppRadius.sm,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.payments_outlined,
                              color:
                              AppColors.secondaryDark,
                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  'سعر الاستقدام',
                                  style: GoogleFonts.cairo(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _formatPrice(
                                    country.price,
                                  ),
                                  style: GoogleFonts.cairo(
                                    color: AppColors
                                        .textPrimary,
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // =====================================
                    // ACTION
                    // =====================================

                    SizedBox(
                      height: 44,
                      child: FilledButton.icon(
                        onPressed:
                        hasCvs ? widget.onTap : null,
                        icon: Icon(
                          hasCvs
                              ? Icons
                              .description_outlined
                              : Icons
                              .hourglass_empty_rounded,
                          size: 18,
                        ),
                        label: Text(
                          hasCvs
                              ? 'عرض السير الذاتية'
                              : 'في انتظار إضافة سير',
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================
              // RIBBON
              // =====================================

              if (country.showRibbon)
                Positioned(
                  top: 21,
                  left: -38,
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: Container(
                      width: 150,
                      height: 31,
                      alignment: Alignment.center,
                      color: const Color(
                        0xFF16A34A,
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          country.ribbon,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}