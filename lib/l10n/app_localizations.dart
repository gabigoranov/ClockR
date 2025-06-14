import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('en')
  ];

  /// The current Language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @timeControls.
  ///
  /// In en, this message translates to:
  /// **'Time Controls'**
  String get timeControls;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @timeUp.
  ///
  /// In en, this message translates to:
  /// **'TIME UP!'**
  String get timeUp;

  /// No description provided for @resetTimer.
  ///
  /// In en, this message translates to:
  /// **'Reset Timer'**
  String get resetTimer;

  /// No description provided for @resetTimerDialog.
  ///
  /// In en, this message translates to:
  /// **'This will reset the timer to the initial value of the selected time control.'**
  String get resetTimerDialog;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @switchTurn.
  ///
  /// In en, this message translates to:
  /// **'Switch Turn'**
  String get switchTurn;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @soundToggle.
  ///
  /// In en, this message translates to:
  /// **'Sound Toggle'**
  String get soundToggle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @newTimeControl.
  ///
  /// In en, this message translates to:
  /// **'Time Control'**
  String get newTimeControl;

  /// No description provided for @languageText.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageText;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @addTimeControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Time Control'**
  String get addTimeControlTitle;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @timeControlNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Time Control Name'**
  String get timeControlNameLabel;

  /// No description provided for @timeControlNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blitz, Rapid, Classical'**
  String get timeControlNameHint;

  /// No description provided for @timeControlNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get timeControlNameError;

  /// No description provided for @baseTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Base Time'**
  String get baseTimeLabel;

  /// No description provided for @minutesSuffix.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesSuffix(Object minutes);

  /// No description provided for @secondsSuffix.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec'**
  String secondsSuffix(Object seconds);

  /// No description provided for @incrementLabel.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementLabel;

  /// No description provided for @incrementSuffix.
  ///
  /// In en, this message translates to:
  /// **'{increment} seconds'**
  String incrementSuffix(Object increment);

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @timeControlNameMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name with at least 3 characters'**
  String get timeControlNameMinLengthError;

  /// No description provided for @timeControlNameMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name with at most 20 characters'**
  String get timeControlNameMaxLengthError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @presetExistsError.
  ///
  /// In en, this message translates to:
  /// **'A time control with this name already exists. Would you like to overwrite it?'**
  String get presetExistsError;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @noCustomControls.
  ///
  /// In en, this message translates to:
  /// **'No custom time controls available'**
  String get noCustomControls;

  /// No description provided for @customControls.
  ///
  /// In en, this message translates to:
  /// **'Custom Controls'**
  String get customControls;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bg', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg': return AppLocalizationsBg();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
