import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getProducts();
      _products = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) {
      final name = (product['name'] as String).toLowerCase();
      final description = (product['description'] as String?)?.toLowerCase() ?? '';
      return name.contains(lowercaseQuery) || description.contains(lowercaseQuery);
    }).toList();
  }

  List<Map<String, dynamic>> filterProducts({
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    bool? onlyDiscounted,
  }) {
    return _products.where((product) {
      final price = product['price'] as double;
      final category = product['category'] as String?;
      final discount = product['discount'] as double?;

      if (minPrice != null && price < minPrice) return false;
      if (maxPrice != null && price > maxPrice) return false;
      if (categories != null && category != null && !categories.contains(category)) return false;
      if (onlyDiscounted == true && (discount == null || discount <= 0)) return false;

      return true;
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 