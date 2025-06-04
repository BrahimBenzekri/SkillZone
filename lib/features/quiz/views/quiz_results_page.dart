import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/media_query_helper.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import '../controllers/quiz_controller.dart';

class QuizResultsPage extends GetView<QuizController> {
  const QuizResultsPage({super.key});

  String getEncouragementMessage(double percentage) {
    if (percentage >= 80) {
      return "Outstanding performance! Keep up the excellent work! 🌟";
    } else if (percentage >= 60) {
      return "Good job! You're making great progress! 👏";
    } else if (percentage >= 40) {
      return "Nice effort! Keep practicing to improve! 💪";
    } else {
      return "Don't give up! Every attempt is a learning opportunity! 🎯";
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = controller.currentQuiz.value!;
    final totalPoints = quiz.questions.fold<int>(0, (sum, q) => sum + q.points);
    final percentage = (controller.score.value / totalPoints) * 100;

    // Add an observable for loading state
    final isLoading = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/cubes_background.png',
              repeat: ImageRepeat.repeat,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textColorLight,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(child: SizedBox(width: 8)),
                      const Text(
                        "Quiz Results",
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox(width: 8)),
                      const NotificationIcon(isThereNotification: true),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                // Results Table
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                AppColors.bottomBarColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Table(
                            border: TableBorder.all(
                              color: AppColors.textColorInactive
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            children: [
                              // Table Header
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.bottomBarColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Questions',
                                        style: TextStyle(
                                          color: AppColors.textColorLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Results',
                                        style: TextStyle(
                                          color: AppColors.textColorLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Points',
                                        style: TextStyle(
                                          color: AppColors.textColorLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Table Rows
                              ...List.generate(
                                quiz.questions.length,
                                (index) {
                                  final question = quiz.questions[index];
                                  final isCorrect = controller.answers[index] ==
                                      question.correctOptionIndex;
                                  return TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            '#${index + 1}',
                                            style: const TextStyle(
                                              color: AppColors.textColorLight,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            isCorrect
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: isCorrect
                                                ? AppColors.primaryColor
                                                : AppColors.errorColor,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            isCorrect
                                                ? '+${question.points}'
                                                : '0',
                                            style: TextStyle(
                                              color: isCorrect
                                                  ? AppColors.primaryColor
                                                  : AppColors.textColorInactive,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Points Earned Text
                        Obx(() => Text.rich(TextSpan(
                                text: 'You earned ',
                                style: const TextStyle(
                                  color: AppColors.textColorLight,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${controller.score} points',
                                    style: const TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]))),
                        const SizedBox(height: 8),
                        Text(
                          getEncouragementMessage(percentage),
                          style: const TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Claim Button
                        Container(
                          width: MediaQueryHelper.getScreenWidth(context) *
                              60 /
                              100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Obx(() => ElevatedButton(
                                onPressed: isLoading.value
                                    ? null
                                    : () async {
                                        isLoading.value = true;
                                        await controller.finishQuiz();
                                        isLoading.value = false;
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 4,
                                ),
                                child: isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.backgroundColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Claim Points',
                                        style: TextStyle(
                                          color: AppColors.backgroundColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
