
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      await _player.setReleaseMode(ReleaseMode.stop); // Stop previous sound
      _isInitialized = true;
    }
  }

  static Future<void> playSound(String assetPath) async {
    await init();
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}