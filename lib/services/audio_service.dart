import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';

class AudioService {
  final _players = <AudioPlayer>[];
  final _maxPlayers = 5; // Prevent memory leaks

  Future<void> playSound(String assetPath) async {
    if(CountdownTimerController.to.isMuted.value) {
      return;
    }

    try {
      // Clean up finished players
      _players.removeWhere((p) => p.state == PlayerState.stopped);

      // Create new player if under limit
      final player = _players.length < _maxPlayers
          ? AudioPlayer()
          : _players.removeAt(0); // Recycle oldest player

      // Configure for instant playback
      await player.setReleaseMode(ReleaseMode.release);
      await player.setVolume(1.0);
      await player.setSource(AssetSource(assetPath));

      // Play and track
      unawaited(player.resume().then((_) {
        _players.add(player);
      }).catchError((_) => player.dispose()));

    } catch (e) {
      debugPrint('Audio play error: $e');
    }
  }

  Future<void> dispose() async {
    await Future.wait(_players.map((p) => p.dispose()));
    _players.clear();
  }
}