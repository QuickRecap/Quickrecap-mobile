import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isInitialized = false;
  bool _hasError = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get hasError => _hasError;

  Future<void> initAudio() async {
    if (_isInitialized) return;

    try {
      print(await _audioPlayer.setAsset('assets/audio/background_music.mp3')); // Verify path
      await _audioPlayer.setLoopMode(LoopMode.one); // Consider changing loop mode
      await _audioPlayer.setVolume(0.5);

      _isInitialized = true;

      // Only reproduce if enabled
      if (_isMusicEnabled) {
        await _audioPlayer.play();
      }
    } catch (e) {
      _hasError = true;
      print('Error in AudioProvider.initAudio: $e');
    }
  }

  void toggleMusic() {
    if (_hasError) return; // No hacer nada si hay error

    _isMusicEnabled = !_isMusicEnabled;
    try {
      if (_isMusicEnabled) {
        _audioPlayer.play();
      } else {
        _audioPlayer.pause();
      }
      notifyListeners();
    } catch (e) {
      print('Error en toggleMusic: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (_hasError) return;

    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      }
    } catch (e) {
      print('Error en pauseBackgroundMusic: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (_hasError) return;

    try {
      if (!_audioPlayer.playing && _isMusicEnabled) {
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error en resumeBackgroundMusic: $e');
    }
  }

  @override
  void dispose() {
    try {
      _audioPlayer.dispose();
    } catch (e) {
      print('Error en dispose: $e');
    }
    super.dispose();
  }
}