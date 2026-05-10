import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VoiceProvider with ChangeNotifier {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _lastTranscribedText = '';
  String? _lastRecordedPath;

  bool get isRecording => _isRecording;
  String get lastTranscribedText => _lastTranscribedText;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    if (!kIsWeb) {
      await _recorder.openRecorder();
    }
  }

  Future<void> startRecording() async {
    if (kIsWeb) {
      _isRecording = true;
      notifyListeners();
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: path);
      _isRecording = true;
      _lastRecordedPath = path;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting recorder: $e');
    }
  }

  Future<String> stopRecording() async {
    if (kIsWeb) {
      _isRecording = false;
      _lastTranscribedText = 'Nimenyunyiza mahindi leo asubuhi';
      notifyListeners();
      return _lastTranscribedText;
    }

    try {
      await _recorder.stopRecorder();
      _isRecording = false;
      _lastTranscribedText = 'Nimenyunyiza mahindi leo asubuhi';
      notifyListeners();
      return _lastTranscribedText;
    } catch (e) {
      _isRecording = false;
      notifyListeners();
      return 'Recording error.';
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _recorder.closeRecorder();
    }
    super.dispose();
  }
}
