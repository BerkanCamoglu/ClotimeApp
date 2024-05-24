import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../firebase_options.dart';
import '../cache/locale_manager.dart';

class AppInitiliaze {
  Future<void> initBeforeAppStart() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocaleManager.init();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
