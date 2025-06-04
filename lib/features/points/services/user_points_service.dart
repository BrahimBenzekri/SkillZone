import 'dart:developer';

import 'package:get/get.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/services/storage_service.dart';

class UserPointsService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final points = 0.obs;

  @override
  void onInit() {
    log('DEBUG: UserPointsService - onInit called');
    super.onInit();
    // Load points from storage
    points.value = _storageService.read<int>(StorageService.userPointsKey) ?? 0;
    log('DEBUG: UserPointsService - Loaded points from storage: ${points.value}');
  }

  // Add points (when completing courses, quizzes, etc.)
  Future<void> addPoints(int amount) async {
    log('DEBUG: UserPointsService - addPoints called with amount: $amount');
    log('DEBUG: UserPointsService - Current points before adding: ${points.value}');

    log('DEBUG: UserPointsService - Sending API request to update points');
    final response = await EnvConfig.apiService.post(
      EnvConfig.updatePoints,
      {
        'points': amount,
      },
    );

    log('DEBUG: UserPointsService - API response status code: ${response.statusCode}');
    if (response.statusCode != 200) {
      log('ERROR: UserPointsService - Failed to update points: ${response.body}');
      throw 'Failed to update points: ${response.body}';
    }

    log('DEBUG: UserPointsService - API response body: ${response.body}');
    final newPoints = response.body['data']['points'];
    log('DEBUG: UserPointsService - New points value from API: $newPoints');

    await updatePoints(newPoints);
    log('DEBUG: UserPointsService - Points updated successfully');
  }

  // Deduct points (when purchasing courses)
  Future<bool> deductPoints(int amount) async {
    log('DEBUG: UserPointsService - deductPoints called with amount: $amount');
    log('DEBUG: UserPointsService - Current points before deduction: ${points.value}');

    if (points.value >= amount) {
      log('DEBUG: UserPointsService - User has enough points, deducting $amount points');
      points.value -= amount;
      await _savePoints();
      log('DEBUG: UserPointsService - Points deducted successfully, new balance: ${points.value}');
      return true;
    }

    log('DEBUG: UserPointsService - Not enough points for deduction, required: $amount, available: ${points.value}');
    return false;
  }

  // Update points to a specific value (e.g., from API response)
  Future<void> updatePoints(int newPointsValue) async {
    log('DEBUG: UserPointsService - updatePoints called with new value: $newPointsValue');
    log('DEBUG: UserPointsService - Current points before update: ${points.value}');

    points.value = newPointsValue;
    log('DEBUG: UserPointsService - Points value updated in memory');

    await _savePoints();
    log('DEBUG: UserPointsService - Points saved to storage successfully');
  }

  // Save points to persistent storage
  Future<void> _savePoints() async {
    log('DEBUG: UserPointsService - _savePoints called with value: ${points.value}');
    await _storageService.write(StorageService.userPointsKey, points.value);
    log('DEBUG: UserPointsService - Points saved to storage');
  }

  // Check if user has enough points
  bool hasEnoughPoints(int amount) {
    log('DEBUG: UserPointsService - hasEnoughPoints called with amount: $amount');
    final result = points.value >= amount;
    log('DEBUG: UserPointsService - User has enough points: $result (required: $amount, available: ${points.value})');
    return result;
  }
}
