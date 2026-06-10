import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class RingtoneService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static String? _currentlyPlayingPath;

  // Load dynamically from AssetManifest.json
  static Future<List<String>> getAvailableRingtonePaths() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final paths = manifestMap.keys
          .where((key) => key.startsWith('assets/audio/') && key.endsWith('.mp3'))
          .toList();
      paths.sort();
      return paths;
    } catch (e) {
      // Fallback if load fails
      return [
        'assets/audio/Classic.mp3',
        'assets/audio/Evacuate.mp3',
        'assets/audio/Fire Alarm.mp3',
        'assets/audio/Funny.mp3',
        'assets/audio/Lofi.mp3',
        'assets/audio/Real clock.mp3',
        'assets/audio/Siren.mp3',
      ];
    }
  }

  // Get user-friendly name from path
  static String getDisplayName(String path) {
    // e.g. "assets/audio/Real clock.mp3" -> "Real Clock"
    final filename = path.split('/').last;
    final nameWithoutExt = filename.substring(0, filename.lastIndexOf('.'));
    return nameWithoutExt.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  // Play alarm (looping, maximum volume)
  static Future<void> playAlarm(String ringtonePath) async {
    await stop();
    
    // Ensure path is valid
    String path = ringtonePath;
    if (!path.startsWith('assets/audio/')) {
      path = 'assets/audio/Classic.mp3';
    }

    _currentlyPlayingPath = path;

    // audioplayers expects path relative to assets/
    final playerPath = path.replaceFirst('assets/', '');

    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource(playerPath));
  }

  // Play preview (play once, maximum volume)
  static Future<void> playPreview(String ringtonePath) async {
    await stop();

    String path = ringtonePath;
    if (!path.startsWith('assets/audio/')) {
      path = 'assets/audio/Classic.mp3';
    }

    _currentlyPlayingPath = path;
    final playerPath = path.replaceFirst('assets/', '');

    await _audioPlayer.setReleaseMode(ReleaseMode.release);
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource(playerPath));
  }

  // Stop playback
  static Future<void> stop() async {
    await _audioPlayer.stop();
    _currentlyPlayingPath = null;
  }

  // Get currently playing path
  static String? get currentlyPlayingPath => _currentlyPlayingPath;
}
