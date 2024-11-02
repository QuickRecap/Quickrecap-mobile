// lib/ui/providers/audio_provider.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/repositories/local_storage_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final LocalStorageService _storageService = LocalStorageService();
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  AudioProvider() {
    print('AudioProvider initialized');
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    try {
      _isEnabled = await _storageService.getMusicEnabled();
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

      final duration = await _player.setAsset('assets/audio/background_music.mp3');
      print('Audio duration: ${duration?.inSeconds} seconds');

      if (duration == null) {
        print('Error: Could not load audio file');
        return;
      }

      await _player.setLoopMode(LoopMode.all);
      print('Loop mode set');

      await _player.setVolume(0.5);
      print('Volume set to 0.5');

      if (_isEnabled) {
        print('Starting playback...');
        await _player.play();
        print('Playback started');
      }
    } catch (e) {
      print('Error initializing audio: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> toggleAudio() async {
    try {
      _isEnabled = !_isEnabled;
      print('Audio toggled. isEnabled: $_isEnabled');

      // Save the new setting
      await _storageService.setMusicEnabled(_isEnabled);
      print('Audio setting saved to database');

      if (_isEnabled) {
        print('Attempting to play audio...');
        await _player.play();
        print('Audio playing');
      } else {
        print('Attempting to pause audio...');
        await _player.pause();
        print('Audio paused');
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling audio: $e');
    }
  }

  void dispose() {
    print('Disposing AudioProvider');
    _player.dispose();
    super.dispose();
  }
}