import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  
  static String get apiUrl => '$apiBaseUrl/users';
  static String get loginEndpoint => '$apiUrl/login/';
  static String get registerEndpoint => '$apiUrl/register/';
  static String get verifyEmail => '$apiUrl/verify-email/';
  static String get logout => '$apiUrl/logout/';
}