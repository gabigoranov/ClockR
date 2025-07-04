import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// A service for managing the app's locale (language settings).
/// This service uses `Get.updateLocale` for switching the locale dynamically
/// and `FlutterSecureStorage` for persisting the selected locale.
final class LocaleService {
  // Factory constructor for accessing the singleton instance.
  LocaleService({FlutterSecureStorage? storage, Future<void> Function(Locale locale)? updateLocaleCallback}) {
    // If a custom storage instance is provided, use it; otherwise, use the default.
    _storage = storage ?? const FlutterSecureStorage();
    // If a custom locale update callback is provided, use it; otherwise, leave it GetX.
    _updateLocaleCallback = updateLocaleCallback ?? Get.updateLocale;
    initialize();
  }

  // Secure storage instance for securely saving and reading data.
  late FlutterSecureStorage _storage;
  late Future<void> Function(Locale locale) _updateLocaleCallback;

  // Current locale value, defaulting to English ("en").
  late String _locale = 'en';

  final languages = {
    'en': 'English',
    'bg': 'Български',
  };

  String get language => _locale;

  /// Initializes the service by reading the saved locale from secure storage
  /// and updating the app's locale accordingly.
  Future<void> initialize() async {
    // Read the stored locale from secure storage.
    String? read = await _storage.read(key: "locale");
    if (read != null && languages.containsKey(read) && read != _locale) {
      _locale = read; // Update the local `_locale` variable with the saved value.
      await _updateLocaleCallback(Locale(_locale));
    }
  }

  /// Changes the app's language to the specified language code.
  Future<void> changeLanguage(String languageCode) async {
    if(languages[languageCode] == null) {
      throw ArgumentError('Unsupported language code: $languageCode');
    }

    if(_locale == languageCode) {
      return; // No change needed if the language is already set.
    }

    _locale = languageCode;
    await _updateLocaleCallback(Locale(languageCode));
    await save();
  }

  /// Toggles the app's locale between English ("en") and Bulgarian ("bg").
  Future<void> toggle() async {
    // Switch to Bulgarian if the current locale is English.
    if (_locale == 'en') {
      _locale = 'bg';
      await _updateLocaleCallback(Locale(_locale));
    }
    // Switch to English if the current locale is Bulgarian.
    else if (_locale == 'bg') {
      _locale = 'en';
      await _updateLocaleCallback(Locale(_locale));
    }

    // Save the updated locale to secure storage.
    await save();
  }

  /// Saves the current locale to secure storage.
  Future<void> save() async {
    await _storage.write(key: 'locale', value: _locale);
  }
}
