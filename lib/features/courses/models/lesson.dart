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
        id: json['id'].toString(),
        title: json['title'],
        number: json['number'] ?? 1,
        duration: Duration(minutes: json['duration'] ?? 0),
        isCompleted: false,
        videoUrl: json['video_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'number': number,
        'duration': duration.inMinutes,
        'is_completed': isCompleted,
        'video_url': videoUrl,
      };
}
