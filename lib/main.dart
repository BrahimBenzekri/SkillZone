import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/features/profile/services/user_profile_service.dart';
import 'package:skillzone/core/services/api_service.dart';
import 'package:skillzone/core/services/storage_service.dart';

Future<void> main() async {
  // Initialize services
  await Get.putAsync(() => StorageService().init(), permanent: true);
  await dotenv.load(fileName: ".env");
  await Get.putAsync(() => ApiService().init(), permanent: true);

  Get.put(UserProfileService(), permanent: true);
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
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
