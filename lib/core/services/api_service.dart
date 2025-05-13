
import 'dart:developer';
import 'package:get/get.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class ApiService extends GetxService {
  final GetConnect _connect = GetConnect();
  
  // Initialize with default timeout and retry policy
  Future<ApiService> init() async {
    _connect.timeout = const Duration(seconds: 30);
    _connect.maxAuthRetries = 3;
    return this;
  }
  
  // Get auth headers with token if available
  Map<String, String> _getHeaders({bool requiresAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (requiresAuth) {
      try {
        final authController = Get.find<AuthController>();
        final token = authController.accessToken;
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        log('DEBUG: Auth controller not found or token not available');
      }
    }
    
    return headers;
  }
  
  // GET request
  Future<Response> get(String url, {bool requiresAuth = true}) async {
    log('DEBUG: GET request to $url');
    return await _connect.get(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
  }
  
  // POST request
  Future<Response> post(String url, dynamic body, {bool requiresAuth = true}) async {
    log('DEBUG: POST request to $url');
    return await _connect.post(
      url,
      body,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
  }
  
  // PUT request
  Future<Response> put(String url, dynamic body, {bool requiresAuth = true}) async {
    log('DEBUG: PUT request to $url');
    return await _connect.put(
      url,
      body,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
  }
  
  // DELETE request
  Future<Response> delete(String url, {bool requiresAuth = true}) async {
    log('DEBUG: DELETE request to $url');
    return await _connect.delete(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
  }
}

