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
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('lib/assets/images/cubes_background.png',
            repeat: ImageRepeat.repeat,
            )),
          SafeArea(
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
                      children: [
                        // Timer and Progress
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Obx(() => Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.symmetric(horizontal: MediaQueryHelper.getScreenWidth(context)/6),
                              height: 35,
                              decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color:AppColors.textColorInactive,
                                            width: 3,
                                          ),
                                        ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: controller.progress.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.secondaryColor,
                                        AppColors.primaryColor,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                            Obx(() => Text(
                              '${controller.timeLeft.value}',
                              style: const TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 16,
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 32),
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
                              ),
                              textAlign: TextAlign.center,
                            )),
                        const Spacer(),
          
                        // Options
                        SizedBox(
                          height: MediaQueryHelper.getScreenHeight(context) * 0.4,
                          child: ListView.separated(
                            itemCount: controller.currentQuestion?.options.length ?? 0,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              
                              return Obx(() {  // Wrap the GestureDetector with Obx
                                final option =
                                    controller.currentQuestion?.options[index] ?? '';
                                final isSelected =
                                    controller.selectedOptionIndex.value == index;
                                return GestureDetector(
                                  onTap: () => controller.selectOption(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.secondaryColor
                                            : AppColors.textColorInactive,
                                        width: 3,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              color:AppColors.textColorLight,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        isSelected ?
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.secondaryColor,
                                            size: 24,
                                          )
                                          : Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.textColorInactive,
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        const Spacer(),
          
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
                                  backgroundColor: isButtonEnabled ? AppColors.secondaryColor : AppColors.textColorInactive,
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
        ],
      ),
    );
  }
}
