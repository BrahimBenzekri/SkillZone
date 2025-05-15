import 'package:get/get.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/services/storage_service.dart';

class UserPointsService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final points = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load points from storage
    points.value = _storageService.read<int>(StorageService.userPointsKey) ?? 0;
  }

  // Add points (when completing courses, quizzes, etc.)
  Future<void> addPoints(int amount) async {
    points.value += amount;
    final response = await EnvConfig.apiService.post(
      EnvConfig.updatePoints,
      {
        'points': points.value,
      },
    );
    if (response.statusCode != 200) {
      throw 'Failed to update points: ${response.body}';
    }
    await _savePoints();
  }

  // Deduct points (when purchasing courses)
  Future<bool> deductPoints(int amount) async {
    if (points.value >= amount) {
      points.value -= amount;
      await _savePoints();
      return true;
    }
    return false;
  }

  // Update points to a specific value (e.g., from API response)
  Future<void> updatePoints(int newPointsValue) async {
    points.value = newPointsValue;
    await _savePoints();
  }

  // Save points to persistent storage
  Future<void> _savePoints() async {
    await _storageService.savePoints(points.value);
  }

  // Check if user has enough points
  bool hasEnoughPoints(int amount) {
    return points.value >= amount;
  }
}
