// onboarding_question_vm.dart
import 'package:flutter/material.dart';

class OnboardingQuestionViewModel extends ChangeNotifier {
  double _progress = 0.0;
  bool _isRecording = false;

  double get progress => _progress;
  bool get isRecording => _isRecording;

  void setProgress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }
}
