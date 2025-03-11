class Lesson {
  final String id;
  final String title;
  final int number;
  final Duration duration;
  final bool isCompleted;
  final String? videoUrl;

  Lesson({
    required this.id,
    required this.title,
    required this.number,
    required this.duration,
    this.isCompleted = false,
    this.videoUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        number: json['number'],
        duration: Duration(minutes: json['duration']),
        isCompleted: json['isCompleted'] ?? false,
        videoUrl: json['videoUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'number': number,
        'duration': duration.inMinutes,
        'isCompleted': isCompleted,
        'videoUrl': videoUrl,
      };
}