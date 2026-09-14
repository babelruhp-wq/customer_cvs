import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountryBanner extends StatelessWidget {
  final String isoCode;
  final String name;
  final int totalCount;

  const CountryBanner({
    required this.isoCode,
    required this.name,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:
      const BoxDecoration(
        gradient: AppGradients.hero,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth:
            AppLayout.maxContentWidth,
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final compact =
                    constraints.maxWidth <
                        540;

                final flag = Container(
                  width:
                  compact ? 76 : 92,
                  height:
                  compact ? 58 : 70,
                  padding:
                  const EdgeInsets.all(
                    7,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.surface,
                    borderRadius:
                    BorderRadius.circular(
                      AppRadius.lg,
                    ),
                    boxShadow:
                    AppShadows.card,
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      AppRadius.sm,
                    ),
                    child:
                    CountryFlag.fromCountryCode(
                      isoCode,
                    ),
                  ),
                );

                final content = Column(
                  crossAxisAlignment:
                  compact
                      ? CrossAxisAlignment
                      .center
                      : CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      name,
                      textAlign: compact
                          ? TextAlign.center
                          : TextAlign.start,
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .textOnPrimary,
                        fontSize:
                        compact
                            ? 28
                            : 32,
                        fontWeight:
                        FontWeight
                            .w900,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration:
                      BoxDecoration(
                        color: AppColors
                            .surface
                            .withValues(
                          alpha: .09,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          AppRadius.pill,
                        ),
                        border:
                        Border.all(
                          color: AppColors
                              .surface
                              .withValues(
                            alpha: .12,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          const Icon(
                            Icons
                                .description_outlined,
                            color: AppColors
                                .secondary,
                            size: 15,
                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          Text(
                            '$totalCount نتيجة متاحة',
                            style:
                            GoogleFonts
                                .cairo(
                              color: AppColors
                                  .heroTextSoft,
                              fontSize: 12,
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    children: [
                      flag,
                      const SizedBox(
                        height: 14,
                      ),
                      content,
                    ],
                  );
                }

                return Row(
                  children: [
                    flag,
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: content,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// PASSPORT SEARCH
// ==========================================================
