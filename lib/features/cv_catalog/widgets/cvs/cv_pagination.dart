import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';
import '../../cubit/cv_catalog_state.dart';

class CvPagination extends StatelessWidget {
  final CvCatalogState state;

  const CvPagination({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final cubit =
    context.read<CvCatalogCubit>();

    final start =
    (state.page - 2)
        .clamp(
      1,
      state.totalPages,
    )
        .toInt();

    final end =
    (state.page + 2)
        .clamp(
      1,
      state.totalPages,
    )
        .toInt();

    return Center(
      child: Container(
        padding:
        const EdgeInsets.all(
          6,
        ),
        decoration:
        BoxDecoration(
          color: AppColors.surface,
          borderRadius:
          BorderRadius.circular(
            AppRadius.md,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow:
          AppShadows.card,
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed:
                state.page > 1
                    ? () =>
                    cubit.setPage(
                      state.page -
                          1,
                    )
                    : null,
                icon: const Icon(
                  Icons
                      .chevron_right_rounded,
                ),
              ),
            ),

            for (int page = start;
            page <= end;
            page++)
              SizedBox(
                width: 40,
                height: 40,
                child: page ==
                    state.page
                    ? FilledButton(
                  onPressed:
                  null,
                  style:
                  AppButtonStyles
                      .paginationSelected,
                  child: Text(
                    '$page',
                  ),
                )
                    : OutlinedButton(
                  onPressed: () =>
                      cubit
                          .setPage(
                        page,
                      ),
                  style:
                  AppButtonStyles
                      .paginationNormal,
                  child: Text(
                    '$page',
                  ),
                ),
              ),

            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: state.page <
                    state.totalPages
                    ? () => cubit.setPage(
                  state.page + 1,
                )
                    : null,
                icon: const Icon(
                  Icons
                      .chevron_left_rounded,
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
// EMPTY STATE
// ==========================================================
