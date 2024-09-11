import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginProvider with ChangeNotifier {
  Dio dio = Dio();
  String? _token;
  String? _error;

  final FlutterSecureStorage secureStorage =
      const FlutterSecureStorage(); // Initialize secure storage

  String? get token => _token;
  String? get error => _error;

  // Function to handle login logic
  Future<bool> login(String email, String password) async {
    const url = 'https://reqres.in/api/login';
    try {
      log('Attempting to log in...');
      Response response = await dio.post(url, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        _token = response.data['token'];
        log('Login successful. Token: $_token');

        try {
          // Save the token to Flutter Secure Storage
          await secureStorage.write(key: 'auth_token', value: _token);
        } catch (e) {
          log('Error saving token to secure storage: $e');
          _error = 'Error saving token';
          notifyListeners();
          return false;
        }

        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid login credentials';
        log('Login failed. Invalid credentials');
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        _error = 'Invalid login credentials';
        log('Error: Invalid credentials');
      } else {
        _error = 'An error occurred: ${e.message}';
        log('Error: ${e.message}');
      }
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      log('Unexpected error: $e');
      notifyListeners();
      return false;
    }
  }
}
