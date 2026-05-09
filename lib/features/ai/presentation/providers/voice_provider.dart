import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceProvider with ChangeNotifier {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _lastTranscribedText = '';

  bool get isRecording => _isRecording;
  String get lastTranscribedText => _lastTranscribedText;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(toFile: 'shamba_voice.aac');
    _isRecording = true;
    notifyListeners();
  }

  Future<String> stopRecording() async {
    final path = await _recorder.stopRecorder();
    _isRecording = false;
    _lastTranscribedText = _mockTranscribe(path ?? '');
    notifyListeners();
    return _lastTranscribedText;
  }

  String _mockTranscribe(String path) {
    // In a real app, send 'path' to Whisper API or similar
    // Mocking Swahili/English transcription based on the proposal
    return 'Nimenyunyiza mahindi leo asubuhi'; 
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
