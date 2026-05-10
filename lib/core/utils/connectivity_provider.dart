import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  final Connectivity _connectivity = Connectivity();

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // If any result in the list is NOT 'none', we consider it online
      _isOnline = results.any((result) => result != ConnectivityResult.none);
      notifyListeners();
    });
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = results.any((result) => result != ConnectivityResult.none);
    notifyListeners();
  }
}
