import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tempus/services/locale_service.dart';
import 'package:test/test.dart';

import 'common/mock_flutter_secure_storage.dart';

class MockLocaleUpdater extends Mock {
  Future<void> call(Locale locale);
}

LocaleService get localeService => Get.find<LocaleService>();


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage mockStorage;
  late MockLocaleUpdater mockLocaleUpdater;

  setUp(() {
    Get.testMode = true;
    Get.reset(); // reset everything first

    mockStorage = MockFlutterSecureStorage();
    mockLocaleUpdater = MockLocaleUpdater();

    when(() => mockLocaleUpdater.call(any()))
        .thenAnswer((_) async {});

    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => 'en');

    when(() => mockStorage.write(
      key: any(named: 'key'),
      value: any(named: 'value'),
    )).thenAnswer((_) async {});

    Get.replace(LocaleService(storage: mockStorage, updateLocaleCallback: mockLocaleUpdater.call));
  });


  setUpAll(() {
    registerFallbackValue(Locale('invalid'));
  });

  tearDown(() {
    reset(mockStorage);
    reset(mockLocaleUpdater);
  });

  group('initialize', () {
    test('Should initialize with "en" if storage is empty', () async {
      // Arrange
      when(() => mockStorage.read(key: 'locale')).thenAnswer((_) async => null);

      // Act
      await localeService.initialize();

      // Assert
      expect(localeService.language, 'en');
      verifyNever(() => mockLocaleUpdater.call(Locale('en'))); // "en" is the default, so no update needed
    });

    test('Should initialize with "en" when storage contains it', () async {
      // Arrange
      when(() => mockStorage.read(key: 'locale')).thenAnswer((_) async => 'en');

      // Act
      await localeService.initialize();

      // Assert
      expect(localeService.language, 'en');
      verifyNever(() => mockLocaleUpdater.call(Locale('en'))); // "en" is the default, so no update needed
    });

    test('Should initialize with "bg" when storage contains it', () async {
      // Arrange
      when(() => mockStorage.read(key: 'locale')).thenAnswer((_) async => 'bg');

      // Act
      await localeService.initialize();

      // Assert
      expect(localeService.language, 'bg');
      verify(() => mockLocaleUpdater.call(Locale('bg'))).called(1);
    });

    test('Should initialize with "en" when storage contains invalid data', () async {
      // Arrange
      when(() => mockStorage.read(key: 'locale')).thenAnswer((_) async => 'invalid');

      // Act
      await localeService.initialize();

      // Assert
      expect(localeService.language, 'en');
      verifyNever(() => mockLocaleUpdater.call(Locale('en'))); // "en" is the default, so no update needed
    });
  });

  group('changeLanguage', () {
    test('Should change language to "bg"', () async {
      // Act
      await localeService.changeLanguage('bg');

      // Assert
      expect(localeService.language, 'bg');
      verify(() => mockLocaleUpdater.call(Locale('bg'))).called(1);
      verify(() => mockStorage.write(key: 'locale', value: 'bg')).called(1);
    });

    test('Should change language to "en"', () async {
      // Act
      await localeService.changeLanguage('en');

      // Assert
      expect(localeService.language, 'en');
      verifyNever(() => mockLocaleUpdater.call(Locale('en'))); // "en" is the default, so no update needed
      verifyNever(() => mockStorage.write(key: 'locale', value: 'en'));
    });

    test('Should not change language if code is invalid', () {
      expect(
            () async => await localeService.changeLanguage('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('toggle', () {
    test('Should toggle from "en" to "bg"', () async {
      // Act
      await localeService.changeLanguage('en');
      await localeService.toggle();

      // Assert
      expect(localeService.language, 'bg');
      verify(() => mockLocaleUpdater.call(Locale('bg'))).called(1);
      verify(() => mockStorage.write(key: 'locale', value: 'bg')).called(1);
    });

    test('Should toggle from "bg" to "en"', () async {
      // Act
      await localeService.changeLanguage('bg');
      await localeService.toggle();

      // Assert
      expect(localeService.language, 'en');
      verify(() => mockLocaleUpdater.call(Locale('en'))).called(1);
      verify(() => mockStorage.write(key: 'locale', value: 'en')).called(1);
    });
  });

  group('save', () {
    test('Should save current locale to storage', () async {
      // Act
      await localeService.save();

      // Assert
      verify(() => mockStorage.write(key: 'locale', value: 'en')).called(1);
    });
  });
}