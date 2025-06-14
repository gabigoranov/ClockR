// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get language => 'Български';

  @override
  String get timeControls => 'Времеви контроли';

  @override
  String get active => 'АКТИВНО';

  @override
  String get timeUp => 'КРАЙ!';

  @override
  String get resetTimer => 'Рестартиране на таймера';

  @override
  String get resetTimerDialog => 'Това ще рестартира таймера до началната стойност на избраната времева контрола.';

  @override
  String get reset => 'Рестартиране';

  @override
  String get cancel => 'Отмяна';

  @override
  String get pause => 'Пауза';

  @override
  String get play => 'Начало';

  @override
  String get switchTurn => 'Смяна на хода';

  @override
  String get settings => 'Настройки';

  @override
  String get soundToggle => 'Звук';

  @override
  String get edit => 'Редактиране';

  @override
  String get newTimeControl => 'Времеви Контрол';

  @override
  String get languageText => 'Език';

  @override
  String get darkMode => 'Тъмен режим';

  @override
  String get addTimeControlTitle => 'Добавяне на Времеви Контрол';

  @override
  String get saveButton => 'Запази';

  @override
  String get timeControlNameLabel => 'Име на Времевия Контрол';

  @override
  String get timeControlNameHint => 'напр. Блиц, Рапид, Класически';

  @override
  String get timeControlNameError => 'Моля въведете име';

  @override
  String get baseTimeLabel => 'Основно Време';

  @override
  String minutesSuffix(Object minutes) {
    return '$minutes мин';
  }

  @override
  String secondsSuffix(Object seconds) {
    return '$seconds сек';
  }

  @override
  String get incrementLabel => 'Инкремент';

  @override
  String incrementSuffix(Object increment) {
    return '$increment секунди';
  }

  @override
  String get previewLabel => 'Преглед';

  @override
  String get timeControlNameMinLengthError => 'Моля въведете име с поне 3 символа';

  @override
  String get timeControlNameMaxLengthError => 'Моля въведете име с най-много 20 символа';

  @override
  String get error => 'Грешка';

  @override
  String get presetExistsError => 'Времеви контрол с това име вече съществува. Искате ли да го презапишете?';

  @override
  String get confirm => 'Потвърди';

  @override
  String get noCustomControls => 'Няма налични персонализирани времеви контроли';

  @override
  String get customControls => 'Персонализирани Контроли';
}
