import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tempus/services/audio_service.dart';
import 'package:tempus/services/locale_service.dart';
import 'package:tempus/services/system_chrome_service.dart';
import 'package:tempus/views/clock_screen.dart';

import 'controllers/common/themes.dart';
import 'controllers/countdown_timer_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/time_control_controller.dart';
import 'l10n/app_localizations.dart';
import 'services/common/route_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  await _initializeServices();

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  Get.put(SystemChromeService());
  Get.put(AudioService());
  Get.put(LocaleService(
    storage: const FlutterSecureStorage(),
  ));
  Get.put(ThemeController(const FlutterSecureStorage()), permanent: true);
  Get.put(CountdownTimerController(
    onPlayerTimeOut: () => debugPrint('Player time out!'),
    onOpponentTimeOut: () => debugPrint('Opponent time out!'),
    onTurnChanged: () => debugPrint('Turn changed'),
  ), permanent: true);
  await Get.putAsync<TimeControlController>(() async {
    final controller = TimeControlController();
    await controller.onInit(); // Manually trigger async init
    return controller;
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));


    return GetMaterialApp(
      navigatorKey: navigatorKey,
      translations: AppTranslations(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeController.to.themeMode.value,
      supportedLocales: const [
        Locale('en', ''),
        Locale('bg', ''),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'ClockR',
      home: const ClockScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}


class AppTranslations extends Translations {
  final Map<String, Map<String, String>> _translations = {};

  AppTranslations() {
    _loadTranslations();
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;

  Future<void> _loadTranslations() async {
    _translations['en'] = await _loadArbFile('lib/l10n/app_en.arb');
    _translations['bg'] = await _loadArbFile('lib/l10n/app_bg.arb');
  }

  Future<Map<String, String>> _loadArbFile(String path) async {
    final String arbContent = await rootBundle.loadString(path);
    final Map<String, dynamic> arbMap = jsonDecode(arbContent);

    // Use `entries.where` to filter out keys starting with "@"
    final filteredEntries = arbMap.entries
        .where((entry) => !entry.key.startsWith('@'))
        .map((entry) => MapEntry(entry.key, entry.value.toString()));

    return Map.fromEntries(filteredEntries);
  }
}
