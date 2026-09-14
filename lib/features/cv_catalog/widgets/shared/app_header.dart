import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  static const String whatsappNumber =
      '966112309922';

  static const String whatsappDisplayNumber =
      '+966 11 230 9922';

  final bool showBack;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    this.showBack = false,
    this.onBack,
  });

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/$whatsappNumber',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width;

    final mobile =
        width < 600;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: mobile ? 8 : 12,
        ),
        child: Container(
          width: double.infinity,
          height: mobile ? 66 : 76,
          decoration: BoxDecoration(
            gradient: AppGradients.hero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .14,
                ),
                blurRadius: 22,
                offset: const Offset(
                  0,
                  7,
                ),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(
                  alpha: .08,
                ),
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                AppLayout.maxContentWidth,
              ),
              child: Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  mobile ? 16 : 24,
                ),
                child: Row(
                  children: [
                    // =====================================
                    // BRAND
                    // =====================================

                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            'بابل الرياض للاستقدام',
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            GoogleFonts.cairo(
                              color:
                              Colors.white,
                              fontSize:
                              mobile
                                  ? 15
                                  : 17,
                              fontWeight:
                              FontWeight
                                  .w900,
                              height: 1.25,
                            ),
                          ),

                          if (!mobile) ...[
                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              'اختيار أسهل للكادر المناسب',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              GoogleFonts
                                  .cairo(
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha: .72,
                                ),
                                fontSize:
                                10.5,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // =====================================
                    // WHATSAPP
                    // =====================================

                    if (!mobile)
                      FilledButton.icon(
                        onPressed:
                        _openWhatsApp,
                        style:
                        FilledButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                            0xFF25D366,
                          ),
                          foregroundColor:
                          Colors.white,
                          elevation: 0,
                          minimumSize:
                          const Size(
                            0,
                            44,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 18,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons
                              .chat_rounded,
                          size: 18,
                        ),
                        label: Row(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          children: [
                            Text(
                              'واتساب',
                              style:
                              GoogleFonts
                                  .cairo(
                                fontSize: 12,
                                fontWeight:
                                FontWeight
                                    .w900,
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Directionality(
                              textDirection:
                              TextDirection
                                  .ltr,
                              child: Text(
                                whatsappDisplayNumber,
                                style:
                                GoogleFonts
                                    .cairo(
                                  fontSize:
                                  12.5,
                                  fontWeight:
                                  FontWeight
                                      .w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      IconButton.filled(
                        tooltip:
                        'تواصل عبر واتساب',
                        onPressed:
                        _openWhatsApp,
                        style:
                        IconButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                            0xFF25D366,
                          ),
                          foregroundColor:
                          Colors.white,
                          minimumSize:
                          const Size(
                            42,
                            42,
                          ),
                          maximumSize:
                          const Size(
                            42,
                            42,
                          ),
                        ),
                        icon: const Icon(
                          Icons
                              .chat_rounded,
                          size: 19,
                        ),
                      ),

                    // =====================================
                    // BACK
                    // =====================================

                    if (showBack) ...[
                      const SizedBox(
                        width: 10,
                      ),

                      Tooltip(
                        message: 'رجوع',
                        textStyle:
                        GoogleFonts.cairo(
                          color:
                          Colors.white,
                          fontSize: 11,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                        child: IconButton(
                          onPressed:
                          onBack ??
                                  () =>
                                  Navigator
                                      .maybePop(
                                    context,
                                  ),
                          style:
                          IconButton
                              .styleFrom(
                            backgroundColor:
                            Colors.white
                                .withValues(
                              alpha: .10,
                            ),
                            foregroundColor:
                            Colors.white,
                            minimumSize:
                            const Size(
                              42,
                              42,
                            ),
                            maximumSize:
                            const Size(
                              42,
                              42,
                            ),
                          ),
                          icon:
                          const Icon(
                            Icons
                                .arrow_forward_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}