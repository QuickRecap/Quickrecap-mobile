import 'dart:async';

class ActivityTrackingService {
  static final ActivityTrackingService _instance = ActivityTrackingService._internal();

  factory ActivityTrackingService() => _instance;

  ActivityTrackingService._internal();

  int _totalClicks = 0;
  final _clicksController = StreamController<int>.broadcast();

  void startCapturingClicks() {
    _totalClicks = 0;
  }

  void registerClick() {
    _totalClicks++;
    _clicksController.sink.add(_totalClicks);
  }

  int getTotalClicks() {
    return _totalClicks;
  }

  Stream<int> get clicksStream => _clicksController.stream;

  void dispose() {
    _clicksController.close();
  }
}