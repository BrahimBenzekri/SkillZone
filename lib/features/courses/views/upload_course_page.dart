import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/error_helper.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/lesson.dart';
import 'package:video_player/video_player.dart';

import '../models/course_type.dart';

class UploadCoursePage extends GetView<CoursesController> {
  const UploadCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final pointsController = TextEditingController();
    
    // For lessons
    final lessonTitleController = TextEditingController();
    
    // RxList to store lessons
    final lessons = <Lesson>[].obs;
    
    // RxBool to track if lesson form is visible
    final isAddingLesson = false.obs;
    
    // RxBool to track if a lesson is currently uploading
    final isUploadingLesson = false.obs;
    
    // RxString to store selected video path
    final selectedVideoPath = ''.obs;
    
    // Observable for course type
    final courseType = Rx<CourseType>(CourseType.soft);
    
    // Calculate total course duration from lessons
    final totalDuration = Rx<Duration>(Duration.zero);
    
    // Update total duration whenever lessons change
    ever(lessons, (_) {
      Duration total = Duration.zero;
      for (var lesson in lessons) {
        total += lesson.duration;
      }
      totalDuration.value = total;
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textColorLight,
                    size: 25,
                  ),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 16,),
                Text(
                  "New Course",
                  style: TextStyle(
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.secondaryColor,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUploadForm(
                    titleController: titleController,
                    descriptionController: descriptionController,
                    priceController: priceController,
                    pointsController: pointsController,
                    courseType: courseType,
                    totalDuration: totalDuration,
                  ),
                  const SizedBox(height: 40),
                  
                  // Lessons Section
                  Text.rich(
                    TextSpan(
                      text: 'Course ',
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Lessons',
                          style: TextStyle(
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.secondaryColor,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Lessons List
                  Obx(() => Column(
                    children: [
                      // Show existing lessons
                      ...lessons.map((lesson) => _buildLessonCard(lesson)),
                      
                      // Show lesson form if adding a lesson
                      if (isAddingLesson.value)
                        _buildLessonForm(
                          lessonTitleController: lessonTitleController,
                          selectedVideoPath: selectedVideoPath,
                          isUploadingLesson: isUploadingLesson,
                          onAddLesson: () {
                            if (lessonTitleController.text.isNotEmpty && 
                                selectedVideoPath.value.isNotEmpty) {
                              // Simulate video upload
                              isUploadingLesson.value = true;
                              
                              Future.delayed(const Duration(seconds: 3), () {
                                // Calculate duration from video (for now using a random value between 5-20 minutes)
                                // In a real app, you would extract this from the video metadata
                                final videoDuration = Duration(minutes: 5 + (DateTime.now().millisecond % 16));
                                
                                // Add the lesson
                                lessons.add(
                                  Lesson(
                                    id: 'l${lessons.length + 1}',
                                    title: lessonTitleController.text,
                                    number: lessons.length + 1,
                                    duration: videoDuration,
                                    videoUrl: selectedVideoPath.value,
                                  ),
                                );
                                
                                // Reset form
                                lessonTitleController.clear();
                                selectedVideoPath.value = '';
                                isUploadingLesson.value = false;
                                
                                // Show success message
                                Get.snackbar(
                                  'Success',
                                  'Lesson added successfully',
                                  backgroundColor: AppColors.primaryColor,
                                  colorText: Colors.white,
                                );
                              });
                            } else {
                              ErrorHelper.showError(title: "Error", message: "Please fill all required fields and select a video");
                            }
                          },
                          onCancel: () {
                            isAddingLesson.value = false;
                            lessonTitleController.clear();
                            selectedVideoPath.value = '';
                          },
                        ),
                      
                      // Add Lesson Button (only show if not currently adding a lesson)
                      if (!isAddingLesson.value)
                        ElevatedButton.icon(
                          onPressed: () => isAddingLesson.value = true,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Lesson'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
                            foregroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          ),
                        ),
                    ],
                  )),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate and upload course
                        if (titleController.text.isEmpty || 
                            descriptionController.text.isEmpty || 
                            pointsController.text.isEmpty) {
                            ErrorHelper.showError(title: "Error", message: "Please fill all required fields!");
                          return;
                        }
                        
                        // Validate price for hard skills
                        if (courseType.value == CourseType.hard && 
                            (priceController.text.isEmpty || int.tryParse(priceController.text) == null)) {
                          ErrorHelper.showError(title: "Error", message: "Please enter a valid price for hard skill courses!");
                          return;
                        }
                        
                        if (lessons.isEmpty) {
                          ErrorHelper.showError(title: "Error", message: "Please add at least one lesson!");
                          return;
                        }
                        
                        // Upload course with calculated duration
                        controller.uploadCourse(
                          title: titleController.text,
                          description: descriptionController.text,
                          duration: totalDuration.value,
                          price: courseType.value == CourseType.hard ? int.tryParse(priceController.text) : null,
                          points: int.tryParse(pointsController.text) ?? 100,
                          type: courseType.value,
                          lessons: lessons.toList(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Upload Course',
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
          ],
        ),
      ),
    );
  }

  Widget _buildUploadForm({
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
    required TextEditingController pointsController,
    required Rx<CourseType> courseType,
    required Rx<Duration> totalDuration,
  }) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Course Title',
              labelStyle: TextStyle(color: AppColors.textColorLight),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textColorLight),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
            ),
            style: const TextStyle(color: AppColors.textColorLight),
            cursorColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 20),
          
          // Course Type Selection
          const Text(
            'Course Type',
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => Row(
            children: [
              // Soft Skills Option
              Expanded(
                child: GestureDetector(
                  onTap: () => courseType.value = CourseType.soft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: courseType.value == CourseType.soft
                          ? AppColors.primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: courseType.value == CourseType.soft
                            ? AppColors.primaryColor
                            : AppColors.textColorInactive,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Soft Skill',
                        style: TextStyle(
                          color: courseType.value == CourseType.soft
                              ? AppColors.primaryColor
                              : AppColors.textColorInactive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Hard Skills Option
              Expanded(
                child: GestureDetector(
                  onTap: () => courseType.value = CourseType.hard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: courseType.value == CourseType.hard
                          ? AppColors.secondaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: courseType.value == CourseType.hard
                            ? AppColors.secondaryColor
                            : AppColors.textColorInactive,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Hard Skill',
                        style: TextStyle(
                          color: courseType.value == CourseType.hard
                              ? AppColors.secondaryColor
                              : AppColors.textColorInactive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(height: 10),
          
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: AppColors.textColorLight),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textColorLight),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
            ),
            style: const TextStyle(color: AppColors.textColorLight),
            cursorColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 20),
          
          // Points and Price Row
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Points field - full width for soft skills, half width for hard skills
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Points field
                  Expanded(
                    child: TextFormField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Points',
                        labelStyle: TextStyle(color: AppColors.textColorLight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColorLight),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                        ),
                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                      ),
                      style: const TextStyle(color: AppColors.textColorLight),
                      cursorColor: AppColors.primaryColor,
                    ),
                  ),
                  
                  // Price field (only for Hard Skills)
                  if (courseType.value == CourseType.hard) ...[
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: AppColors.textColorLight),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColorLight),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                          floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                        ),
                        style: const TextStyle(color: AppColors.textColorLight),
                        cursorColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
              
              // Help text for points
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  courseType.value == CourseType.soft 
                      ? 'Points users will earn by completing this course' 
                      : 'Points required to unlock this course',
                  style: const TextStyle(
                    color: AppColors.textColorInactive,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
  
  Widget _buildLessonForm({
    required TextEditingController lessonTitleController,
    required RxString selectedVideoPath,
    required RxBool isUploadingLesson,
    required VoidCallback onAddLesson,
    required VoidCallback onCancel,
  }) {
    // RxInt to store calculated video duration in minutes
    final calculatedDuration = 0.obs;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Lesson',
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: lessonTitleController,
            decoration: const InputDecoration(
              labelText: 'Lesson Title',
              labelStyle: TextStyle(color: AppColors.textColorLight),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textColorLight),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
            ),
            style: const TextStyle(color: AppColors.textColorLight),
            cursorColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 20),
          
          // Video Upload Section
          const Text(
            'Lesson Video',
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          
          Obx(() => selectedVideoPath.value.isEmpty
            ? Row(
                children: [
                  // Gallery option
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickVideoFromGallery(selectedVideoPath, calculatedDuration),
                      icon: const Icon(Icons.photo_library, size: 18),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
                        foregroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // File option
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickVideoFromFiles(selectedVideoPath, calculatedDuration),
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: const Text('Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor.withValues(alpha: 0.2),
                        foregroundColor: AppColors.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Video: ${selectedVideoPath.value.split('/').last}',
                          style: const TextStyle(
                            color: AppColors.textColorLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textColorLight,
                        ),
                        onPressed: () {
                          selectedVideoPath.value = '';
                          calculatedDuration.value = 0;
                        },
                      ),
                    ],
                  ),
                  // Show calculated duration
                  if (calculatedDuration.value > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Duration: ${calculatedDuration.value} minutes',
                        style: const TextStyle(
                          color: AppColors.textColorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              )
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Obx(() => isUploadingLesson.value
            ? const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Adding lesson...',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (lessonTitleController.text.isNotEmpty && 
                          selectedVideoPath.value.isNotEmpty) {
                        // Call onAddLesson with the calculated duration
                        onAddLesson();
                      } else {
                        ErrorHelper.showError(title: "Error", message: "Please fill all required fields and select a video");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.bottomBarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add Lesson'),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
  
  Widget _buildLessonCard(Lesson lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                lesson.number.toString(),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    color: AppColors.textColorLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${lesson.duration.inMinutes} minutes',
                      style: const TextStyle(
                        color: AppColors.textColorInactive,
                        fontSize: 14,
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
  
  // Method to pick video from gallery
  Future<void> _pickVideoFromGallery(RxString selectedVideoPath, RxInt calculatedDuration) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 30),
      );
      
      if (video != null) {
        selectedVideoPath.value = video.path;
        // Calculate duration
        final videoPlayer =  VideoPlayerController.file(File(video.path));
        await videoPlayer.initialize();
        final duration = videoPlayer.value.duration ;
        calculatedDuration.value = duration.inMinutes;
      }
    } catch (e) {
      ErrorHelper.showError(title: 'Unexpected Error', message: e.toString());
    }
  }
  
  // Method to pick video from files
  Future<void> _pickVideoFromFiles(RxString selectedVideoPath, RxInt calculatedDuration) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        selectedVideoPath.value = result.files.first.path!;
        // Calculate duration
        final videoPlayer =  VideoPlayerController.file(File(result.files.first.path!));
        await videoPlayer.initialize();
        final duration = videoPlayer.value.duration;
        calculatedDuration.value = duration.inMinutes;
      }
    } catch (e) {
      ErrorHelper.showError(title: "Failed to pick video", message: e.toString());
    }
  }
  
}
