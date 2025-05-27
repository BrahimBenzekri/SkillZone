import 'dart:developer';

import 'package:get/get.dart';
import 'course_type.dart';
import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final double rating;
  final Duration duration;
  final CourseType type;
  final String price; // null means free
  final int points; // points earned when completing the course quiz
  final int pointsRequired; // points required to unlock the course
  final RxBool isLiked;
  final String thumbnail;
  List<Lesson> lessons;
  double? progress;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.type,
    required this.price,
    required this.points,
    required this.pointsRequired,
    bool isLiked = false,
    required this.thumbnail,
    this.lessons = const [],
    this.progress,
  }) : isLiked = isLiked.obs;

  int get completedLessons =>
      lessons.where((lesson) => lesson.isCompleted).length;
  int get totalLessons => lessons.length;
  double get courseProgress =>
      totalLessons > 0 ? completedLessons / totalLessons : 0.0;

  // Convert duration to readable format
  String get durationText {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }

  String get durationTextDetailed {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  // Get price or points text
  String get accessText {
    if (type == CourseType.soft) {
      return 'Free • Earn $points points';
    } else {
      if (price == "0.00") {
        return '\$$price';
      } else {
        return '${points.toString()} points';
      }
    }
  }

  // Create from JSON for API communication
  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['id'] == null) {
        throw ArgumentError('Course ID is required');
      }

      if (json['title'] == null) {
        throw ArgumentError('Course title is required');
      }

      // Extract course type with better error handling
      CourseType courseType;
      final typeStr = json['course_type'];
      courseType = typeStr.toUpperCase().contains('HARD')
          ? CourseType.hard
          : CourseType.soft;

      return Course(
        id: json['id'].toString(),
        title: json['title'],
        description: json['description'],
        rating: json['rating'],
        duration: Duration(minutes: json['duration']),
        type: courseType,
        price: json['price'],
        points: json['points'],
        pointsRequired: json['points_required'],
        isLiked: false,
        thumbnail: '',
        lessons: [],
      );
    } catch (e) {
      log('ERROR: Exception in Course.fromJson: $e');
      rethrow; // Rethrow to be caught by the calling method
    }
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    double? rating,
    Duration? duration,
    CourseType? type,
    String? price,
    int? points,
    int? pointsRequired,
    bool? isLiked,
    String? thumbnail,
    List<Lesson>? lessons,
    int? totalStudents,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      price: price ?? this.price,
      points: points ?? this.points,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isLiked: isLiked ?? this.isLiked.value,
      thumbnail: thumbnail ?? this.thumbnail,
      lessons: lessons ?? this.lessons,
    );
  }
}
