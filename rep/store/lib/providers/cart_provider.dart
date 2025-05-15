import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  double get total => _items.fold(0, (sum, item) => 
    sum + (item['price'] as double) * (item['quantity'] as int));

  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getCart();
      _items = List<Map<String, dynamic>>.from(response['items']);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      await _apiService.addToCart(productId, quantity);
      await loadCart(); // Перезагружаем корзину для получения обновленных данных
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await _apiService.removeFromCart(productId);
      await loadCart(); // Перезагружаем корзину для получения обновленных данных
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 