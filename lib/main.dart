import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app/app_constants.dart';
import 'core/init/app/app_init.dart';
import 'core/init/lang/language_manager.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/notifier/provider_list.dart';
import 'core/init/notifier/theme_notifier.dart';
import 'view/authentication/app/app_view.dart';
import 'view/authentication/login/login_view.dart';
import 'view/authentication/register/RegisterView.dart';
import 'view/authentication/splash/error_view.dart';
import 'view/authentication/splash/splash_view.dart';

Future<void> main() async {
  await AppInitiliaze().initBeforeAppStart();
  runApp(
    MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: ApplicationConstants.LANG_ASSET_PATH,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/splash": (context) => const SplashView(),
        "/error": (context) => const ErrorView(),
        "/loginPage": (context) => const LoginView(),
        "/signUp": (context) => const RegisterView(),
        "/app": (context) => const AppView(),
      },
      initialRoute: "/splash",
      theme: Provider.of<ThemeNotifier>(context, listen: false).currentTheme,
      navigatorKey: NavigationService.instance.navigatorKey,
    );
  }
}

//TODO: UserModel oluştur tüm verileri belirle toJson ve fromJson ekle
//TODO: ImageModel oluştur tüm verileri belirle toJson ve fromJson ekle
//TODO: ImageModel için önce firebase'e at url'i modele yaz modeli firestore'a at
