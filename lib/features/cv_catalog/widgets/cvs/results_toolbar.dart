import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';
import '../../cubit/cv_catalog_state.dart';

class ResultsToolbar
    extends StatelessWidget {
  final CvCatalogState state;

  const ResultsToolbar({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            state.totalCount == 1
                ? 'سيرة ذاتية واحدة مطابقة'
                : '${state.totalCount} سيرة ذاتية مطابقة',
            style: GoogleFonts.cairo(
              color:
              AppColors.textPrimary,
              fontSize: 13,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),

        OutlinedButton.icon(
          onPressed: state.cvsStatus ==
              LoadStatus.loading
              ? null
              : () => context
              .read<
              CvCatalogCubit>()
              .loadCvs(
            refresh: true,
          ),
          icon: const Icon(
            Icons.refresh_rounded,
            size: 17,
          ),
          label: Text(
            'تحديث',
            style: GoogleFonts.cairo(
              fontSize: 11.5,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// PAGINATION
// ==========================================================
