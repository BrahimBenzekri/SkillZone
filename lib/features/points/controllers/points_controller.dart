import 'package:get/get.dart';
import '../models/level.dart';

class PointsController extends GetxController {
  final points = 0.obs;
  final currentLevel = Rx<Level?>(null);

  final List<Level> levels = const [
    Level(
      id: 1,
      name: "Rookie",
      requiredPoints: 0,
      badge: "lib/assets/images/badge1.png",
      description:
          "Every expert was once a beginner. Your journey starts here!",
    ),
    Level(
      id: 2,
      name: "Explorer",
      requiredPoints: 100,
      badge: "lib/assets/images/badge2.png",
      description: "Discovering new horizons. Keep pushing forward!",
    ),
    Level(
      id: 3,
      name: "Achiever",
      requiredPoints: 300,
      badge: "lib/assets/images/badge3.png",
      description:
          "Your dedication is paying off! You're becoming unstoppable!",
    ),
    Level(
      id: 4,
      name: "Master",
      requiredPoints: 600,
      badge: "lib/assets/images/badge4.png",
      description:
          "Excellence is not a destination; it's a continuous journey.",
    ),
    Level(
      id: 5,
      name: "Expert",
      requiredPoints: 1000,
      badge: "lib/assets/images/badge5.png",
      description: "You've reached the TOP! Keep learning and growing.",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // todo: Fetch actual points from your backend/storage
    points.value = 250; // Example initial points
    _updateLevel();

    ever(points, (_) => _updateLevel());
  }

  void _updateLevel() {
    currentLevel.value = levels.lastWhere(
      (level) => points.value >= level.requiredPoints,
      orElse: () => levels.first,
    );
  }

  Level get nextLevel {
    int nextLevelIndex = levels.indexOf(currentLevel.value!) + 1;
    return nextLevelIndex < levels.length
        ? levels[nextLevelIndex]
        : currentLevel.value!;
  }

  double get levelProgress {
    if (currentLevel.value == levels.last) return 1.0;

    int pointsInCurrentLevel =
        points.value - currentLevel.value!.requiredPoints;
    int pointsNeededForNextLevel =
        nextLevel.requiredPoints - currentLevel.value!.requiredPoints;

    return pointsInCurrentLevel / pointsNeededForNextLevel;
  }

  int get pointsToNextLevel => currentLevel.value == levels.last
      ? 0
      : nextLevel.requiredPoints - points.value;
}
