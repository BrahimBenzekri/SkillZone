import 'package:get/get.dart';
import 'dart:async';
import '../models/quiz.dart';
import '../models/quiz_question.dart';
import 'package:skillzone/core/utils/error_helper.dart';

class QuizController extends GetxController {
  static final Map<String, Quiz> _quizzes = {
    's1': Quiz(
      id: 's1q',
      courseId: 's1',
      title: 'Effective Communication Skills Quiz',
      timePerQuestion: const Duration(seconds: 30),
      questions: [
        QuizQuestion(
          id: 's1q1',
          question: 'What is the most important element of active listening?',
          options: ['Speaking clearly', 'Making eye contact', 'Providing feedback', 'Taking notes'],
          correctOptionIndex: 2,
          points: 20,
        ),
        QuizQuestion(
          id: 's1q2',
          question: 'Which of these is a barrier to effective communication?',
          options: ['Cultural differences', 'Clear message', 'Active listening', 'Open body language'],
          correctOptionIndex: 0,
          points: 25,
        ),
        QuizQuestion(
          id: 's1q3',
          question: 'What percentage of communication is non-verbal?',
          options: ['30%', '55%', '65%', '93%'],
          correctOptionIndex: 3,
          points: 30,
        ),
        QuizQuestion(
          id: 's1q4',
          question: 'Which is NOT a component of non-verbal communication?',
          options: [
            'Facial expressions',
            'Written words',
            'Gestures',
            'Posture'
          ],
          correctOptionIndex: 1,
          points: 35,
        ),
        QuizQuestion(
          id: 's1q5',
          question: 'What is the purpose of mirroring in communication?',
          options: [
            'To mock the other person',
            'To build rapport',
            'To show disagreement',
            'To end the conversation'
          ],
          correctOptionIndex: 1,
          points: 40,
        ),
        QuizQuestion(
          id: 's1q6',
          question: 'Which communication style is most effective in a crisis?',
          options: [
            'Passive',
            'Aggressive',
            'Assertive',
            'Passive-aggressive'
          ],
          correctOptionIndex: 2,
          points: 45,
        ),
        QuizQuestion(
          id: 's1q7',
          question: 'What is the primary purpose of feedback in communication?',
          options: [
            'To criticize',
            'To improve understanding',
            'To waste time',
            'To show authority'
          ],
          correctOptionIndex: 1,
          points: 50,
        ),
        QuizQuestion(
          id: 's1q8',
          question: 'Which factor most affects message interpretation?',
          options: [
            'Time of day',
            'Weather',
            'Personal context',
            'Room temperature'
          ],
          correctOptionIndex: 2,
          points: 55,
        ),
        QuizQuestion(
          id: 's1q9',
          question: 'What is the best way to handle communication conflicts?',
          options: [
            'Avoid them completely',
            'Address them immediately',
            'Ignore them',
            'Complain to others'
          ],
          correctOptionIndex: 1,
          points: 60,
        ),
        QuizQuestion(
          id: 's1q10',
          question: 'Which is a characteristic of effective written communication?',
          options: ['Using complex vocabulary', 'Being concise and clear', 'Writing long paragraphs', 'Using multiple fonts'],
          correctOptionIndex: 1,
          points: 65,
        ),
      ],
    ),
    'h1': Quiz(
      id: 'h1q',
      courseId: 'h1',
      title: 'Flutter Advanced Concepts Quiz',
      timePerQuestion: const Duration(seconds: 30),
      questions: [
        QuizQuestion(
          id: 'h1q1',
          question: 'What is the main advantage of using GetX for state management?',
          options: [
            'Larger app size',
            'More boilerplate code',
            'Simplified state management',
            'Slower performance'
          ],
          correctOptionIndex: 2,
          points: 30, // Starting with easier question
        ),
        QuizQuestion(
          id: 'h1q2',
          question: 'Which widget should you use for better performance with large lists?',
          options: [
            'ListView',
            'ListView.builder',
            'Column',
            'SingleChildScrollView'
          ],
          correctOptionIndex: 1,
          points: 40,
        ),
        QuizQuestion(
          id: 'h1q3',
          question: 'What is the purpose of the "const" constructor in Flutter?',
          options: [
            'Slower widget building',
            'Compile-time constant widgets',
            'Larger memory usage',
            'Dynamic widget updates'
          ],
          correctOptionIndex: 1,
          points: 45,
        ),
        QuizQuestion(
          id: 'h1q4',
          question: 'Which is NOT a Flutter widget lifecycle method?',
          options: [
            'initState',
            'build',
            'dispose',
            'onCreate'
          ],
          correctOptionIndex: 3,
          points: 50,
        ),
        QuizQuestion(
          id: 'h1q5',
          question: 'What is the purpose of CustomPainter in Flutter?',
          options: [
            'Managing state',
            'Custom drawing and graphics',
            'Network requests',
            'Database operations'
          ],
          correctOptionIndex: 1,
          points: 55,
        ),
        QuizQuestion(
          id: 'h1q6',
          question: 'Which statement about Keys in Flutter is correct?',
          options: [
            'They slow down the app',
            'They help Flutter track widget state',
            'They are always required',
            'They increase app size'
          ],
          correctOptionIndex: 1,
          points: 60,
        ),
        QuizQuestion(
          id: 'h1q7',
          question: 'What is the main purpose of the BuildContext?',
          options: [
            'Store data',
            'Handle user input',
            'Locate widgets in the widget tree',
            'Manage animations'
          ],
          correctOptionIndex: 2,
          points: 65,
        ),
        QuizQuestion(
          id: 'h1q8',
          question: 'Which is the best practice for handling large images in Flutter?',
          options: [
            'Always use full resolution',
            'Cache images',
            'Load all images at startup',
            'Avoid using images'
          ],
          correctOptionIndex: 1,
          points: 70,
        ),
        QuizQuestion(
          id: 'h1q9',
          question: 'What is the purpose of the "mounted" property?',
          options: [
            'Check if widget is visible',
            'Check if widget is in widget tree',
            'Check widget size',
            'Check widget color'
          ],
          correctOptionIndex: 1,
          points: 75,
        ),
        QuizQuestion(
          id: 'h1q10',
          question: 'Which method is called when a GetX controller is removed from memory?',
          options: [
            'onDelete',
            'dispose',
            'onClose',
            'onRemove'
          ],
          correctOptionIndex: 2,
          points: 80, // Most difficult question
        ),
      ],
    ),
  };

