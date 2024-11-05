import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeViewModel extends ChangeNotifier {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isDarkMode = false;

  ThemeViewModel() {
    _loadTheme();
  }

  void _loadTheme() async {
    String? theme = await secureStorage.read(key: 'theme');
    if (theme != null) {
      isDarkMode = theme == 'dark';
      notifyListeners();
    }
  }

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    await secureStorage.write(key: 'theme', value: isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}
