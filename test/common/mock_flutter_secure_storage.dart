import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  MockFlutterSecureStorage(){
    // Mock themeColors so they return Future<null> when read is called and so default colors are used
    when(() => read(key: 'themeColors')).thenAnswer((_) async => null);

    when(() => read(
      key: any(named: 'key'),
      iOptions: any(named: 'iOptions'),
      aOptions: any(named: 'aOptions'),
      lOptions: any(named: 'lOptions'),
      webOptions: any(named: 'webOptions'),
      mOptions: any(named: 'mOptions'),
      wOptions: any(named: 'wOptions'),
    )).thenAnswer((_) async => null);

    when(() => write(
      key: any(named: 'key'),
      value: any(named: 'value'),
      iOptions: any(named: 'iOptions'),
      aOptions: any(named: 'aOptions'),
      lOptions: any(named: 'lOptions'),
      webOptions: any(named: 'webOptions'),
      mOptions: any(named: 'mOptions'),
      wOptions: any(named: 'wOptions'),
    )).thenAnswer((_) async {});
  }
}
