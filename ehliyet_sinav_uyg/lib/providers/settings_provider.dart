import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _shuffleQuestions = true;
  
  bool _timerEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;

  bool get shuffleQuestions => _shuffleQuestions;
  
  bool get timerEnabled => _timerEnabled;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _shuffleQuestions = prefs.getBool('shuffleQuestions') ?? true;
    
    _timerEnabled = prefs.getBool('timerEnabled') ?? true;
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index];
    notifyListeners();
  }

  Future<void> setShuffleQuestions(bool value) async {
    _shuffleQuestions = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shuffleQuestions', value);
    notifyListeners();
  }

  

  Future<void> setTimerEnabled(bool value) async {
    _timerEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('timerEnabled', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }
}