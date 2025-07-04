// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get timeControls => 'Time Controls';

  @override
  String get active => 'ACTIVE';

  @override
  String get timeUp => 'TIME UP!';

  @override
  String get resetTimer => 'Reset Timer';

  @override
  String get resetTimerDialog => 'This will reset the timer to the initial value of the selected time control.';

  @override
  String get reset => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Play';

  @override
  String get switchTurn => 'Switch Turn';

  @override
  String get settings => 'Settings';

  @override
  String get soundToggle => 'Sound Toggle';

  @override
  String get edit => 'Edit';

  @override
  String get newTimeControl => 'Time Control';

  @override
  String get languageText => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get addTimeControlTitle => 'Add Time Control';

  @override
  String get saveButton => 'Save';

  @override
  String get timeControlNameLabel => 'Time Control Name';

  @override
  String get timeControlNameHint => 'e.g. Blitz, Rapid, Classical';

  @override
  String get timeControlNameError => 'Please enter a name';

  @override
  String get baseTimeLabel => 'Base Time';

  @override
  String minutesSuffix(Object minutes) {
    return '$minutes min';
  }

  @override
  String secondsSuffix(Object seconds) {
    return '$seconds sec';
  }

  @override
  String get incrementLabel => 'Increment';

  @override
  String incrementSuffix(Object increment) {
    return '$increment seconds';
  }

  @override
  String get previewLabel => 'Preview';

  @override
  String get timeControlNameMinLengthError => 'Please enter a name with at least 3 characters';

  @override
  String get timeControlNameMaxLengthError => 'Please enter a name with at most 20 characters';

  @override
  String get error => 'Error';

  @override
  String get presetExistsError => 'A time control with this name already exists. Would you like to overwrite it?';

  @override
  String get confirm => 'Confirm';

  @override
  String get noCustomControls => 'No custom time controls available';

  @override
  String get customControls => 'Custom Controls';

  @override
  String get updateAvailableTitle => 'Update Available';

  @override
  String get updateAvailableMessage => 'A new version of the app is available. Please update to enjoy the latest features.';

  @override
  String versionInfo(String versionCode) {
    return 'Version info: $versionCode';
  }

  @override
  String get laterButton => 'Later';

  @override
  String get performImmediateUpdate => 'Install Now';

  @override
  String get startFlexibleUpdate => 'Download Update';

  @override
  String get completeFlexibleUpdate => 'Install Downloaded Update';

  @override
  String get updateSnackbarSuccess => 'Update successful!';

  @override
  String updateSnackbarFailure(String error) {
    return 'Update failed: $error';
  }

  @override
  String get save => 'Save';

  @override
  String get select => 'Select';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTimeControlTitle => 'Delete Time Control';

  @override
  String get deleteTimeControlConfirmation => 'Are you sure you want to delete this time control?';

  @override
  String get editTimeControlTitle => 'Edit Time Control';

  @override
  String get colorScheme => 'Color Scheme';

  @override
  String get primaryColor => 'Primary Color';
}
