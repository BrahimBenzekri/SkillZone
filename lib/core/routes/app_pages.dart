
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/features/auth/views/email_verification_page.dart';
import 'package:skillzone/features/auth/views/login_page.dart';
import 'package:skillzone/features/auth/views/signup_page.dart';
import 'package:skillzone/features/courses/views/course_details_page.dart';
import 'package:skillzone/features/courses/views/lesson_video_page.dart';
import 'package:skillzone/features/home/views/home_page.dart';
import 'package:skillzone/features/interests/views/intrests_page.dart';
import 'package:skillzone/features/navigation/views/main_screen.dart';
import 'package:skillzone/features/notifications/views/notifications_page.dart';
import 'package:skillzone/features/onboarding/views/onboarding_screen.dart';
import 'package:skillzone/features/onboarding/views/welcome_page.dart';
import 'package:skillzone/features/points/views/points_page.dart';
import 'package:skillzone/features/profile/views/profile_page.dart';
import 'package:skillzone/features/quiz/controllers/quiz_controller.dart';
import 'package:skillzone/features/quiz/views/quiz_page.dart';
import 'package:skillzone/features/quiz/views/quiz_results_page.dart';
import 'package:skillzone/features/search/views/search_page.dart';
import 'package:skillzone/features/splash/views/splash_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    // Auth Pages
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupPage(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => EmailVerificationPage(),
    ),
    GetPage(
      name: AppRoutes.interests,
      page: () => InterestsPage(),
    ),

    // Main App Pages
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
    ),
    GetPage(
      name: AppRoutes.points,
      page: () => PointsPage(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
    ),

    // Course Pages
    GetPage(
      name: AppRoutes.courseDetails,
      page: () => CourseDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.lessonVideo,
      page: () => const LessonVideoPage(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => QuizPage(),
      binding: BindingsBuilder(() {
        Get.put(QuizController());
      }),
    ),
    GetPage(
      name: AppRoutes.quizResults,
      page: () => const QuizResultsPage(),
    ),
  ];
}

