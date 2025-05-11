enum UserType {
  student,
  teacher;

  bool get isTeacher => this == UserType.teacher ? true : false;
}