import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
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
import 'package:solveit/main.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreInjectionContainer.initialize();
  usePathUrlStrategy();
  runApp(MultiProvider(providers: [
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
  ], child: const AdminWebApp()));
}

class AdminWebApp extends StatelessWidget {
  const AdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(600, 800),
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
              title: 'Solveit Admin',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: SolveitColors.primaryColor,
                  primary: SolveitColors.primaryColor,
                  secondary: SolveitColors.secondaryColor,
                ),
                useMaterial3: true,
              ),
              routerConfig: router,
            ),
          );
        });
  }
}
