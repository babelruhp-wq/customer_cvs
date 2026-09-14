import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../shared/app_header.dart';

class CountriesHelpSection extends StatelessWidget {
  const CountriesHelpSection({
    super.key,
  });

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/${AppHeader.whatsappNumber}',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        4,
        24,
        42,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 27,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(0xFF102E5E),
                  Color(0xFF071A36),
                ],
              ),
              borderRadius: BorderRadius.circular(
                AppRadius.xl,
              ),
              boxShadow: AppShadows.card,
              border: Border.all(
                color: AppColors.secondary.withValues(
                  alpha: .12,
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final desktop =
                    constraints.maxWidth >= 720;

                final content = Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وجدت السيرة المناسبة؟',
                      style: GoogleFonts.cairo(
                        color:
                        AppColors.textOnPrimary,
                        fontWeight:
                        FontWeight.w900,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'تواصل مباشرة عبر واتساب مع فريق بابل الرياض للاستقدام لمساعدتك.',
                      style: GoogleFonts.cairo(
                        color:
                        AppColors.heroTextSoft,
                        fontSize: 13,
                        height: 1.7,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                );

                final button =
                FilledButton.icon(
                  onPressed: _openWhatsApp,
                  style:
                  FilledButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF25D366,
                    ),
                    foregroundColor:
                    Colors.white,
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        AppRadius.md,
                      ),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.chat_rounded,
                    size: 18,
                  ),
                  label: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Text(
                        'تواصل واتساب',
                        style:
                        GoogleFonts.cairo(
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Directionality(
                        textDirection:
                        TextDirection.ltr,
                        child: Text(
                          AppHeader
                              .whatsappDisplayNumber,
                          style:
                          GoogleFonts.cairo(
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (desktop) {
                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color: const Color(
                            0xFF25D366,
                          ).withValues(
                            alpha: .13,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            AppRadius.md,
                          ),
                          border: Border.all(
                            color: const Color(
                              0xFF25D366,
                            ).withValues(
                              alpha: .22,
                            ),
                          ),
                        ),
                        alignment:
                        Alignment.center,
                        child: const Icon(
                          Icons.chat_rounded,
                          color: Color(
                            0xFF25D366,
                          ),
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: content,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      button,
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    content,
                    const SizedBox(
                      height: 18,
                    ),
                    button,
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