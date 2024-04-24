import 'package:get/get.dart';

class User {
  User(this.name, this.age);

  String name;
  int age;
}

class Controller extends GetxController {
  static Controller get of => Get.find();
  var count = 0.obs;
  final userList = <User>[].obs;

  addCount() => count++;
}
