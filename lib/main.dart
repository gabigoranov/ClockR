import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:tempus/services/audio_service.dart';
import 'package:tempus/views/clock_screen.dart';

import 'controllers/common/themes.dart';
import 'controllers/countdown_timer_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/timer_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();


  Get.put(ThemeController(), permanent: true);
  Get.put(CountdownTimerController(
    onPlayerTimeOut: () => print('Player time out!'),
    onOpponentTimeOut: () => print('Opponent time out!'),
    onTurnChanged: () => print('Turn changed'),
  ), permanent: true);
  await Get.putAsync<TimerController>(() async {
    final controller = TimerController();
    await controller.onInit(); // Manually trigger async init
    return controller;
  });

  runApp(const MyApp());
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
      themeMode: ThemeMode.system,
      supportedLocales: const [
        Locale('en', ''),
        Locale('bg', ''),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Clockr',
      home: const ClockScreen(),
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
