import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/country_model.dart';

class CountryCard extends StatefulWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  State<CountryCard> createState() =>
      _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _hovered = false;

  String _formatPrice(num value) {
    final number = value.toDouble();

    final text =
    number == number.roundToDouble()
        ? number.toInt().toString()
        : number.toStringAsFixed(2);

    return '$text ريال';
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;

    final hasCvs =
        country.cVsCount > 0;

    return MouseRegion(
      cursor: hasCvs
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!hasCvs) {
          return;
        }

        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        if (!_hovered) {
          return;
        }

        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        onTap:
        hasCvs ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOut,
          transform:
          Matrix4.translationValues(
            0,
            hasCvs && _hovered
                ? -6
                : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.circular(
              24,
            ),
            border: Border.all(
              width:
              _hovered && hasCvs
                  ? 1.6
                  : 1,
              color:
              _hovered && hasCvs
                  ? AppColors.primary
                  .withValues(
                alpha: .40,
              )
                  : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(
                  alpha: _hovered
                      ? .13
                      : .075,
                ),
                blurRadius:
                _hovered ? 28 : 20,
                offset: Offset(
                  0,
                  _hovered ? 12 : 8,
                ),
              ),
            ],
          ),
          clipBehavior:
          Clip.antiAlias,
          child: Stack(
            children: [
              // ============================================
              // MAIN CONTENT
              // ============================================

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  22,
                  27,
                  22,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
                  children: [
                    // ======================================
                    // FLAG
                    // ======================================

                    Align(
                      alignment:
                      Alignment.center,
                      child: AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 180,
                        ),
                        width:
                        _hovered && hasCvs
                            ? 112
                            : 108,
                        height:
                        _hovered && hasCvs
                            ? 82
                            : 78,
                        padding:
                        const EdgeInsets.all(
                          7,
                        ),
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .surfaceMuted,
                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                          border:
                          Border.all(
                            color: AppColors
                                .border,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha: .045,
                              ),
                              blurRadius: 12,
                              offset:
                              const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius
                              .circular(
                            11,
                          ),
                          child: CountryFlag
                              .fromCountryCode(
                            country.flagCode,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ======================================
                    // COUNTRY NAME
                    // ======================================

                    Text(
                      country.countryName,
                      textAlign:
                      TextAlign.center,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .textPrimary,
                        fontSize: 24,
                        height: 1.35,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                      height: 11,
                    ),

                    // ======================================
                    // CVS COUNT
                    // ======================================

                    Center(
                      child: Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration:
                        BoxDecoration(
                          color: hasCvs
                              ? AppColors
                              .primary
                              .withValues(
                            alpha: .075,
                          )
                              : AppColors
                              .surfaceMuted,
                          borderRadius:
                          BorderRadius
                              .circular(
                            30,
                          ),
                          border:
                          Border.all(
                            color: hasCvs
                                ? AppColors
                                .primary
                                .withValues(
                              alpha: .15,
                            )
                                : AppColors
                                .border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          children: [
                            Icon(
                              Icons
                                  .description_outlined,
                              size: 17,
                              color: hasCvs
                                  ? AppColors
                                  .primary
                                  : AppColors
                                  .textSecondary,
                            ),

                            const SizedBox(
                              width: 7,
                            ),

                            Text(
                              '${country.cVsCount} سيرة متوفرة',
                              style:
                              GoogleFonts
                                  .cairo(
                                color: hasCvs
                                    ? AppColors
                                    .primary
                                    : AppColors
                                    .textSecondary,
                                fontSize: 12.5,
                                fontWeight:
                                FontWeight
                                    .w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height:
                      hasCvs ? 12 : 7,
                    ),

                    // ======================================
                    // EMPTY TEXT
                    // ======================================

                    SizedBox(
                      height: 19,
                      child: hasCvs
                          ? const SizedBox
                          .shrink()
                          : Center(
                        child: Text(
                          'في انتظار توفر سير ذاتية',
                          textAlign:
                          TextAlign
                              .center,
                          style:
                          GoogleFonts
                              .cairo(
                            color: AppColors
                                .textSecondary,
                            fontSize:
                            11.5,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ======================================
                    // PRICE
                    // ======================================

                    Container(
                      padding:
                      const EdgeInsets
                          .fromLTRB(
                        14,
                        12,
                        14,
                        12,
                      ),
                      decoration:
                      BoxDecoration(
                        color: AppColors
                            .secondaryFaint,
                        borderRadius:
                        BorderRadius
                            .circular(
                          15,
                        ),
                        border:
                        Border.all(
                          color: AppColors
                              .secondary
                              .withValues(
                            alpha: .25,
                          ),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration:
                            BoxDecoration(
                              color: AppColors
                                  .secondarySoft,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                            alignment:
                            Alignment
                                .center,
                            child:
                            const Icon(
                              Icons
                                  .payments_outlined,
                              color: AppColors
                                  .secondaryDark,
                              size: 21,
                            ),
                          ),

                          const SizedBox(
                            width: 11,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  'سعر الاستقدام',
                                  style:
                                  GoogleFonts
                                      .cairo(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize:
                                    11,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),

                                const SizedBox(
                                  height: 1,
                                ),

                                Text(
                                  _formatPrice(
                                    country.price,
                                  ),
                                  textDirection:
                                  TextDirection
                                      .rtl,
                                  style:
                                  GoogleFonts
                                      .cairo(
                                    color: AppColors
                                        .primary,
                                    fontSize:
                                    19,
                                    height: 1.35,
                                    fontWeight:
                                    FontWeight
                                        .w900,
                                  ),
                                ),

                                const SizedBox(
                                  height: 3,
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .verified_outlined,
                                      size: 13,
                                      color: AppColors
                                          .secondaryDark,
                                    ),

                                    const SizedBox(
                                      width: 4,
                                    ),

                                    Expanded(
                                      child:
                                      Text(
                                        'شامل ضريبة القيمة المضافة',
                                        maxLines:
                                        1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style:
                                        GoogleFonts
                                            .cairo(
                                          color: AppColors
                                              .secondaryDark,
                                          fontSize:
                                          10.5,
                                          fontWeight:
                                          FontWeight
                                              .w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ======================================
                    // ACTION
                    // ======================================

                    SizedBox(
                      height: 50,
                      child:
                      FilledButton.icon(
                        onPressed: hasCvs
                            ? widget.onTap
                            : null,
                        icon: Icon(
                          hasCvs
                              ? Icons
                              .description_outlined
                              : Icons
                              .hourglass_empty_rounded,
                          size: 20,
                        ),
                        label: Text(
                          hasCvs
                              ? 'عرض السير الذاتية'
                              : 'في انتظار توفر سير',
                          style:
                          GoogleFonts
                              .cairo(
                            fontSize: 13.5,
                            fontWeight:
                            FontWeight
                                .w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ============================================
              // RIBBON
              // ============================================

              if (country.showRibbon)
                Positioned(
                  top: 23,
                  left: -39,
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: Container(
                      width: 160,
                      height: 34,
                      alignment:
                      Alignment.center,
                      color: const Color(
                        0xFF16A34A,
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          country.ribbon,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          textAlign:
                          TextAlign
                              .center,
                          style:
                          GoogleFonts
                              .cairo(
                            color:
                            Colors.white,
                            fontSize: 11,
                            fontWeight:
                            FontWeight
                                .w900,
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