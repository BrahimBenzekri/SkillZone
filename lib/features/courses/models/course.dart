import 'package:get/get.dart';
import 'course_type.dart';

class Course {
  final String id;
  final String title;
  final double rating;
  final Duration duration;
  final CourseType type;
  final int? price; // null means free
  final int? points; // points needed for hard skills or earned for soft skills
  final RxBool isLiked;
  final String thumbnail;

  Course({
    required this.id,
    required this.title,
    required this.rating,
    required this.duration,
    required this.type,
    this.price,
    this.points,
    bool isLiked = false,
    required this.thumbnail,
  }) : isLiked = isLiked.obs;

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
      return 'Free • Earn ${points ?? 0} points';
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
        'rating': rating,
        'duration': duration.inMinutes,
        'type': type.toString(),
        'price': price,
        'points': points,
        'isLiked': isLiked.value,
        'thumbnail': thumbnail,
      };

  // Create from JSON for API communication
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        title: json['title'],
        rating: json['rating'].toDouble(),
        duration: Duration(minutes: json['duration']),
        type: CourseType.values.firstWhere((e) => e.toString() == json['type'],
            orElse: () => CourseType.soft),
        price: json['price'],
        points: json['points'],
        isLiked: json['isLiked'],
        thumbnail: json['thumbnail'],
      );
}
