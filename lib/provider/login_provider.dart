import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  Dio dio = Dio(); // Create a Dio instance
  String? _token;
  String? _error;

  String? get token => _token;
  String? get error => _error;

  // Function to handle login logic
  Future<bool> login(String email, String password) async {
    const url = 'https://reqres.in/api/login';
    try {
      log('Attempting to log in...'); // Log the start of the login attempt
      Response response = await dio.post(url, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        _token = response.data['token'];
        log('Login successful. Token: $_token'); // Log success
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid login credentials';
        log('Login failed. Invalid credentials'); // Log failure
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        _error = 'Invalid login credentials';
        log('Error: Invalid credentials'); // Log error
      } else {
        _error = 'An error occurred: ${e.message}';
        log('Error: ${e.message}'); // Log error
      }
      notifyListeners();
      return false;
    }
  }
}
