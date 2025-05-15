import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isAuthenticated = _token != null;
    if (_isAuthenticated) {
      try {
        _userData = await _apiService.getProfile();
        notifyListeners();
      } catch (e) {
        _isAuthenticated = false;
        _token = null;
        await prefs.remove('auth_token');
        notifyListeners();
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      _isAuthenticated = true;
      _userData = response['user'];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      await _apiService.register(email, password, name);
      await login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _isAuthenticated = false;
    _token = null;
    _userData = null;
    notifyListeners();
  }
} 