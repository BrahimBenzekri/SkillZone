enum UserType {
  student,
  teacher;

  bool get isTeacher => this == UserType.teacher;
  bool get isStudent => this == UserType.student;
}