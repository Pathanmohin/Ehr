import 'dart:async';
import 'package:flutter/material.dart';

class SessionTimeoutManager {
  Timer? _sessionTimer;
  final int _timeoutDuration;
  final VoidCallback onSessionTimeout;

  SessionTimeoutManager(
      {required int timeoutDuration, required this.onSessionTimeout})
      : _timeoutDuration = timeoutDuration;

  void startTimer() {
    _sessionTimer?.cancel();
    _sessionTimer =
        Timer(Duration(minutes: _timeoutDuration), onSessionTimeout);
  }

  void resetTimer() {
    startTimer();
  }

  void dispose() {
    _sessionTimer?.cancel();
  }
}
