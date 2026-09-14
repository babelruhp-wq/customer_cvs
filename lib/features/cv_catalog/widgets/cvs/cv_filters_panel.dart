import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';
import '../../cubit/cv_catalog_state.dart';
import '../../models/cv_filters.dart';

class CvFiltersPanel extends StatelessWidget {
  const CvFiltersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CvCatalogCubit, CvCatalogState>(
      buildWhen: (previous, current) => previous.filters != current.filters,
      builder: (context, state) {
        final cubit = context.read<CvCatalogCubit>();

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondarySoft,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.secondaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'فلترة السير الذاتية',
                          style: GoogleFonts.cairo(
                            color: AppColors.textPrimary,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'فلتر حسب الديانة والخبرة',
                          style: GoogleFonts.cairo(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!state.filters.isDefault)
                    TextButton.icon(
                      onPressed: cubit.resetFilters,
                      icon: const Icon(Icons.refresh_rounded, size: 17),
                      label: Text(
                        'إعادة ضبط',
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 760;

                  final religion = _FilterGroup<ReligionFilter>(
                    title: 'الديانة',
                    icon: Icons.mosque_outlined,
                    value: state.filters.religion,
                    values: const [
                      _FilterOption(ReligionFilter.all, 'الكل'),
                      _FilterOption(ReligionFilter.muslim, 'مسلمة'),
                      _FilterOption(ReligionFilter.nonMuslim, 'غير مسلمة'),
                    ],
                    onSelected: cubit.setReligion,
                  );

                  final experience = _FilterGroup<ExperienceFilter>(
                    title: 'الخبرة',
                    icon: Icons.work_history_outlined,
                    value: state.filters.experience,
                    values: const [
                      _FilterOption(ExperienceFilter.all, 'الكل'),
                      _FilterOption(
                        ExperienceFilter.experienced,
                        'سبق لها العمل',
                      ),
                      _FilterOption(ExperienceFilter.firstTime, 'أول مرة'),
                    ],
                    onSelected: cubit.setExperience,
                  );

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        religion,
                        const SizedBox(height: 16),
                        experience,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: religion),
                      const SizedBox(width: 18),
                      Expanded(child: experience),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterOption<T> {
  final T value;
  final String label;

  const _FilterOption(this.value, this.label);
}

class _FilterGroup<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final T value;
  final List<_FilterOption<T>> values;
  final ValueChanged<T> onSelected;

  const _FilterGroup({
    required this.title,
    required this.icon,
    required this.value,
    required this.values,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 17, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.cairo(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((option) {
            final selected = option.value == value;

            return ChoiceChip(
              selected: selected,
              showCheckmark: false,
              label: Text(
                option.label,
                style: GoogleFonts.cairo(
                  color: selected
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceMuted,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              onSelected: (_) => onSelected(option.value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