  // Observable variables
  final currentQuiz = Rx<Quiz?>(null);
  final currentQuestionIndex = 0.obs;
  final selectedOptionIndex = (-1).obs;
  final timeLeft = 0.obs;
  final progress = 0.0.obs;
  final score = 0.obs;
  final answers = <int>[].obs;
  
  Timer? _timer;
  
  QuizQuestion? get currentQuestion =>
      currentQuiz.value?.questions[currentQuestionIndex.value];
      
  bool get isLastQuestion =>
      currentQuestionIndex.value == (currentQuiz.value?.questions.length ?? 1) - 1;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startQuiz(String courseId) {
    currentQuiz.value = getQuizForCourse(courseId);
    if (currentQuiz.value == null) return;
    
    currentQuestionIndex.value = 0;
    score.value = 0;
    answers.clear();
    startTimer();
  }

  void startTimer() {
    timeLeft.value = currentQuiz.value?.timePerQuestion.inSeconds ?? 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
        progress.value = timeLeft.value / (currentQuiz.value?.timePerQuestion.inSeconds ?? 30);
      } else {
        nextQuestion();
      }
    });
  }

  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  void nextQuestion() {
    // Store answer and update score
    answers.add(selectedOptionIndex.value);
    if (selectedOptionIndex.value == currentQuestion?.correctOptionIndex) {
      score.value += currentQuestion?.points ?? 0;
    }

    // Reset selection
    selectedOptionIndex.value = -1;

    // Move to next question or finish quiz
    if (isLastQuestion) {
      finishQuiz();
    } else {
      currentQuestionIndex.value++;
      startTimer();
    }
  }

  void finishQuiz() {
    _timer?.cancel();
    Get.offNamed('/quiz-results');
  }

  Quiz? getQuizForCourse(String courseId) {
    return _quizzes[courseId];
  }

  void showWarningSnackbar() {
    ErrorHelper.showValidationError(
      message: "Please select an option.",
    );
  }
}
