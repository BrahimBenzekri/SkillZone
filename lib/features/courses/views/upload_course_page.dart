import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/error_helper.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/lesson.dart';

import '../models/course_type.dart';

class UploadCoursePage extends GetView<CoursesController> {
  const UploadCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    final pointsController = TextEditingController();
    
    // For lessons
    final lessonTitleController = TextEditingController();
    final lessonDurationController = TextEditingController();
    
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
                    durationController: durationController,
                    pointsController: pointsController,
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
                          lessonDurationController: lessonDurationController,
                          selectedVideoPath: selectedVideoPath,
                          isUploadingLesson: isUploadingLesson,
                          onAddLesson: () {
                            if (lessonTitleController.text.isNotEmpty && 
                                lessonDurationController.text.isNotEmpty &&
                                selectedVideoPath.value.isNotEmpty) {
                              // Simulate video upload
                              isUploadingLesson.value = true;
                              
                              Future.delayed(const Duration(seconds: 3), () {
                                // Add the lesson
                                lessons.add(
                                  Lesson(
                                    id: 'l${lessons.length + 1}',
                                    title: lessonTitleController.text,
                                    number: lessons.length + 1,
                                    duration: Duration(
                                      minutes: int.tryParse(lessonDurationController.text) ?? 0
                                    ),
                                    videoUrl: selectedVideoPath.value,
                                  ),
                                );
                                
                                // Reset form
                                lessonTitleController.clear();
                                lessonDurationController.clear();
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
                            lessonDurationController.clear();
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
                            durationController.text.isEmpty ||
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
                        
                        // Upload course
                        controller.uploadCourse(
                          title: titleController.text,
                          description: descriptionController.text,
                          duration: Duration(
                            minutes: int.tryParse(durationController.text) ?? 0
                          ),
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
    required TextEditingController durationController,
    required TextEditingController pointsController,
  }) {
    // Create an observable for course type selection
    final courseType = Rx<CourseType>(CourseType.soft);
    
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
          
          // Points and Duration Row
          Row(
            children: [
              // Points field (1/3 width)
              SizedBox(
                width: MediaQuery.of(Get.context!).size.width * 0.28,
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
              const SizedBox(width: 20),
              // Duration field
              Expanded(
                child: TextFormField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
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
          ),
          
          // Price field (only for Hard Skills)
          Obx(() => courseType.value == CourseType.hard
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
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
                ],
              )
            : const SizedBox.shrink()
          ),
        ],
      ),
    );
  }
  
  Widget _buildLessonForm({
    required TextEditingController lessonTitleController,
    required TextEditingController lessonDurationController,
    required RxString selectedVideoPath,
    required RxBool isUploadingLesson,
    required VoidCallback onAddLesson,
    required VoidCallback onCancel,
  }) {
    
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
          const SizedBox(height: 16),
          TextFormField(
            controller: lessonDurationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
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
                      onPressed: () => _pickVideoFromGallery(selectedVideoPath),
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
                      onPressed: () => _pickVideoFromFiles(selectedVideoPath),
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
            : Row(
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
                    onPressed: () => selectedVideoPath.value = '',
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
                    onPressed: onAddLesson,
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
  Future<void> _pickVideoFromGallery(RxString selectedVideoPath) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 30),
      );
      
      if (video != null) {
        selectedVideoPath.value = video.path;
      }
    } catch (e) {
      ErrorHelper.showError(title: 'Unexpected Error', message: e.toString());
    }
  }
  
  // Method to pick video from files
  Future<void> _pickVideoFromFiles(RxString selectedVideoPath) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        selectedVideoPath.value = result.files.first.path!;
      }
    } catch (e) {
      ErrorHelper.showError(title: "Failed to pick video", message: e.toString());
    }
  }
  
}
