import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/repositories/local_storage_service.dart';

class AudioProvider extends ChangeNotifier with WidgetsBindingObserver {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer(); // Nuevo player para efectos
  final LocalStorageService _storageService = LocalStorageService();
  bool _isEffectsEnabled = true;
  bool _isEnabled = true;
  bool _wasPlayingBeforeBackground = false;
  bool get isEnabled => _isEnabled;
  bool get isEffectsEnabled => _isEffectsEnabled;

  AudioProvider() {
    print('AudioProvider initialized');
    WidgetsBinding.instance.addObserver(this);
    _loadSavedSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App lifecycle state changed to: $state');
    switch (state) {
      case AppLifecycleState.paused:
        _handleBackgroundState();
        break;
      case AppLifecycleState.resumed:
        _handleForegroundState();
        break;
      default:
        break;
    }
  }

  Future<void> _handleBackgroundState() async {
    try {
      _wasPlayingBeforeBackground = _isEnabled && _musicPlayer.playing;
      if (_musicPlayer.playing) {
        print('App entering background: Pausing audio');
        await _musicPlayer.pause();
      }
    } catch (e) {
      print('Error handling background state: $e');
    }
  }

  Future<void> _handleForegroundState() async {
    try {
      if (_wasPlayingBeforeBackground) {
        print('App entering foreground: Resuming audio');
        await _musicPlayer.play();
      }
    } catch (e) {
      print('Error handling foreground state: $e');
    }
  }

  Future<void> _loadSavedSettings() async {
    try {
      _isEnabled = await _storageService.getMusicEnabled();
      _isEffectsEnabled = await _storageService.getEffectsEnabled();
      print('Loaded saved music settings: $_isEnabled');
      await _initAudio();
    } catch (e) {
      print('Error loading saved settings: $e');
    }
  }

  Future<void> loadSettings() async {
    await _loadSavedSettings();
  }

  Future<void> _initAudio() async {
    try {
      print('Starting audio initialization...');

      final duration = await _musicPlayer.setAsset('assets/audio/background_music.mp3');
      print('Audio duration: ${duration?.inSeconds} seconds');

      if (duration == null) {
        print('Error: Could not load audio file');
        return;
      }

      await _musicPlayer.setLoopMode(LoopMode.all);
      print('Loop mode set');

      await _musicPlayer.setVolume(0.5);
      print('Volume set to 0.5');

      if (_isEnabled) {
        print('Starting playback...');
        await _musicPlayer.play();
        print('Playback started');
      }
    } catch (e) {
      print('Error initializing audio: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> answerSound(bool isCorrect) async {
    if (!_isEffectsEnabled) return;

    try {
      // Seleccionar el archivo de sonido en función de si la respuesta es correcta o incorrecta
      final soundFile = isCorrect ? 'assets/audio/correct.wav' : 'assets/audio/incorrect.wav';

      print('Trying to play sound: $soundFile');

      // Cargar el archivo de audio y verificar si se carga correctamente
      final duration = await _effectsPlayer.setAsset(soundFile);
      if (duration == null) {
        print('Error: Could not load sound effect file');
        return;
      }
      print('Sound effect duration: ${duration.inMilliseconds} ms');

      // Ajustar el volumen y reproducir el sonido
      await _effectsPlayer.setVolume(1.0);
      await _effectsPlayer.play();
      print('Sound effect playback started');
    } catch (e) {
      print('Error playing sound effect: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }



  Future<void> toggleAudio() async {
    try {
      _isEnabled = !_isEnabled;
      print('Audio toggled. isEnabled: $_isEnabled');

      await _storageService.setMusicEnabled(_isEnabled);
      print('Audio setting saved to database');

      if (_isEnabled) {
        print('Attempting to play audio...');
        await _musicPlayer.play();
        print('Audio playing');
      } else {
        print('Attempting to pause audio...');
        await _musicPlayer.pause();
        print('Audio paused');
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling audio: $e');
    }
  }

  Future<void> toggleEffects() async {
    _isEffectsEnabled = !_isEffectsEnabled;
    notifyListeners();
  }

  @override
  void dispose() {
    print('Disposing AudioProvider');
    WidgetsBinding.instance.removeObserver(this);
    _musicPlayer.dispose();
    _effectsPlayer.dispose();
    super.dispose();
  }
}