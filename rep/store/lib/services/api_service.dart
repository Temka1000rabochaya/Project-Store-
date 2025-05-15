import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  final Dio _dio = Dio();
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Аутентификация
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await _dio.post('$baseUrl/auth/register',
          data: {'email': email, 'password': password, 'name': name});
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/auth/login',
          data: {'email': email, 'password': password});
      
      if (response.data['token'] != null) {
        await _setToken(response.data['token']);
      }
      
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Продукты
  Future<List<dynamic>> getProducts() async {
    try {
      final token = await _getToken();
      final response = await _dio.get('$baseUrl/products',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    final response = await http.get(Uri.parse('$baseUrl/products/barcode/$barcode'));
    return jsonDecode(response.body);
  }

  // Корзина
  Future<Map<String, dynamic>> getCart() async {
    try {
      final token = await _getToken();
      final response = await _dio.get('$baseUrl/cart',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final token = await _getToken();
      await _dio.post('$baseUrl/cart/add',
          data: {'productId': productId, 'quantity': quantity},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      final token = await _getToken();
      await _dio.delete('$baseUrl/cart/remove/$productId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Профиль
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _getToken();
      final response = await _dio.get('$baseUrl/profile',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        return Exception(error.response?.data['message'] ?? 'An error occurred');
      }
      return Exception(error.message ?? 'Network error occurred');
    }
    return Exception('An unexpected error occurred');
  }
} 