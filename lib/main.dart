import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/cv_catalog/cubit/cv_catalog_cubit.dart';
import 'features/cv_catalog/repository/cv_catalog_repository.dart';
import 'features/cv_catalog/screens/countries_screen.dart';

// ==========================================================
// BASE URL
// ==========================================================

// Development
// const String mainUrl =
//     'https://babeldevelopment.runasp.net';

// Production
const String mainUrl =
    'https://babelriyadhapi.azurewebsites.net';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const BabelCvCatalogApp(),
  );
}

class BabelCvCatalogApp extends StatelessWidget {
  const BabelCvCatalogApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repository = CvCatalogRepository.backend(
      baseUrl: mainUrl,
    );

    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) =>
        CvCatalogCubit(repository)
          ..loadCountries(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'بابل الرياض للاستقدام',
          theme: AppTheme.light,
          locale: const Locale('ar'),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child:
              child ??
                  const SizedBox.shrink(),
            );
          },
          home: const CountriesScreen(),
        ),
      ),
    );
  }
}