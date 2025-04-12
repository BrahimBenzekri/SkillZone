import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/media_query_helper.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import '../controllers/quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizController controller = Get.find();

  QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textColorLight,
                    ),
                    onPressed: () {
                      controller.onClose();
                      Get.back();
                    },
                  ),
                  const Expanded(child: SizedBox(width: 8)),
                  const Text(
                        "Quizly",
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  const Expanded(child: SizedBox(width: 8)),
                  const NotificationIcon(isThereNotification: true),
                  const SizedBox(width: 12,)
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Timer and Progress
                    Obx(() => LinearProgressIndicator(
                          value: controller.progress.value,
                          backgroundColor: AppColors.textColorInactive.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          '${controller.timeLeft.value} seconds',
                          style: const TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 16,
                          ),
                        )),
                    const SizedBox(height: 24),

                    // Question Counter
                    Row(
                      children: [
                        Obx(() => Text(
                              'Question ${controller.currentQuestionIndex.value + 1}',
                              style: const TextStyle(
                                color: AppColors.textColorInactive,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const Text("/10", style: TextStyle(color: AppColors.textColorInactive, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Question
                    Obx(() => Text(
                          controller.currentQuestion?.question ?? '',
                          style: const TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 32),

                    // Options
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.currentQuestion?.options.length ?? 0,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final option =
                              controller.currentQuestion?.options[index] ?? '';
                          
                          return Obx(() {  // Wrap the GestureDetector with Obx
                            final isSelected =
                                controller.selectedOptionIndex.value == index;
                            return GestureDetector(
                              onTap: () => controller.selectOption(index),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.bottomBarColor,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.backgroundColor
                                              : AppColors.textColorLight,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.backgroundColor,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),

                    // Next Button
                    Obx(() {
                      final isButtonEnabled =
                          controller.selectedOptionIndex.value != -1;
                      return SizedBox(
                          width: MediaQueryHelper.getScreenWidth(context)*60/100,
                          child: ElevatedButton(
                            onPressed: isButtonEnabled
                                ? controller.nextQuestion
                                : controller.showWarningSnackbar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonEnabled ? AppColors.primaryColor : AppColors.textColorInactive,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              controller.isLastQuestion ? 'Finish' : 'Next Question',
                              style: const TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
