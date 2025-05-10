import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../widgets/custom_text_field.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool saveCard = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/cubes_background.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textColorLight,
                      size: 25,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView(
                      children: [
                        const Center(
                          child: Text(
                            'Card\nInformation',
                            style: TextStyle(
                              color: AppColors.textColorLight,
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const CustomTextField(
                          label: 'Card Number',
                          hintText: '1234 5678 9012 3456',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        const CustomTextField(
                          label: 'Cardholder Name',
                          hintText: 'John Doe',
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Expiry Date',
                                hintText: 'MM/YY',
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: CustomTextField(
                                label: 'CVV',
                                hintText: '123',
                                keyboardType: TextInputType.number,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Obx(() => Transform.scale(
                                  scale: 1.2, // Makes the checkbox 20% bigger
                                  child: Checkbox(
                                    value: saveCard.value,
                                    onChanged: (value) => saveCard.value = value!,
                                    fillColor: WidgetStateProperty.resolveWith(
                                        (states) =>
                                            states.contains(WidgetState.selected)
                                                ? AppColors.primaryColor
                                                : AppColors.textColorLight),
                                    checkColor: AppColors.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4), // Slightly rounded corners
                                    ),
                                    side: BorderSide.none, // Removes the border
                                  ),
                                )),
                            const Text(
                              'Save this card',
                              style: TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add card logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Add Card',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
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
