import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../models/lesson.dart';

class LessonVideoPage extends StatefulWidget {

  const LessonVideoPage({super.key});

  @override
  State<LessonVideoPage> createState() => _LessonVideoPageState();
}

class _LessonVideoPageState extends State<LessonVideoPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final Lesson lesson = Get.arguments['lesson'];
  final String courseId = Get.arguments['courseId'] ?? '';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      
      _videoPlayerController = VideoPlayerController.asset('lib/assets/videos/output.mp4');
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primaryColor,
          handleColor: AppColors.primaryColor,
          backgroundColor: AppColors.bottomBarColor,
          bufferedColor: AppColors.textColorInactive,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.textColorInactive,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: AppColors.textColorInactive,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load video. Please try again later.';
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textColorLight,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Lesson ${lesson.number}',
          style: const TextStyle(
            color: AppColors.textColorLight,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.textColorInactive,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.textColorInactive,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Chewie(controller: _chewieController!),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson Title
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Duration
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: AppColors.textColorInactive,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${lesson.duration.inMinutes} minutes',
                          style: const TextStyle(
                            color: AppColors.textColorInactive,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Notes Section
                    const Text(
                      'Your Notes',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      maxLines: 5,
                      style: const TextStyle(color: AppColors.textColorLight),
                      decoration: InputDecoration(
                        hintText: 'Take notes while watching...',
                        hintStyle: const TextStyle(
                          color: AppColors.textColorInactive,
                        ),
                        filled: true,
                        fillColor: AppColors.bottomBarColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Mark as Complete Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          log('DEBUG: Mark as Complete button pressed');
                          
                          // Mark the lesson as completed
                          inventoryController.markLessonAsCompleted(courseId, lesson.id);
                          
                          log('DEBUG: Showing snackbar and navigating back');
                          
                          // Show success message
                          Get.snackbar(
                            'Lesson Completed',
                            'Great job! You\'ve completed this lesson.',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(16),
                          );
                          
                          // Navigate back
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Mark as Complete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorLight
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
