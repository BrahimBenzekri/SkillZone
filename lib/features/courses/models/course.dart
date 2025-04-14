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
  final int? price; // null means free
  final int points; // points needed for hard skills or earned for soft skills
  final RxBool isLiked;
  final String thumbnail;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.type,
    this.price,
    required this.points,
    bool isLiked = false,
    required this.thumbnail,
    this.lessons = const [],
  }) : isLiked = isLiked.obs;

  int get completedLessons =>
      lessons.where((lesson) => lesson.isCompleted).length;
  int get totalLessons => lessons.length;
  double get progress =>
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
      if (price != null) {
        return '\$${price.toString()}';
      } else {
        return '${points.toString()} points';
      }
    }
  }

  // Convert to JSON for API communication
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'rating': rating,
        'duration': duration.inMinutes,
        'type': type.toString(),
        'price': price,
        'points': points,
        'isLiked': isLiked.value,
        'thumbnail': thumbnail,
        'lessons': lessons.map((e) => e.toJson()).toList(),
      };

  // Create from JSON for API communication
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        rating: json['rating'].toDouble(),
        duration: Duration(minutes: json['duration']),
        type: CourseType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => CourseType.soft,
        ),
        price: json['price'],
        points: json['points'],
        isLiked: json['isLiked'],
        thumbnail: json['thumbnail'],
        lessons: (json['lessons'] as List?)
                ?.map((e) => Lesson.fromJson(e))
                .toList() ??
            [],
      );

  Course copyWith({
    String? id,
    String? title,
    String? description,
    double? rating,
    Duration? duration,
    CourseType? type,
    int? price,
    int? points,
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
      isLiked: isLiked ?? this.isLiked.value,
      thumbnail: thumbnail ?? this.thumbnail,
      lessons: lessons ?? this.lessons,
    );
  }
}
