import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/routes/app_pages.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Oddval',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(fontWeight: FontWeight.w600),
          bodySmall: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      initialRoute: AppRoutes.main,
      // onInit: () {
      //   // Initialize and start quiz for Flutter Advanced Concepts course
      //   final quizController = Get.put(QuizController());
      //   quizController.startQuiz('h1');
      // },
      getPages: AppPages.pages,
    );
  }
}
