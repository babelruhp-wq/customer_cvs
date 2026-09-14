import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';

class PassportSearchField
    extends StatefulWidget {
  final String value;

  const PassportSearchField({
    required this.value,
  });

  @override
  State<PassportSearchField>
  createState() =>
      PassportSearchFieldState();
}

class PassportSearchFieldState
    extends State<PassportSearchField> {
  late final TextEditingController
  _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(
          text: widget.value,
        );
  }

  @override
  void didUpdateWidget(
      covariant PassportSearchField
      oldWidget,
      ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (widget.value !=
        _controller.text) {
      _controller.value =
          TextEditingValue(
            text: widget.value,
            selection:
            TextSelection.collapsed(
              offset:
              widget.value.length,
            ),
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();

    context
        .read<CvCatalogCubit>()
        .setPassportSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: AppShadows.card,
      ),
      child: TextField(
        controller: _controller,

        keyboardType:
        TextInputType.text,

        textCapitalization:
        TextCapitalization
            .characters,

        textDirection:
        TextDirection.ltr,

        textAlign: TextAlign.left,

        autocorrect: false,
        enableSuggestions: false,

        inputFormatters: [
          FilteringTextInputFormatter
              .allow(
            RegExp(
              r'[A-Za-z0-9]',
            ),
          ),
          const UpperCaseTextFormatter(),
        ],

        onChanged: (value) {
          context
              .read<CvCatalogCubit>()
              .setPassportSearch(
            value,
          );

          setState(() {});
        },

        style: GoogleFonts.cairo(
          color:
          AppColors.textPrimary,
          fontSize: 14,
          fontWeight:
          FontWeight.w800,
          letterSpacing: .8,
        ),

        decoration: InputDecoration(
          hintText:
          'ابحث برقم الجواز',

          hintTextDirection:
          TextDirection.rtl,

          hintStyle: GoogleFonts.cairo(
            color:
            AppColors.textMuted,
            fontSize: 12.5,
            fontWeight:
            FontWeight.w500,
          ),

          prefixIcon: Container(
            margin:
            const EdgeInsets.all(
              6,
            ),
            decoration:
            BoxDecoration(
              color:
              AppColors.primarySoft,
              borderRadius:
              BorderRadius.circular(
                AppRadius.md,
              ),
            ),
            child: const Icon(
              Icons
                  .search_rounded,
              color:
              AppColors.primary,
              size: 20,
            ),
          ),

          suffixIcon:
          _controller.text.isEmpty
              ? null
              : IconButton(
            tooltip:
            'مسح البحث',
            onPressed:
            _clearSearch,
            icon:
            const Icon(
              Icons
                  .close_rounded,
              size: 20,
              color: AppColors
                  .textSecondary,
            ),
          ),

          filled: true,
          fillColor:
          AppColors.background,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              AppRadius.md,
            ),
            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              AppRadius.md,
            ),
            borderSide:
            BorderSide.none,
          ),

          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(
              AppRadius.md,
            ),
            borderSide:
            const BorderSide(
              color:
              AppColors.primary,
              width: 1.4,
            ),
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// RESULTS TOOLBAR
// ==========================================================

class UpperCaseTextFormatter
    extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text =
    newValue.text.toUpperCase();

    return newValue.copyWith(
      text: text,
      selection:
      TextSelection.collapsed(
        offset: text.length,
      ),
      composing: TextRange.empty,
    );
  }
}
