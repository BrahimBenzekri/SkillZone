import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserPointsService extends GetxService {
  static const String pointsKey = 'user_points';
  final _storage = GetStorage();
  final points = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load points from storage
    points.value = _storage.read(pointsKey) ?? 0;
  }

  // Add points (when completing courses, quizzes, etc.)
  Future<void> addPoints(int amount) async {
    points.value += amount;
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

  // Save points to persistent storage
  Future<void> _savePoints() async {
    await _storage.write(pointsKey, points.value);
  }

  // Check if user has enough points
  bool hasEnoughPoints(int amount) {
    return points.value >= amount;
  }
}