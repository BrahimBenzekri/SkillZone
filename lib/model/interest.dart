import 'package:get/get.dart';

class Interest {
  String name;
  RxBool isSelected; // Makes selection reactive

  Interest(this.name, {bool isSelected = false}) : isSelected = isSelected.obs;
}
