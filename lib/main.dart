import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/admin/presentation/viewmodels.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/viewmodels.dart';
import 'package:solveit/features/forum/presentation/viewmodels/viewmodels.dart';
import 'package:solveit/features/general/presentation/viewmodel.dart/viewmodel.dart';
import 'package:solveit/features/home/presentation/viewmodel/viewmodels.dart';
import 'package:solveit/features/market/presentation/viewmodel/viewmodel.dart';
import 'package:solveit/features/messages/presentation/viewmodel/viewmodels.dart';
import 'package:solveit/features/posts/presentation/viewmodels/viewmodels.dart';
import 'package:solveit/features/school/presentation/viewmodels.dart';
import 'package:solveit/features/service/presentation/viewmodels/viewmodels.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:upgrader/upgrader.dart';

final GoRouter router = GetIt.instance<GoRouter>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreInjectionContainer.initialize();

  runApp(
    MultiProvider(
      providers: [
        ...adminViewmodels,
        ...authViewmodels,
        ...postsViewmodels,
        ...schoolsViewmodels,
        ...messagesViewmodel,
        ...homeViewmodels,
        ...marketViewModels,
        ...servicesViewModel,
        ...forumViewModel,
        ...generalViewModels,
      ],
      child: const MyApp(),
    ),
  );
}

final getIt = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _registerContext(BuildContext context) {
    if (!getIt.isRegistered<BuildContext>()) {
      getIt.registerSingleton<BuildContext>(context);
      getIt.registerSingleton<AppLocalizations>(context.getLocalization()!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              CountryLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('el'),
            ],
            theme: solveitThemeLight,
            // darkTheme: solveitThemeDark,
            themeMode: ThemeMode.system,
            routerConfig: router,
            builder: (context, child) {
              _registerContext(context);
              return UpgradeAlert(
                navigatorKey: router.routerDelegate.navigatorKey,
                shouldPopScope: () => true,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}
